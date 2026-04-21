package com.upb.bibliotheque.controller;

import com.upb.bibliotheque.config.JwtService;
import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.service.UtilisateurService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {
    private final UtilisateurService utilisateurService;
    private final JwtService jwtService;
    private final PasswordEncoder passwordEncoder;

    @PostMapping("/inscription")
    public ResponseEntity<?> inscription(@RequestBody Map<String, String> body) {
        Utilisateur user = utilisateurService.inscrire(
            body.get("email"),
            passwordEncoder.encode(body.get("motDePasse")),
            body.get("nom"), body.get("prenom"),
            body.get("filiere"), body.get("anneeEtude"),
            body.getOrDefault("role", "STUDENT"));
        String role = user instanceof Administrateur ? "ADMINISTRATEUR"
            : user instanceof Bibliothecaire ? "BIBLIOTHECAIRE" : "ETUDIANT";
        return ResponseEntity.ok(Map.of(
            "token", jwtService.genererToken(user.getUtilisateurId(), user.getIdentifiant(), role),
            "utilisateur", user));
    }

    @PostMapping("/connexion")
    public ResponseEntity<?> connexion(@RequestBody Map<String, String> body) {
        Utilisateur user = utilisateurService.seConnecter(body.get("identifiant"), body.get("motDePasse"));
        String role = user instanceof Administrateur ? "ADMINISTRATEUR"
            : user instanceof Bibliothecaire ? "BIBLIOTHECAIRE" : "ETUDIANT";
        return ResponseEntity.ok(Map.of(
            "token", jwtService.genererToken(user.getUtilisateurId(), user.getIdentifiant(), role),
            "utilisateur", user));
    }
}
