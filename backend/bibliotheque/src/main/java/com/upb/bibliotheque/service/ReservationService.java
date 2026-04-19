package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReservationService {
    private final ReservationRepository reservationRepo;
    private final LivreRepository livreRepo;
    private final EtudiantRepository etudiantRepo;
    private final EmpruntRepository empruntRepo;
    private final AuditService auditService;
    private final NotificationService notifService;

    @Transactional
    public Reservation reserverLivre(Long etudiantId, Long livreId) {
        Etudiant etudiant = etudiantRepo.findById(etudiantId)
            .orElseThrow(() -> new RuntimeException("Non trouvé"));
        Livre livre = livreRepo.findById(livreId)
            .orElseThrow(() -> new RuntimeException("Non trouvé"));
        if (!empruntRepo.findByEtudiantAndStatut(etudiant, Emprunt.StatutEmprunt.EN_RETARD).isEmpty()) {
            notifService.envoyer(etudiantId, "Réservation Refusée", "Régularisez vos retards.", Notification.TypeNotification.ERROR);
            throw new RuntimeException("Retards détectés");
        }
        long nbEnAttente = reservationRepo.countByLivreAndStatut(livre, Reservation.StatutReservation.EN_ATTENTE);
        Reservation.StatutReservation statut = livre.estDisponible()
            ? Reservation.StatutReservation.CONFIRMEE
            : Reservation.StatutReservation.EN_ATTENTE;
        Reservation r = new Reservation();
        r.setEtudiant(etudiant); r.setLivre(livre);
        r.setPositionFileAttente((int) nbEnAttente + 1);
        r.setStatut(statut);
        auditService.enregistrer("RESERVATION_CREEE",
            "Réservé : " + livre.getTitre() + " (" + statut + ")", etudiant);
        notifService.envoyer(etudiantId, "Réservation Enregistrée",
            "Réservation " + (statut == Reservation.StatutReservation.CONFIRMEE ? "confirmée" : "en attente") + " : " + livre.getTitre(),
            Notification.TypeNotification.SUCCESS);
        return reservationRepo.save(r);
    }

    public Reservation annuler(Long id) {
        Reservation r = reservationRepo.findById(id).orElseThrow(() -> new RuntimeException("Non trouvée"));
        r.setStatut(Reservation.StatutReservation.ANNULEE);
        return reservationRepo.save(r);
    }

    public Reservation refuser(Long id) {
        Reservation r = reservationRepo.findById(id).orElseThrow(() -> new RuntimeException("Non trouvée"));
        r.setStatut(Reservation.StatutReservation.REFUSEE);
        notifService.envoyer(r.getEtudiant().getUtilisateurId(), "Réservation Refusée",
            "Refusée : " + r.getLivre().getTitre(), Notification.TypeNotification.WARNING);
        return reservationRepo.save(r);
    }

    public Reservation confirmer(Long id) {
        Reservation r = reservationRepo.findById(id).orElseThrow(() -> new RuntimeException("Non trouvée"));
        r.setStatut(Reservation.StatutReservation.CONFIRMEE);
        notifService.envoyer(r.getEtudiant().getUtilisateurId(), "Réservation Confirmée",
            "Confirmée : " + r.getLivre().getTitre(), Notification.TypeNotification.SUCCESS);
        return reservationRepo.save(r);
    }

    public List<Reservation> mesReservations(Long etudiantId) {
        return reservationRepo.findByEtudiant(etudiantRepo.findById(etudiantId)
            .orElseThrow(() -> new RuntimeException("Non trouvé")));
    }

    public List<Reservation> enAttente() {
        return reservationRepo.findByStatut(Reservation.StatutReservation.EN_ATTENTE);
    }
}
