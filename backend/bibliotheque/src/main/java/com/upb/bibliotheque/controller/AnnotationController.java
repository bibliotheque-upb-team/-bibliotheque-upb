package com.upb.bibliotheque.controller;

import com.upb.bibliotheque.entity.Annotation;
import com.upb.bibliotheque.service.AnnotationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/annotations")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AnnotationController {
    private final AnnotationService annotationService;

    @GetMapping
    public List<Annotation> toutesLesAnnotations() {
        return annotationService.toutes();
    }

    @GetMapping("/livre/{livreId}")
    public List<Annotation> parLivre(@PathVariable Long livreId) {
        return annotationService.parLivre(livreId);
    }

    @PostMapping
    public ResponseEntity<Annotation> creer(@RequestBody Map<String, Object> body) {
        return ResponseEntity.ok(annotationService.creer(
            Long.valueOf(body.get("etudiantId").toString()),
            Long.valueOf(body.get("livreId").toString()),
            body.get("texte").toString(),
            body.get("page") != null ? Integer.valueOf(body.get("page").toString()) : null));
    }

    @PutMapping("/{id}/voter")
    public ResponseEntity<Annotation> voter(@PathVariable Long id) {
        return ResponseEntity.ok(annotationService.voter(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> supprimer(@PathVariable Long id) {
        annotationService.supprimer(id);
        return ResponseEntity.ok(Map.of("message", "Annotation supprimée"));
    }
}
