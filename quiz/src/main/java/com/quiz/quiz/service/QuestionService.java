package com.quiz.quiz.service;

import com.quiz.quiz.entity.QuizQuestion;
import com.quiz.quiz.repo.QuestionRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class QuestionService {

    @Autowired
    private QuestionRepo questionRepo;

    public List<QuizQuestion> getAllQuestions() {
        return questionRepo.findAll();
    }

    public List<QuizQuestion> getQuestionsByCategory(String category) {
        return questionRepo.findByCategoryIgnoreCase(category);
    }

    public List<QuizQuestion> getRandomQuestionsByCategory(String category, int count) {
        List<QuizQuestion> questions = questionRepo.findByCategoryIgnoreCase(category);
        Collections.shuffle(questions);
        return questions.subList(0, Math.min(count, questions.size()));
    }

    public QuizQuestion saveQuestion(QuizQuestion question) {
        return questionRepo.save(question);
    }
}
