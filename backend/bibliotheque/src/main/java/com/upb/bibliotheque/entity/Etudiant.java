package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@DiscriminatorValue("ETUDIANT")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Etudiant extends Utilisateur {
    private String filiere;
    private String anneeEtude;
    private Integer scoreReputation = 0;
}