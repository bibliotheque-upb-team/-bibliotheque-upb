package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Entity
@Table(name = "emprunts")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Emprunt {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long empruntId;

    @ManyToOne
    @JoinColumn(name = "etudiant_id", nullable = false)
    private Etudiant etudiant;

    @ManyToOne
    @JoinColumn(name = "livre_id", nullable = false)
    private Livre livre;

    @Column(nullable = false)
    private LocalDate dateEmprunt = LocalDate.now();
    @Column(nullable = false)
    private LocalDate dateRetourPrevue = LocalDate.now().plusDays(14);
    private LocalDate dateRetourEffective;

    @Enumerated(EnumType.STRING)
    private StatutEmprunt statut = StatutEmprunt.EN_COURS;
    private Integer nombreProlongations = 0;

    public enum StatutEmprunt { EN_COURS, RETOURNE, EN_RETARD }
    public boolean estEnRetard() { return dateRetourEffective == null && LocalDate.now().isAfter(dateRetourPrevue); }
}