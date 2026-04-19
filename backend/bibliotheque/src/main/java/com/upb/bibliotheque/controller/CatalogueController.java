package com.upb.bibliotheque.controller;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.service.CatalogueService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/catalogues")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class CatalogueController {
    private final CatalogueService catalogueService;

    @GetMapping
    public List<Catalogue> listerTous() { return catalogueService.listerTous(); }

    @PostMapping
    public ResponseEntity<Catalogue> creer(@RequestBody Catalogue catalogue) {
        return ResponseEntity.ok(catalogueService.creer(catalogue));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Catalogue> modifier(@PathVariable Long id, @RequestBody Catalogue catalogue) {
        return ResponseEntity.ok(catalogueService.modifier(id, catalogue));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> supprimer(@PathVariable Long id) {
        catalogueService.supprimer(id);
        return ResponseEntity.ok(Map.of("message", "Catalogue supprimé"));
    }

    @GetMapping("/{id}/livres")
    public List<Livre> livresParCatalogue(@PathVariable Long id) {
        return catalogueService.livresParCatalogue(id);
    }
}
