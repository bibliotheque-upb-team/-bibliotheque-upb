package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface EmpruntRepository extends JpaRepository<Emprunt, Long> {
    List<Emprunt> findByEtudiant(Etudiant etudiant);
    List<Emprunt> findByStatut(Emprunt.StatutEmprunt statut);
    List<Emprunt> findByEtudiantAndStatut(Etudiant etudiant, Emprunt.StatutEmprunt statut);
    long countByStatut(Emprunt.StatutEmprunt statut);
}
