package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@DiscriminatorValue("ADMINISTRATEUR")
@Getter @Setter @NoArgsConstructor
public class Administrateur extends Utilisateur {
}