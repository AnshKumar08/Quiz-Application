package com.quiz.quiz.repo;

import com.quiz.quiz.entity.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuestionRepo extends JpaRepository<QuizQuestion, Long> {

    List<QuizQuestion> findByCategoryIgnoreCase(String category);

    @Query(value = "SELECT * FROM quiz_question WHERE LOWER(category) = LOWER(:category) ORDER BY RAND() LIMIT :count", nativeQuery = true)
    List<QuizQuestion> findRandomByCategory(@Param("category") String category, @Param("count") int count);
}
