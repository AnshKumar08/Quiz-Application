package com.quiz.quiz.repo;

import com.quiz.quiz.entity.ScoreHistory;
import com.quiz.quiz.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ScoreHistoryRepo extends JpaRepository<ScoreHistory, Long> {
    List<ScoreHistory> findByUser(User user);
}
