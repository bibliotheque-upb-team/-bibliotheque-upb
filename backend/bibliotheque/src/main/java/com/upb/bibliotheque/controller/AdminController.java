package com.upb.bibliotheque.controller;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AdminController {
    private final AdminService adminService;

    @GetMapping("/dashboard")
    public ResponseEntity<Map<String, Object>> tableauDeBord() {
        return ResponseEntity.ok(adminService.tableauDeBord());
    }

    @GetMapping("/utilisateurs")
    public List<Utilisateur> listerUtilisateurs() { return adminService.listerUtilisateurs(); }

    @PutMapping("/utilisateurs/{id}/statut")
    public ResponseEntity<Utilisateur> changerStatut(@PathVariable Long id,
                                                      @RequestBody Map<String, Boolean> body) {
        return ResponseEntity.ok(adminService.changerStatut(id, body.get("actif")));
    }

    @GetMapping("/audits")
    public List<JournalAudit> listerAudits() { return adminService.listerAudits(); }

    @GetMapping("/audits/{email}")
    public List<JournalAudit> auditsParUtilisateur(@PathVariable String email) {
        return adminService.auditsParUtilisateur(email);
    }
}
