package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface QuizQuestionRepository extends JpaRepository<QuizQuestion, Long> {
    List<QuizQuestion> findByQuiz(Quiz quiz);
}