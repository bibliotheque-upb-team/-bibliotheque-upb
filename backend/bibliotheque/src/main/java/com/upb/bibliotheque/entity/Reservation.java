package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "reservations")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Reservation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long reservationId;

    @ManyToOne
    @JoinColumn(name = "etudiant_id", nullable = false)
    private Etudiant etudiant;

    @ManyToOne
    @JoinColumn(name = "livre_id", nullable = false)
    private Livre livre;

    private LocalDateTime dateReservation = LocalDateTime.now();

    @Enumerated(EnumType.STRING)
    private StatutReservation statut = StatutReservation.EN_ATTENTE;
    private Integer positionFileAttente;

    public enum StatutReservation { EN_ATTENTE, CONFIRMEE, ANNULEE, REFUSEE }
}