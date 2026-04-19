package com.upb.bibliotheque.controller;

import com.upb.bibliotheque.entity.Livre;
import com.upb.bibliotheque.service.LivreService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/livres")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class LivreController {
    private final LivreService livreService;

    @GetMapping
    public List<Livre> listerTous() { return livreService.listerTous(); }

    @GetMapping("/{id}")
    public ResponseEntity<Livre> trouverParId(@PathVariable Long id) {
        return ResponseEntity.ok(livreService.trouverParId(id));
    }

    @GetMapping("/recherche")
    public List<Livre> rechercher(@RequestParam String titre) {
        return livreService.rechercherParTitre(titre);
    }

    @PostMapping
    public ResponseEntity<Livre> ajouter(@RequestBody Livre livre,
                                          @RequestParam(required = false) Long catalogueId) {
        return ResponseEntity.ok(livreService.ajouter(livre, catalogueId));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Livre> modifier(@PathVariable Long id, @RequestBody Livre livre) {
        return ResponseEntity.ok(livreService.modifier(id, livre));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> supprimer(@PathVariable Long id) {
        livreService.supprimer(id);
        return ResponseEntity.ok(Map.of("message", "Livre supprimé"));
    }
}
