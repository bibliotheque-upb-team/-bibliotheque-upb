package com.upb.bibliotheque.controller;

import com.upb.bibliotheque.entity.Reservation;
import com.upb.bibliotheque.service.ReservationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reservations")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ReservationController {
    private final ReservationService reservationService;

    @GetMapping("/etudiant/{etudiantId}")
    public List<Reservation> mesReservations(@PathVariable Long etudiantId) {
        return reservationService.mesReservations(etudiantId);
    }

    @GetMapping("/en-attente")
    public List<Reservation> enAttente() { return reservationService.enAttente(); }

    @PostMapping
    public ResponseEntity<Reservation> reserver(@RequestBody Map<String, Long> body) {
        return ResponseEntity.ok(reservationService.reserverLivre(body.get("etudiantId"), body.get("livreId")));
    }

    @PutMapping("/{id}/annuler")
    public ResponseEntity<Reservation> annuler(@PathVariable Long id) {
        return ResponseEntity.ok(reservationService.annuler(id));
    }

    @PutMapping("/{id}/confirmer")
    public ResponseEntity<Reservation> confirmer(@PathVariable Long id) {
        return ResponseEntity.ok(reservationService.confirmer(id));
    }

    @PutMapping("/{id}/refuser")
    public ResponseEntity<Reservation> refuser(@PathVariable Long id) {
        return ResponseEntity.ok(reservationService.refuser(id));
    }
}
