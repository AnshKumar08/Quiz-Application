package com.quiz.quiz.dto;

import java.util.List;

public class SubmitRequest {

    private String category;
    private List<AnswerItem> answers;

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public List<AnswerItem> getAnswers() { return answers; }
    public void setAnswers(List<AnswerItem> answers) { this.answers = answers; }

    public static class AnswerItem {
        private Long questionId;
        private String selected;

        public Long getQuestionId() { return questionId; }
        public void setQuestionId(Long questionId) { this.questionId = questionId; }

        public String getSelected() { return selected; }
        public void setSelected(String selected) { this.selected = selected; }
    }
}
