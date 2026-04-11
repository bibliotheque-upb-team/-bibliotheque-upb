package com.upb.bibliotheque.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "journal_audits")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class JournalAudit {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long auditId;
    private String action;
    @Column(columnDefinition = "TEXT")
    private String description;
    private String emailUtilisateur;
    private String roleUtilisateur;
    private LocalDateTime dateAction = LocalDateTime.now();
}