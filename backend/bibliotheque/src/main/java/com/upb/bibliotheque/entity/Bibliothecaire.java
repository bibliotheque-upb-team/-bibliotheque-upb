package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@DiscriminatorValue("BIBLIOTHECAIRE")
@Getter @Setter @NoArgsConstructor
public class Bibliothecaire extends Utilisateur {
}