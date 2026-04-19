package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {
    private final NotificationRepository notifRepo;
    private final UtilisateurRepository utilisateurRepo;

    public Notification envoyer(Long utilisateurId, String titre, String message, Notification.TypeNotification type) {
        Utilisateur user = utilisateurRepo.findById(utilisateurId)
            .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
        Notification notif = new Notification();
        notif.setUtilisateur(user);
        notif.setTitre(titre);
        notif.setMessage(message);
        notif.setType(type);
        return notifRepo.save(notif);
    }

    public void envoyerATousLesEtudiants(String titre, String message) {
        utilisateurRepo.findAll().stream()
            .filter(u -> u instanceof Etudiant)
            .forEach(u -> envoyer(u.getUtilisateurId(), titre, message, Notification.TypeNotification.INFO));
    }

    public List<Notification> nonLues(Long utilisateurId) {
        Utilisateur user = utilisateurRepo.findById(utilisateurId)
            .orElseThrow(() -> new RuntimeException("Non trouvé"));
        return notifRepo.findByUtilisateurAndLueFalse(user);
    }

    public Notification marquerLue(Long notifId) {
        Notification notif = notifRepo.findById(notifId)
            .orElseThrow(() -> new RuntimeException("Non trouvée"));
        notif.setLue(true);
        return notifRepo.save(notif);
    }

    public List<Notification> toutesParUtilisateur(Long utilisateurId) {
        Utilisateur user = utilisateurRepo.findById(utilisateurId)
            .orElseThrow(() -> new RuntimeException("Non trouvé"));
        return notifRepo.findByUtilisateurOrderByDateCreationDesc(user);
    }
}
