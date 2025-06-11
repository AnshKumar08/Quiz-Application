let currentQuestionIndex = 0;
let questions = [];
let correctAnswers = 0;
let totalQuestions = 0;

const optionMap = ["a", "b", "c", "d"]; // <─ add once, near the top

async function fetchQuestions() {
  try {
    const res = await fetch("http://localhost:8080/api/questions");
    if (!res.ok) throw new Error("Network response was not ok");
    questions = await res.json();
    totalQuestions = questions.length;
    document.getElementById("total-questions").textContent = totalQuestions;
    displayQuestion();
  } catch (err) {
    console.error("Error fetching questions:", err);
    document.getElementById("question-text").textContent =
      "Failed to load questions. Please try again.";
  }
}

function displayQuestion() {
  if (!questions.length) return;

  const q = questions[currentQuestionIndex];
  const questionText = document.getElementById("question-text");
  const optionsContainer = document.getElementById("options-container");

  questionText.textContent = q.questionText;
  optionsContainer.innerHTML = "";

  /* map option → letter → button */
  q.options.forEach((optionText, idx) => {
    const button = document.createElement("button");
    button.textContent = optionText;
    button.className = "option";
    button.dataset.letter = optionMap[idx]; // <─ store its letter
    button.onclick = () => checkAnswer(button.dataset.letter);
    optionsContainer.appendChild(button);
  });

  document.getElementById("current-question").textContent =
    currentQuestionIndex + 1;
}

function checkAnswer(selectedLetter) {
  const q = questions[currentQuestionIndex];
  if (selectedLetter === q.correctAnswer) correctAnswers++;
  nextQuestion();
}

function nextQuestion() {
  if (currentQuestionIndex < questions.length - 1) {
    currentQuestionIndex++;
    displayQuestion();
  } else {
    localStorage.setItem("quizScore", correctAnswers);
    localStorage.setItem("totalQuestions", totalQuestions);
    window.location.href = "result.html";
  }
}

window.onload = fetchQuestions;
