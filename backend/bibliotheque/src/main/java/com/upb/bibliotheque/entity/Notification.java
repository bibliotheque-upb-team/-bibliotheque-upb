package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "notifications")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long notificationId;

    @ManyToOne
    @JoinColumn(name = "utilisateur_id", nullable = false)
    private Utilisateur utilisateur;

    private String titre;
    @Column(columnDefinition = "TEXT")
    private String message;

    @Enumerated(EnumType.STRING)
    private TypeNotification type = TypeNotification.INFO;
    private boolean lue = false;
    private LocalDateTime dateCreation = LocalDateTime.now();

    public enum TypeNotification { INFO, SUCCESS, WARNING, ERROR }
}