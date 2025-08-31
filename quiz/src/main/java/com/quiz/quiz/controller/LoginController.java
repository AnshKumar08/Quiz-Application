package com.quiz.quiz.controller;

import com.quiz.quiz.dto.LoginRequest;
import com.quiz.quiz.entity.QuizQuestion;
import com.quiz.quiz.service.QuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@CrossOrigin(origins = "http://127.0.0.1:5500")  // frontend origin
@RestController
@RequestMapping("/api")
public class LoginController {

    @Autowired
    private QuestionService questionService;

//    private final String USERNAME = "user";
//    private final String PASSWORD = "password";
//
//    @PostMapping("/login")
//    public String login(@RequestBody LoginRequest loginRequest) {
//        if (USERNAME.equals(loginRequest.getUsername()) && PASSWORD.equals(loginRequest.getPassword())) {
//            return "Login Successful!";
//        } else {
//            return "Invalid username or password";
//        }
//    }

    @GetMapping("/questions")
    public List<QuizQuestion> getAllQuestions() {
        return questionService.getAllQuestions();
    }

    @GetMapping("/questions/{category}")
    public List<QuizQuestion> getQuestionsByCategory(
            @PathVariable String category,
            @RequestParam(defaultValue = "8") int count) {

        List<QuizQuestion> allQuestions = questionService.getQuestionsByCategory(category);

        Collections.shuffle(allQuestions);  // Randomize

        if (count >= allQuestions.size()) {
            return allQuestions;
        } else {
            return allQuestions.subList(0, count);
        }
    }

    @PostMapping(value = "/save", consumes = "application/json", produces = "application/json")
    public QuizQuestion saveQuestion(@RequestBody QuizQuestion question) {
        return questionService.saveQuestion(question);
    }
}
