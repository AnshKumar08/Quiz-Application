let questions = [];
let answers = {};
let timerInterval;
let totalTime = 15 * 60;

const optionMap = ["A", "B", "C", "D"];
const urlParams = new URLSearchParams(window.location.search);
const quizType = urlParams.get("type") || "java";

const accessTokenKey = "accessToken";
const refreshTokenKey = "refreshToken";

window.onload = () => {
  if (!getAccessToken()) {
    showAuthModal();
  } else {
    fetchQuestions();
  }

  const loginForm = document.getElementById("login-form");
  if (loginForm) {
    loginForm.onsubmit = function (e) {
      e.preventDefault();
      const username = this.username.value.trim();
      const password = this.password.value.trim();
      loginUser(username, password);
    };
  }

  const signupForm = document.getElementById("signup-form");
  if (signupForm) {
    signupForm.onsubmit = function (e) {
      e.preventDefault();
      const username = this.username.value.trim();
      const password = this.password.value.trim();
      signupUser(username, password);
    };
  }
};

function showAuthModal() {
  const modal = document.getElementById("auth-modal");
  if (modal) modal.style.display = "flex";
  else window.location.href = "login.html";
}
function hideAuthModal() {
  const modal = document.getElementById("auth-modal");
  if (modal) modal.style.display = "none";
}

function getAccessToken() {
  return localStorage.getItem(accessTokenKey);
}
function getRefreshToken() {
  return localStorage.getItem(refreshTokenKey);
}
function setTokens(accessToken, refreshToken) {
  if (accessToken) localStorage.setItem(accessTokenKey, accessToken);
  if (refreshToken) localStorage.setItem(refreshTokenKey, refreshToken);
}
function clearTokens() {
  localStorage.removeItem(accessTokenKey);
  localStorage.removeItem(refreshTokenKey);
  localStorage.removeItem("expiresIn");
  localStorage.removeItem("loginTime");
  showAuthModal();
}

async function apiFetch(url, options = {}) {
  let token = getAccessToken();
  options.headers = {
    ...(options.headers || {}),
    Authorization: "Bearer " + token,
    "Content-Type": "application/json",
  };

  let res = await fetch(url, options);
  if (res.status === 401) {
    const refreshed = await refreshAccessToken();
    if (!refreshed) {
      clearTokens();
      return res;
    }
    token = getAccessToken();
    options.headers.Authorization = "Bearer " + token;
    res = await fetch(url, options);
  }
  return res;
}

async function refreshAccessToken() {
  const refreshToken = getRefreshToken();
  if (!refreshToken) return false;

  try {
    const res = await fetch(`${API_BASE}/api/auth/refresh`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ refreshToken }),
    });
    if (res.ok) {
      const data = await res.json();
      setTokens(data.accessToken, data.refreshToken);
      return true;
    }
    return false;
  } catch (err) {
    console.error("Refresh error:", err);
    return false;
  }
}

