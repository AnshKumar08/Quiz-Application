package com.quiz.quiz.dto;

public class QuestionResponseDTO {

    private Long id;
    private String questionText;
    private String category;
    private java.util.List<String> options;

    public QuestionResponseDTO() {}

    public QuestionResponseDTO(Long id, String questionText, String category, java.util.List<String> options) {
        this.id = id;
        this.questionText = questionText;
        this.category = category;
        this.options = options;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public java.util.List<String> getOptions() { return options; }
    public void setOptions(java.util.List<String> options) { this.options = options; }
}
