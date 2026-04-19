package com.upb.bibliotheque.controller;

import com.upb.bibliotheque.entity.Notification;
import com.upb.bibliotheque.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class NotificationController {
    private final NotificationService notificationService;

    @GetMapping("/utilisateur/{utilisateurId}")
    public List<Notification> toutesParUtilisateur(@PathVariable Long utilisateurId) {
        return notificationService.toutesParUtilisateur(utilisateurId);
    }

    @GetMapping("/utilisateur/{utilisateurId}/non-lues")
    public List<Notification> nonLues(@PathVariable Long utilisateurId) {
        return notificationService.nonLues(utilisateurId);
    }

    @PutMapping("/{id}/lire")
    public ResponseEntity<Notification> marquerLue(@PathVariable Long id) {
        return ResponseEntity.ok(notificationService.marquerLue(id));
    }

    @PostMapping("/broadcast")
    public ResponseEntity<Map<String, String>> broadcast(@RequestBody Map<String, String> body) {
        notificationService.envoyerATousLesEtudiants(body.get("titre"), body.get("message"));
        return ResponseEntity.ok(Map.of("message", "Notification envoyée à tous les étudiants"));
    }
}