async function loginUser(username, password) {
  try {
    const res = await fetch(`${API_BASE}/api/auth/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password }),
    });

    if (res.ok) {
      const data = await res.json();
      setTokens(data.accessToken, data.refreshToken);
      hideAuthModal();
      fetchQuestions();
    } else {
      alert("Login failed. Please check credentials.");
    }
  } catch (err) {
    alert("Login error: " + err.message);
  }
}

async function signupUser(username, password) {
  try {
    const res = await fetch(`${API_BASE}/api/auth/signup`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password }),
    });

    const text = await res.text();
    if (res.ok) {
      alert("Signup successful. You can now log in.");
      document.getElementById("signup-form").reset();
    } else {
      alert("Signup failed: " + text);
    }
  } catch (err) {
    alert("Signup error: " + err.message);
  }
}

async function fetchQuestions() {
  if (!getAccessToken()) {
    showAuthModal();
    return;
  }

  try {
    const res = await apiFetch(
      `${API_BASE}/api/questions/${quizType}?count=10`
    );

    if (!res.ok) {
      alert("Unable to fetch questions. Please login again.");
      clearTokens();
      return;
    }

    questions = await res.json();
    renderQuestionNav();
    loadQuestion(0);
    startGlobalTimer();
  } catch (err) {
    document.getElementById("question-text").innerText =
      "Failed to load questions.";
  }
}

function renderQuestionNav() {
  const nav = document.getElementById("question-nav");
  nav.innerHTML = "";
  for (let i = 0; i < questions.length; i++) {
    const btn = document.createElement("button");
    btn.innerText = i + 1;
    btn.className = "question-number unanswered";
    btn.id = `qnav-${i}`;
    btn.onclick = () => loadQuestion(i);
    nav.appendChild(btn);
  }
}

function loadQuestion(index) {
  const q = questions[index];
  document.getElementById("question-text").innerText = q.questionText;
  document.getElementById("current-question").innerText = index + 1;
  document.getElementById("total-questions").innerText = questions.length;

  const optionsContainer = document.getElementById("options-container");
  optionsContainer.innerHTML = "";

  q.options.forEach((optionText, idx) => {
    const button = document.createElement("button");
    const labelSpan = document.createElement("span");
    labelSpan.className = "option-label";
    labelSpan.textContent = optionMap[idx] + ".";
    button.appendChild(labelSpan);
    button.appendChild(document.createTextNode(" " + optionText));
    button.className = "option";
    button.onclick = () => selectAnswer(index, optionMap[idx], button);

    if (answers[index] && answers[index].selected === optionMap[idx]) {
      button.classList.add("selected");
    }

    optionsContainer.appendChild(button);
  });

  const nextButton = document.getElementById("next-button");
  const submitButton = document.getElementById("submit-button");

  if (index === questions.length - 1) {
    nextButton.style.display = "none";
    submitButton.style.display = "inline-block";
    submitButton.onclick = () => submitQuiz();
  } else {
    nextButton.style.display = "inline-block";
    submitButton.style.display = "none";
    nextButton.onclick = () => loadQuestion(index + 1);
  }
}

function selectAnswer(qIndex, selectedOption, button) {
  answers[qIndex] = { selected: selectedOption };

  document
    .querySelectorAll(".option")
    .forEach((btn) => btn.classList.remove("selected"));
  button.classList.add("selected");

  updateNavButton(qIndex);
}

function updateNavButton(qIndex) {
  const btn = document.getElementById(`qnav-${qIndex}`);
  if (answers[qIndex]) {
    btn.classList.remove("unanswered");
    btn.classList.add("answered");
  } else {
    btn.classList.remove("answered");
    btn.classList.add("unanswered");
  }
}

function startGlobalTimer() {
  updateTimerDisplay();
  timerInterval = setInterval(() => {
    totalTime--;
    updateTimerDisplay();
    if (totalTime <= 0) {
      clearInterval(timerInterval);
      submitQuiz();
    }
  }, 1000);
}

function updateTimerDisplay() {
  const timerDisplay = document.getElementById("timer");
  const minutes = Math.floor(totalTime / 60)
    .toString()
    .padStart(2, "0");
  const seconds = (totalTime % 60).toString().padStart(2, "0");
  timerDisplay.innerText = `${minutes}:${seconds}`;

  const timerContainer = document.querySelector(".timer-container");
  if (totalTime <= 60) {
    timerContainer.classList.add("red");
  } else {
    timerContainer.classList.remove("red");
  }
}

async function submitQuiz() {
  clearInterval(timerInterval);

  const submitPayload = {
    category: quizType,
    answers: questions.map((q, idx) => ({
      questionId: q.id,
      selected: answers[idx]?.selected?.toLowerCase() || null,
    })),
  };

  try {
    const res = await apiFetch(`${API_BASE}/api/questions/submit`, {
      method: "POST",
      body: JSON.stringify(submitPayload),
    });

    if (!res.ok) {
      alert("Failed to submit quiz. Please try again.");
      return;
    }

    const result = await res.json();

    localStorage.setItem("quizScore", result.score);
    localStorage.setItem("totalQuestions", result.total);
    localStorage.setItem("quizCategory", quizType);
    localStorage.setItem("breakdown", JSON.stringify(result.results));

    window.location.href = "result.html";
  } catch (err) {
    console.error("Submit error:", err);
    alert("Error submitting quiz: " + err.message);
  }
}
