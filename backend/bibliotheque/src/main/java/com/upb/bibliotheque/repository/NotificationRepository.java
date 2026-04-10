package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByUtilisateurAndLueFalse(Utilisateur utilisateur);
    List<Notification> findByUtilisateurOrderByDateCreationDesc(Utilisateur utilisateur);
}