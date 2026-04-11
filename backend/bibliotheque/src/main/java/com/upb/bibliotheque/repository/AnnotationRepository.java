package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AnnotationRepository extends JpaRepository<Annotation, Long> {
    List<Annotation> findByLivre(Livre livre);
    List<Annotation> findByApprouveeFalse();
}