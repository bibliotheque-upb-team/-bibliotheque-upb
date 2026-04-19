package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
@RequiredArgsConstructor
public class BibliothecaireService {
    private final EmpruntRepository empruntRepo;
    private final ReservationRepository reservationRepo;
    private final LivreRepository livreRepo;
    private final UtilisateurRepository utilisateurRepo;

    public Map<String, Object> tableauDeBord() {
        Map<String, Object> s = new HashMap<>();
        s.put("totalLivres", livreRepo.count());
        s.put("totalUtilisateurs", utilisateurRepo.count());
        s.put("empruntsEnCours", empruntRepo.countByStatut(Emprunt.StatutEmprunt.EN_COURS));
        s.put("empruntsEnRetard", empruntRepo.countByStatut(Emprunt.StatutEmprunt.EN_RETARD));
        s.put("reservationsEnAttente", reservationRepo.findByStatut(Reservation.StatutReservation.EN_ATTENTE).size());
        s.put("totalEmprunts", empruntRepo.count());
        return s;
    }

    public Map<String, Object> genererRapport() {
        Map<String, Object> r = tableauDeBord();
        r.put("empruntsRecents", empruntRepo.findAll().stream()
            .sorted((a, b) -> b.getDateEmprunt().compareTo(a.getDateEmprunt()))
            .limit(20).toList());
        r.put("dateGeneration", java.time.LocalDateTime.now().toString());
        return r;
    }
}
