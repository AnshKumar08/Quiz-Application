package com.quiz.quiz.dto;

import java.util.List;

public class SubmitResponse {

    private int score;
    private int total;
    private List<QuestionResult> results;

    public SubmitResponse() {}

    public SubmitResponse(int score, int total, List<QuestionResult> results) {
        this.score = score;
        this.total = total;
        this.results = results;
    }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public int getTotal() { return total; }
    public void setTotal(int total) { this.total = total; }

    public List<QuestionResult> getResults() { return results; }
    public void setResults(List<QuestionResult> results) { this.results = results; }

    public static class QuestionResult {
        private Long questionId;
        private String questionText;
        private boolean correct;
        private String userAnswer;
        private String correctAnswer;

        public QuestionResult() {}

        public QuestionResult(Long questionId, String questionText, boolean correct,
                              String userAnswer, String correctAnswer) {
            this.questionId = questionId;
            this.questionText = questionText;
            this.correct = correct;
            this.userAnswer = userAnswer;
            this.correctAnswer = correctAnswer;
        }

        public Long getQuestionId() { return questionId; }
        public void setQuestionId(Long questionId) { this.questionId = questionId; }

        public String getQuestionText() { return questionText; }
        public void setQuestionText(String questionText) { this.questionText = questionText; }

        public boolean isCorrect() { return correct; }
        public void setCorrect(boolean correct) { this.correct = correct; }

        public String getUserAnswer() { return userAnswer; }
        public void setUserAnswer(String userAnswer) { this.userAnswer = userAnswer; }

        public String getCorrectAnswer() { return correctAnswer; }
        public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }
    }
}
