package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    List<Reservation> findByEtudiant(Etudiant etudiant);
    List<Reservation> findByStatut(Reservation.StatutReservation statut);
    long countByLivreAndStatut(Livre livre, Reservation.StatutReservation statut);
}