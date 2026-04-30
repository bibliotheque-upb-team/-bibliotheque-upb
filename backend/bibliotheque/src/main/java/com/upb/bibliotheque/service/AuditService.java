package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.JournalAudit;
import com.upb.bibliotheque.entity.Utilisateur;
import com.upb.bibliotheque.repository.JournalAuditRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuditService {
    private final JournalAuditRepository auditRepo;

    public void enregistrer(String action, String description, Utilisateur user) {
        JournalAudit audit = new JournalAudit();
        audit.setAction(action);
        audit.setDescription(description);
        audit.setEmailUtilisateur(user.getEmail());
        audit.setRoleUtilisateur(user.getClass().getAnnotation(
            jakarta.persistence.DiscriminatorValue.class).value());
        auditRepo.save(audit);
    }

    public void enregistrer(String action, String description, String email, String role) {
        JournalAudit audit = new JournalAudit();
        audit.setAction(action);
        audit.setDescription(description);
        audit.setEmailUtilisateur(email);
        audit.setRoleUtilisateur(role);
        auditRepo.save(audit);
    }
}
