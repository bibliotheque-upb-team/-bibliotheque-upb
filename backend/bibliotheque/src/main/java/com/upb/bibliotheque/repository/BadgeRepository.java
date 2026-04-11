package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface BadgeRepository extends JpaRepository<Badge, Long> {
    List<Badge> findByEtudiant(Etudiant etudiant);
}