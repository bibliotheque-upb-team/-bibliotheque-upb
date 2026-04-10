package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.JournalAudit;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface JournalAuditRepository extends JpaRepository<JournalAudit, Long> {
    List<JournalAudit> findAllByOrderByDateActionDesc();
    List<JournalAudit> findByEmailUtilisateur(String email);
}