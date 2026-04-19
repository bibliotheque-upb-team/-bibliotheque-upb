package com.upb.bibliotheque.controller;

import com.upb.bibliotheque.service.BibliothecaireService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/biblio")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class BibliothecaireController {
    private final BibliothecaireService bibliothecaireService;

    @GetMapping("/dashboard")
    public ResponseEntity<Map<String, Object>> tableauDeBord() {
        return ResponseEntity.ok(bibliothecaireService.tableauDeBord());
    }

    @GetMapping("/rapport")
    public ResponseEntity<Map<String, Object>> rapport() {
        return ResponseEntity.ok(bibliothecaireService.genererRapport());
    }
}
