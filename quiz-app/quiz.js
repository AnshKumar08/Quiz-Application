// ------------------ Globals ------------------

let questions = [];
let answers = {};
let timerInterval;
let totalTime = 15 * 60;

const optionMap = ["A", "B", "C", "D"];
const urlParams = new URLSearchParams(window.location.search);
const quizType = urlParams.get("type") || "java";

const accessTokenKey = "accessToken";
const refreshTokenKey = "refreshToken";

// ------------------ App Initialization ------------------

window.onload = () => {
  if (!getAccessToken()) {
    showAuthModal();
  } else {
    fetchQuestions();
  }

  // Bind login/signup forms
  document.getElementById("login-form").onsubmit = function (e) {
    e.preventDefault();
    const username = this.username.value.trim();
    const password = this.password.value.trim();
    loginUser(username, password);
  };

  document.getElementById("signup-form").onsubmit = function (e) {
    e.preventDefault();
    const username = this.username.value.trim();
    const password = this.password.value.trim();
    signupUser(username, password);
  };
};

function showAuthModal() {
  document.getElementById("auth-modal").style.display = "flex";
}
function hideAuthModal() {
  document.getElementById("auth-modal").style.display = "none";
}

// ------------------ Token Helpers ------------------

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
  showAuthModal();
}

// Generic fetch with token refresh
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

// Refresh token flow
async function refreshAccessToken() {
  const refreshToken = getRefreshToken();
  if (!refreshToken) return false;

  try {
    const res = await fetch("http://localhost:8080/api/auth/refresh", {
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

// ------------------ Auth Functions ------------------

async function loginUser(username, password) {
  try {
    const res = await fetch("http://localhost:8080/api/auth/login", {
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
    const res = await fetch("http://localhost:8080/api/auth/signup", {
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

// ------------------ Quiz Flow ------------------

async function fetchQuestions() {
  if (!getAccessToken()) {
    showAuthModal();
    return;
  }

  try {
    const res = await apiFetch(
      `http://localhost:8080/api/questions/${quizType}?count=10`
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
    button.innerHTML = `<span class="option-label">${optionMap[idx]}.</span> ${optionText}`;
    button.className = "option";
    button.onclick = () =>
      selectAnswer(index, optionMap[idx], optionText, button);

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

function selectAnswer(qIndex, selectedOption, selectedText, button) {
  const correctAnswerRaw = questions[qIndex].correctAnswer.trim().toUpperCase();
  const selectedTextUpper = selectedText.trim().toUpperCase();

  answers[qIndex] = {
    selected: selectedOption,
    correct:
      correctAnswerRaw === selectedOption ||
      correctAnswerRaw === selectedTextUpper,
  };

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

function submitQuiz() {
  clearInterval(timerInterval);
  const totalCorrect = Object.values(answers).filter((a) => a.correct).length;

  const breakdown = questions.map((q, idx) => {
    const userAnswer = answers[idx]?.selected || "Not Answered";
    const correctAnswer = q.correctAnswer || "Not Available";

    return {
      questionText: q.questionText,
      userAnswer: userAnswer.toUpperCase(),
      correctAnswer: correctAnswer.toUpperCase(),
      isCorrect: answers[idx]?.correct || false,
    };
  });

  localStorage.setItem("quizScore", totalCorrect);
  localStorage.setItem("totalQuestions", questions.length);
  localStorage.setItem("breakdown", JSON.stringify(breakdown));

  window.location.href = "result.html";
}
