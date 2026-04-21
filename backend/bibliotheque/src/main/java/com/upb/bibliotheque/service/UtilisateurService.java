package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
@RequiredArgsConstructor
public class UtilisateurService {
    private final UtilisateurRepository utilisateurRepo;
    private final EtudiantRepository etudiantRepo;
    private final AuditService auditService;
    private final PasswordEncoder passwordEncoder;

    public Utilisateur inscrire(String email, String motDePasse, String nom, String prenom,
                                String filiere, String anneeEtude, String role) {
        if (utilisateurRepo.existsByEmail(email)) throw new RuntimeException("Email déjà utilisé");
        String prefix = switch (role) {
            case "ADMIN", "ADMINISTRATEUR" -> "ADM";
            case "LIBRARIAN", "BIBLIOTHECAIRE" -> "LIB";
            default -> "2025";
        };
        String identifiant = prefix + String.format("%03d", new Random().nextInt(1000));

        Utilisateur user;
        if ("ADMIN".equals(role) || "ADMINISTRATEUR".equals(role)) {
            Administrateur a = new Administrateur();
            a.setIdentifiant(identifiant); a.setEmail(email); a.setMotDePasse(motDePasse);
            a.setNom(nom); a.setPrenom(prenom);
            user = utilisateurRepo.save(a);
        } else if ("LIBRARIAN".equals(role) || "BIBLIOTHECAIRE".equals(role)) {
            Bibliothecaire b = new Bibliothecaire();
            b.setIdentifiant(identifiant); b.setEmail(email); b.setMotDePasse(motDePasse);
            b.setNom(nom); b.setPrenom(prenom);
            user = utilisateurRepo.save(b);
        } else {
            Etudiant e = new Etudiant();
            e.setIdentifiant(identifiant); e.setEmail(email); e.setMotDePasse(motDePasse);
            e.setNom(nom); e.setPrenom(prenom);
            e.setFiliere(filiere); e.setAnneeEtude(anneeEtude);
            user = etudiantRepo.save(e);
        }
        auditService.enregistrer("INSCRIPTION", "Nouvel utilisateur : " + identifiant, user);
        return user;
    }

    public Utilisateur seConnecter(String identifiant, String motDePasse) {
        Utilisateur user = utilisateurRepo.findByIdentifiant(identifiant)
            .orElseThrow(() -> new RuntimeException("Identifiant non trouvé"));
        if (!user.isActif()) throw new RuntimeException("Compte désactivé");
        if (!passwordEncoder.matches(motDePasse, user.getMotDePasse()))
            throw new RuntimeException("Mot de passe incorrect");
        auditService.enregistrer("CONNEXION", "Connexion : " + identifiant, user);
        return user;
    }

    public Utilisateur modifierProfil(Long id, String nom, String prenom) {
        Utilisateur user = utilisateurRepo.findById(id)
            .orElseThrow(() -> new RuntimeException("Non trouvé"));
        if (nom != null) user.setNom(nom);
        if (prenom != null) user.setPrenom(prenom);
        return utilisateurRepo.save(user);
    }

    public List<Utilisateur> listerTous() { return utilisateurRepo.findAll(); }
    public Optional<Utilisateur> trouverParId(Long id) { return utilisateurRepo.findById(id); }
    public List<Etudiant> classement() { return etudiantRepo.findTop10ByOrderByScoreReputationDesc(); }

    public Utilisateur changerStatut(Long id, boolean actif) {
        Utilisateur user = utilisateurRepo.findById(id)
            .orElseThrow(() -> new RuntimeException("Non trouvé"));
        user.setActif(actif);
        auditService.enregistrer(actif ? "COMPTE_ACTIVE" : "COMPTE_DESACTIVE",
            "Utilisateur " + user.getIdentifiant(), user);
        return utilisateurRepo.save(user);
    }
}
