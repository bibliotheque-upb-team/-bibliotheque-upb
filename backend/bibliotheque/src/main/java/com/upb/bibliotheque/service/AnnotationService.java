package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AnnotationService {
    private final AnnotationRepository annotationRepo;
    private final EtudiantRepository etudiantRepo;
    private final LivreRepository livreRepo;
    private final NotificationService notifService;
    private final GamificationService gamifService;

    public Annotation creer(Long etudiantId, Long livreId, String texte, Integer page) {
        Etudiant e = etudiantRepo.findById(etudiantId).orElseThrow(() -> new RuntimeException("Non trouvé"));
        Livre l = livreRepo.findById(livreId).orElseThrow(() -> new RuntimeException("Non trouvé"));
        Annotation a = new Annotation();
        a.setEtudiant(e); a.setLivre(l); a.setTexteAnnotation(texte);
        a.setNumeroPage(page); a.setApprouvee(true);
        notifService.envoyer(etudiantId, "Annotation Publiée",
            "Votre annotation a été publiée.", Notification.TypeNotification.SUCCESS);
        gamifService.ajouterPoints(etudiantId, 5);
        return annotationRepo.save(a);
    }

    public void supprimer(Long id) { annotationRepo.deleteById(id); }

    public Annotation voter(Long id) {
        Annotation a = annotationRepo.findById(id).orElseThrow(() -> new RuntimeException("Non trouvée"));
        a.setNombreVotes(a.getNombreVotes() + 1);
        return annotationRepo.save(a);
    }

    public List<Annotation> toutes() { return annotationRepo.findAll(); }

    public List<Annotation> parLivre(Long livreId) {
        return annotationRepo.findByLivre(livreRepo.findById(livreId)
            .orElseThrow(() -> new RuntimeException("Non trouvé")));
    }
}
