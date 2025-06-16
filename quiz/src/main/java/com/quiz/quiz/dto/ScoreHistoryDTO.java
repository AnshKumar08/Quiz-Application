package com.quiz.quiz.dto;

public class ScoreHistoryDTO {

    private Long id;
    private int score;
    private String category;
    private String attemptedAt;

    public ScoreHistoryDTO() {}

    public ScoreHistoryDTO(Long id, int score, String category, String attemptedAt) {
        this.id = id;
        this.score = score;
        this.category = category;
        this.attemptedAt = attemptedAt;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getAttemptedAt() { return attemptedAt; }
    public void setAttemptedAt(String attemptedAt) { this.attemptedAt = attemptedAt; }
}
