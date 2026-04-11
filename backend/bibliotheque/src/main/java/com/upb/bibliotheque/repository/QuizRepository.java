package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface QuizRepository extends JpaRepository<Quiz, Long> {
    List<Quiz> findByActifTrue();
}