package com.quiz.quiz.controller;

import com.quiz.quiz.dto.ScoreHistoryDTO;
import com.quiz.quiz.dto.SubmitRequest;
import com.quiz.quiz.dto.SubmitResponse;
import com.quiz.quiz.entity.QuizQuestion;
import com.quiz.quiz.entity.ScoreHistory;
import com.quiz.quiz.entity.User;
import com.quiz.quiz.repo.QuestionRepo;
import com.quiz.quiz.repo.ScoreHistoryRepo;
import com.quiz.quiz.repo.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@RestController
public class QuizSubmitController {

    @Autowired private QuestionRepo questionRepo;
    @Autowired private ScoreHistoryRepo scoreHistoryRepo;
    @Autowired private UserRepo userRepo;

    @PostMapping("/api/questions/submit")
    public ResponseEntity<SubmitResponse> submitQuiz(
            @RequestBody SubmitRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {

        if (userDetails == null) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED).build();
        }

        if (request == null || request.getAnswers() == null || request.getAnswers().isEmpty() || request.getAnswers().size() > 50) {
            return ResponseEntity.badRequest().build();
        }

        List<SubmitResponse.QuestionResult> results = new ArrayList<>();
        int score = 0;
        java.util.Set<Long> processedQuestionIds = new java.util.HashSet<>();

        for (SubmitRequest.AnswerItem item : request.getAnswers()) {
            if (item == null || item.getQuestionId() == null) continue;

            // Prevent score tampering by ignoring duplicate question submissions
            if (!processedQuestionIds.add(item.getQuestionId())) {
                continue;
            }

            QuizQuestion q = questionRepo.findById(item.getQuestionId()).orElse(null);
            if (q == null) continue;

            String correctLetter = q.getCorrectAnswer() != null ? q.getCorrectAnswer().trim().toLowerCase() : "";
            String selectedLetter = item.getSelected() != null
                    ? item.getSelected().trim().toLowerCase()
                    : "";

            boolean isCorrect = !correctLetter.isEmpty() && correctLetter.equals(selectedLetter);
            if (isCorrect) score++;

            String displayAnswer = item.getSelected() != null && !item.getSelected().isBlank()
                    ? item.getSelected().trim().toUpperCase()
                    : "Not Answered";

            results.add(new SubmitResponse.QuestionResult(
                    q.getId(),
                    q.getQuestionText(),
                    isCorrect,
                    displayAnswer,
                    correctLetter.toUpperCase()
            ));
        }

        if (userDetails != null) {
            final int finalScore = score;
            userRepo.findByUsername(userDetails.getUsername()).ifPresent(user -> {
                ScoreHistory history = new ScoreHistory();
                history.setUser(user);
                history.setScore(finalScore);

                // Sanitize category to prevent database column truncation crashes
                String safeCategory = request.getCategory() != null ? request.getCategory().trim() : "unknown";
                if (safeCategory.length() > 50) {
                    safeCategory = safeCategory.substring(0, 50);
                }
                history.setCategory(safeCategory);
                history.setAttemptedAt(LocalDateTime.now());
                scoreHistoryRepo.save(history);
            });
        }

        return ResponseEntity.ok(new SubmitResponse(score, results.size(), results));
    }

    @GetMapping("/api/scores")
    public ResponseEntity<List<ScoreHistoryDTO>> getMyScores(
            @AuthenticationPrincipal UserDetails userDetails) {

        if (userDetails == null) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED).build();
        }

        User user = userRepo.findByUsername(userDetails.getUsername())
                .orElse(null);

        if (user == null) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED).build();
        }

        List<ScoreHistoryDTO> history = scoreHistoryRepo.findByUser(user).stream()
                .map(h -> new ScoreHistoryDTO(
                        h.getId(),
                        h.getScore(),
                        h.getCategory(),
                        h.getAttemptedAt() != null ? h.getAttemptedAt().toString() : ""
                ))
                .collect(Collectors.toList());

        return ResponseEntity.ok(history);
    }
}
