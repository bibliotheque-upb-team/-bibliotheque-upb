package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.List;

@Entity
@Table(name = "livres")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Livre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long livreId;

    @Column(nullable = false)
    private String titre;
    @Column(nullable = false)
    private String auteur;
    private String categorie;
    private String isbn;
    @Column(columnDefinition = "TEXT")
    private String description;
    private Integer exemplairesTotaux = 1;
    private Integer exemplairesDisponibles = 1;
    private String imageUrl;
    private String couleur3d;
    private Integer epaisseur3d;
    private Integer hauteur3d;

    @ManyToOne
    @JoinColumn(name = "catalogue_id")
    private Catalogue catalogue;

    @OneToMany(mappedBy = "livre", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Emprunt> emprunts;

    @OneToMany(mappedBy = "livre", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Reservation> reservations;

    @OneToMany(mappedBy = "livre", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Annotation> annotations;

    public boolean estDisponible() { return exemplairesDisponibles > 0; }
}
