package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.Etudiant;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface EtudiantRepository extends JpaRepository<Etudiant, Long> {
    List<Etudiant> findTop10ByOrderByScoreReputationDesc();
}