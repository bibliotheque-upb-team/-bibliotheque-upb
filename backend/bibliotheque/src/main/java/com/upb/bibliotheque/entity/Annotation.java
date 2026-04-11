package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "annotations")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Annotation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long annotationId;

    @ManyToOne
    @JoinColumn(name = "etudiant_id", nullable = false)
    private Etudiant etudiant;

    @ManyToOne
    @JoinColumn(name = "livre_id", nullable = false)
    private Livre livre;

    @Column(columnDefinition = "TEXT")
    private String texteAnnotation;
    private Integer numeroPage;
    private LocalDateTime dateCreation = LocalDateTime.now();
    private Integer nombreVotes = 0;
    private boolean approuvee = true;
}