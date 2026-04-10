package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.List;

@Entity
@Table(name = "quiz")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Quiz {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long quizId;
    private String titre;
    private String description;
    private Integer pointsAGagner = 50;
    private boolean actif = true;

    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<QuizQuestion> questions;
}