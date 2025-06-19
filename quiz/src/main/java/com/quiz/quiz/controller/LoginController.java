package com.quiz.quiz.controller;

import com.quiz.quiz.dto.QuestionResponseDTO;
import com.quiz.quiz.entity.QuizQuestion;
import com.quiz.quiz.service.QuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class LoginController {

    @Autowired
    private QuestionService questionService;

    @GetMapping("/questions")
    public List<QuestionResponseDTO> getAllQuestions() {
        return toDTO(questionService.getAllQuestions());
    }

    @GetMapping("/questions/{category}")
    public List<QuestionResponseDTO> getQuestionsByCategory(
            @PathVariable String category,
            @RequestParam(defaultValue = "8") int count) {

        List<QuizQuestion> all = questionService.getQuestionsByCategory(category);
        if (all == null || all.isEmpty()) {
            return Collections.emptyList();
        }
        Collections.shuffle(all);

        int safeCount = Math.max(1, Math.min(Math.min(count, 50), all.size()));
        List<QuizQuestion> selected = all.subList(0, safeCount);
        return toDTO(selected);
    }

    private List<QuestionResponseDTO> toDTO(List<QuizQuestion> questions) {
        return questions.stream()
                .map(q -> new QuestionResponseDTO(q.getId(), q.getQuestionText(), q.getCategory(), q.getOptions()))
                .collect(Collectors.toList());
    }
}
