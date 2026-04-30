package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class EmpruntService {
    private final EmpruntRepository empruntRepo;
    private final LivreRepository livreRepo;
    private final EtudiantRepository etudiantRepo;
    private final AuditService auditService;
    private final NotificationService notifService;

    @Transactional
    public Emprunt emprunterLivre(Long etudiantId, Long livreId) {
        Etudiant etudiant = etudiantRepo.findById(etudiantId)
            .orElseThrow(() -> new RuntimeException("Étudiant non trouvé"));
        List<Emprunt> retards = empruntRepo.findByEtudiantAndStatut(etudiant, Emprunt.StatutEmprunt.EN_RETARD);
        if (!retards.isEmpty()) {
            notifService.envoyer(etudiantId, "Emprunt Refusé", "Vous avez des emprunts en retard.", Notification.TypeNotification.ERROR);
            throw new RuntimeException("Emprunts en retard détectés");
        }
        Livre livre = livreRepo.findById(livreId)
            .orElseThrow(() -> new RuntimeException("Livre non trouvé"));
        if (!livre.estDisponible()) {
            notifService.envoyer(etudiantId, "Emprunt Impossible", "Livre indisponible. Vous pouvez réserver.", Notification.TypeNotification.WARNING);
            throw new RuntimeException("Aucun exemplaire disponible");
        }
        Emprunt emprunt = new Emprunt();
        emprunt.setEtudiant(etudiant);
        emprunt.setLivre(livre);
        livre.setExemplairesDisponibles(livre.getExemplairesDisponibles() - 1);
        livreRepo.save(livre);
        auditService.enregistrer("EMPRUNT_CREE", "Livre emprunté : " + livre.getTitre(), etudiant);
        notifService.envoyer(etudiantId, "Confirmation d'emprunt",
            "Emprunté : " + livre.getTitre() + ". Retour : " + emprunt.getDateRetourPrevue(),
            Notification.TypeNotification.SUCCESS);
        return empruntRepo.save(emprunt);
    }

    @Transactional
    public Emprunt retournerLivre(Long empruntId) {
        Emprunt emprunt = empruntRepo.findById(empruntId)
            .orElseThrow(() -> new RuntimeException("Non trouvé"));
        emprunt.setDateRetourEffective(LocalDate.now());
        emprunt.setStatut(Emprunt.StatutEmprunt.RETOURNE);
        Livre livre = emprunt.getLivre();
        livre.setExemplairesDisponibles(livre.getExemplairesDisponibles() + 1);
        livreRepo.save(livre);
        auditService.enregistrer("LIVRE_RETOURNE", "Retour : " + livre.getTitre(), emprunt.getEtudiant());
        return empruntRepo.save(emprunt);
    }

    @Transactional
    public Emprunt prolongerEmprunt(Long empruntId, Long etudiantId) {
        Emprunt emprunt = empruntRepo.findById(empruntId)
            .orElseThrow(() -> new RuntimeException("Non trouvé"));
        Etudiant etudiant = etudiantRepo.findById(etudiantId)
            .orElseThrow(() -> new RuntimeException("Non trouvé"));
        if (!empruntRepo.findByEtudiantAndStatut(etudiant, Emprunt.StatutEmprunt.EN_RETARD).isEmpty()) {
            notifService.envoyer(etudiantId, "Prolongation Refusée", "Retards détectés.", Notification.TypeNotification.ERROR);
            throw new RuntimeException("Retards détectés");
        }
        if (etudiant.getScoreReputation() < 300) {
            notifService.envoyer(etudiantId, "Prolongation Refusée", "Crédibilité insuffisante (min. 300 pts).", Notification.TypeNotification.WARNING);
            throw new RuntimeException("Crédibilité insuffisante");
        }
        if (emprunt.getNombreProlongations() >= 1) {
            notifService.envoyer(etudiantId, "Prolongation Refusée", "Max 1 prolongation par emprunt.", Notification.TypeNotification.WARNING);
            throw new RuntimeException("Limite atteinte");
        }
        emprunt.setDateRetourPrevue(emprunt.getDateRetourPrevue().plusDays(7));
        emprunt.setNombreProlongations(1);
        auditService.enregistrer("EMPRUNT_PROLONGE", "Prolongation : " + emprunt.getLivre().getTitre(), etudiant);
        notifService.envoyer(etudiantId, "Prolongation Accordée",
            "Prolongé de 7 jours : " + emprunt.getLivre().getTitre(), Notification.TypeNotification.SUCCESS);
        return empruntRepo.save(emprunt);
    }

    public List<Emprunt> historiqueEtudiant(Long etudiantId) {
        return empruntRepo.findByEtudiant(etudiantRepo.findById(etudiantId)
            .orElseThrow(() -> new RuntimeException("Non trouvé")));
    }

    public List<Emprunt> listerTous() { return empruntRepo.findAll(); }
    public long compterParStatut(Emprunt.StatutEmprunt s) { return empruntRepo.countByStatut(s); }
}
