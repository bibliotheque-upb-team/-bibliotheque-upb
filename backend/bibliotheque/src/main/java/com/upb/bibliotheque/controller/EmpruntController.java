package com.upb.bibliotheque.controller;

import com.upb.bibliotheque.entity.Emprunt;
import com.upb.bibliotheque.service.EmpruntService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/emprunts")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class EmpruntController {
    private final EmpruntService empruntService;

    @GetMapping
    public List<Emprunt> listerTous() { return empruntService.listerTous(); }

    @GetMapping("/etudiant/{etudiantId}")
    public List<Emprunt> historiqueEtudiant(@PathVariable Long etudiantId) {
        return empruntService.historiqueEtudiant(etudiantId);
    }

    @PostMapping
    public ResponseEntity<Emprunt> emprunter(@RequestBody Map<String, Long> body) {
        return ResponseEntity.ok(empruntService.emprunterLivre(body.get("etudiantId"), body.get("livreId")));
    }

    @PutMapping("/{id}/retour")
    public ResponseEntity<Emprunt> retourner(@PathVariable Long id) {
        return ResponseEntity.ok(empruntService.retournerLivre(id));
    }

    @PutMapping("/{id}/prolonger")
    public ResponseEntity<Emprunt> prolonger(@PathVariable Long id, @RequestBody Map<String, Long> body) {
        return ResponseEntity.ok(empruntService.prolongerEmprunt(id, body.get("etudiantId")));
    }
}
