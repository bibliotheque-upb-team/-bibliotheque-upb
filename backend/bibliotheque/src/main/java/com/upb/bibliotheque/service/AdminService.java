package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
@RequiredArgsConstructor
public class AdminService {
    private final UtilisateurRepository utilisateurRepo;
    private final JournalAuditRepository auditRepo;
    private final EmpruntRepository empruntRepo;
    private final LivreRepository livreRepo;

    public List<Utilisateur> listerUtilisateurs() { return utilisateurRepo.findAll(); }

    public Utilisateur changerStatut(Long id, boolean actif) {
        Utilisateur u = utilisateurRepo.findById(id).orElseThrow(() -> new RuntimeException("Non trouvé"));
        u.setActif(actif);
        return utilisateurRepo.save(u);
    }

    public Map<String, Object> tableauDeBord() {
        Map<String, Object> s = new HashMap<>();
        List<Utilisateur> tous = utilisateurRepo.findAll();
        s.put("etudiants", tous.stream().filter(u -> u instanceof Etudiant).count());
        s.put("bibliothecaires", tous.stream().filter(u -> u instanceof Bibliothecaire).count());
        s.put("administrateurs", tous.stream().filter(u -> u instanceof Administrateur).count());
        s.put("totalLivres", livreRepo.count());
        s.put("empruntsEnRetard", empruntRepo.countByStatut(Emprunt.StatutEmprunt.EN_RETARD));
        return s;
    }

    public List<JournalAudit> listerAudits() { return auditRepo.findAllByOrderByDateActionDesc(); }
    public List<JournalAudit> auditsParUtilisateur(String email) { return auditRepo.findByEmailUtilisateur(email); }
}
