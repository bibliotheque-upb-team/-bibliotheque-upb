package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.List;

@Entity
@Table(name = "catalogues")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Catalogue {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long catalogueId;

    private Integer numero;
    @Column(nullable = false)
    private String titre;
    private String categorie;
    private String description;
    private String icone;
    private String couleur;

    @OneToMany(mappedBy = "catalogue", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Livre> livres;
}