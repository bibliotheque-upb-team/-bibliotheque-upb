package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface ParticipationRepository extends JpaRepository<Participation, Long> {
    List<Participation> findByEtudiant(Etudiant etudiant);
}