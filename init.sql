-- ================================================
-- SCRIPT D'INITIALISATION BASE DE DONNÉES SQLITE
-- Projet Bibliothèque UPB - L3 MIAGE
-- Conforme au diagramme de classes fourni
-- ================================================

-- Suppression des tables si elles existent (pour reset propre)
DROP TABLE IF EXISTS notification;
DROP TABLE IF EXISTS annotation;
DROP TABLE IF EXISTS retour_livre;
DROP TABLE IF EXISTS validation_emprunt;
DROP TABLE IF EXISTS emprunt;
DROP TABLE IF EXISTS reservation;
DROP TABLE IF EXISTS livre;
DROP TABLE IF EXISTS administrateur;
DROP TABLE IF EXISTS bibliothecaire;
DROP TABLE IF EXISTS etudiant;
DROP TABLE IF EXISTS utilisateur;

-- ================================================
-- TABLE : utilisateur (classe mère)
-- Stocke tous les utilisateurs du système
-- ================================================
CREATE TABLE utilisateur (
    utilisateur_id INTEGER PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    mot_de_passe_hash TEXT NOT NULL,
    nom TEXT NOT NULL,
    prenom TEXT NOT NULL,
    type_utilisateur TEXT NOT NULL CHECK (type_utilisateur IN ('ETUDIANT', 'BIBLIOTHECAIRE', 'ADMINISTRATEUR')),
    created_at TEXT DEFAULT (datetime('now'))
);

-- ================================================
-- TABLE : etudiant (hérite de utilisateur)
-- Informations spécifiques aux étudiants
-- ================================================
CREATE TABLE etudiant (
    utilisateur_id INTEGER PRIMARY KEY,
    departement TEXT NOT NULL,
    annee_etude INTEGER NOT NULL CHECK (annee_etude >= 1 AND annee_etude <= 5),
    score_reputation INTEGER DEFAULT 100 CHECK (score_reputation >= 0 AND score_reputation <= 100),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE : bibliothecaire (hérite de utilisateur)
-- Informations spécifiques aux bibliothécaires
-- ================================================
CREATE TABLE bibliothecaire (
    utilisateur_id INTEGER PRIMARY KEY,
    matricule TEXT UNIQUE NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE : administrateur (hérite de utilisateur)
-- Informations spécifiques aux administrateurs
-- ================================================
CREATE TABLE administrateur (
    utilisateur_id INTEGER PRIMARY KEY,
    niveau_acces TEXT NOT NULL CHECK (niveau_acces IN ('SUPER_ADMIN', 'ADMIN', 'MODERATEUR')),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE : livre
-- Catalogue de tous les livres
-- ================================================
CREATE TABLE livre (
    livre_id INTEGER PRIMARY KEY,
    isbn TEXT UNIQUE NOT NULL,
    titre TEXT NOT NULL,
    auteurs TEXT NOT NULL, -- Stocké comme JSON: ["Auteur1", "Auteur2"]
    categorie TEXT NOT NULL,
    exemplaires_totaux INTEGER NOT NULL DEFAULT 1 CHECK (exemplaires_totaux >= 0),
    exemplaires_disponibles INTEGER NOT NULL DEFAULT 1 CHECK (exemplaires_disponibles >= 0),
    created_at TEXT DEFAULT (datetime('now')),
    CHECK (exemplaires_disponibles <= exemplaires_totaux)
);

-- ================================================
-- TABLE : emprunt
-- Tous les emprunts (actifs et historique)
-- ================================================
CREATE TABLE emprunt (
    emprunt_id INTEGER PRIMARY KEY,
    utilisateur_id INTEGER NOT NULL,
    livre_id INTEGER NOT NULL,
    date_emprunt TEXT NOT NULL DEFAULT (datetime('now')),
    date_echeance TEXT NOT NULL,
    date_retour TEXT,
    statut TEXT NOT NULL CHECK (statut IN ('EN_COURS', 'RETOURNE', 'EN_RETARD', 'EN_ATTENTE_VALIDATION')),
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (utilisateur_id) REFERENCES etudiant(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (livre_id) REFERENCES livre(livre_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE : validation_emprunt
-- Validation des emprunts par les bibliothécaires
-- Relation : validePar (Bibliothecaire 1 -- 0..1 Emprunt)
-- ================================================
CREATE TABLE validation_emprunt (
    validation_id INTEGER PRIMARY KEY,
    emprunt_id INTEGER UNIQUE NOT NULL,
    bibliothecaire_id INTEGER NOT NULL,
    date_validation TEXT NOT NULL DEFAULT (datetime('now')),
    commentaire TEXT,
    statut_validation TEXT NOT NULL CHECK (statut_validation IN ('VALIDE', 'REFUSE')),
    FOREIGN KEY (emprunt_id) REFERENCES emprunt(emprunt_id) ON DELETE CASCADE,
    FOREIGN KEY (bibliothecaire_id) REFERENCES bibliothecaire(utilisateur_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE : retour_livre
-- Enregistrement des retours de livres
-- Relation : cloturePar (Bibliothecaire 1 -- 0..1 Emprunt)
-- ================================================
CREATE TABLE retour_livre (
    retour_id INTEGER PRIMARY KEY,
    emprunt_id INTEGER UNIQUE NOT NULL,
    bibliothecaire_id INTEGER NOT NULL,
    date_retour TEXT NOT NULL DEFAULT (datetime('now')),
    etat_livre TEXT NOT NULL CHECK (etat_livre IN ('BON', 'MOYEN', 'MAUVAIS', 'ENDOMMAGE')),
    amende_paye REAL DEFAULT 0.0 CHECK (amende_paye >= 0),
    FOREIGN KEY (emprunt_id) REFERENCES emprunt(emprunt_id) ON DELETE CASCADE,
    FOREIGN KEY (bibliothecaire_id) REFERENCES bibliothecaire(utilisateur_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE : reservation
-- Réservations de livres indisponibles
-- ================================================
CREATE TABLE reservation (
    reservation_id INTEGER PRIMARY KEY,
    utilisateur_id INTEGER NOT NULL,
    livre_id INTEGER NOT NULL,
    date_reservation TEXT NOT NULL DEFAULT (datetime('now')),
    statut TEXT NOT NULL CHECK (statut IN ('EN_ATTENTE', 'PRET', 'ANNULE', 'EXPIRE')),
    position_file_attente INTEGER NOT NULL CHECK (position_file_attente >= 1),
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (utilisateur_id) REFERENCES etudiant(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (livre_id) REFERENCES livre(livre_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE : annotation
-- Annotations partagées sur les livres
-- ================================================
CREATE TABLE annotation (
    annotation_id INTEGER PRIMARY KEY,
    utilisateur_id INTEGER NOT NULL,
    livre_id INTEGER NOT NULL,
    texte_annotation TEXT NOT NULL,
    numero_page INTEGER CHECK (numero_page > 0),
    date_creation TEXT NOT NULL DEFAULT (datetime('now')),
    nombre_votes INTEGER DEFAULT 0,
    FOREIGN KEY (utilisateur_id) REFERENCES etudiant(utilisateur_id) ON DELETE CASCADE,
    FOREIGN KEY (livre_id) REFERENCES livre(livre_id) ON DELETE CASCADE
);

-- ================================================
-- TABLE : notification
-- Notifications pour les utilisateurs
-- ================================================
CREATE TABLE notification (
    notification_id INTEGER PRIMARY KEY,
    utilisateur_id INTEGER NOT NULL,
    titre TEXT NOT NULL,
    message TEXT NOT NULL,
    est_lue INTEGER DEFAULT 0 CHECK (est_lue IN (0, 1)),
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(utilisateur_id) ON DELETE CASCADE
);

-- ================================================
-- INDEX pour améliorer les performances
-- ================================================
CREATE INDEX idx_utilisateur_email ON utilisateur(email);
CREATE INDEX idx_utilisateur_type ON utilisateur(type_utilisateur);
CREATE INDEX idx_livre_titre ON livre(titre);
CREATE INDEX idx_livre_categorie ON livre(categorie);
CREATE INDEX idx_livre_isbn ON livre(isbn);
CREATE INDEX idx_emprunt_utilisateur ON emprunt(utilisateur_id);
CREATE INDEX idx_emprunt_livre ON emprunt(livre_id);
CREATE INDEX idx_emprunt_statut ON emprunt(statut);
CREATE INDEX idx_reservation_utilisateur ON reservation(utilisateur_id);
CREATE INDEX idx_reservation_livre ON reservation(livre_id);
CREATE INDEX idx_annotation_livre ON annotation(livre_id);
CREATE INDEX idx_notification_utilisateur ON notification(utilisateur_id);
CREATE INDEX idx_notification_lue ON notification(est_lue);

-- ================================================
-- DONNÉES DE TEST
-- ================================================

-- ===== UTILISATEURS =====

-- 1 Administrateur
INSERT INTO utilisateur (utilisateur_id, email, mot_de_passe_hash, nom, prenom, type_utilisateur) VALUES
(1, 'admin@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'KOUAME', 'Admin', 'ADMINISTRATEUR');

INSERT INTO administrateur (utilisateur_id, niveau_acces) VALUES
(1, 'SUPER_ADMIN');

-- 2 Bibliothécaires
INSERT INTO utilisateur (utilisateur_id, email, mot_de_passe_hash, nom, prenom, type_utilisateur) VALUES
(2, 'biblio1@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'KOUASSI', 'Marie', 'BIBLIOTHECAIRE'),
(3, 'biblio2@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'TOURE', 'Ibrahim', 'BIBLIOTHECAIRE');

INSERT INTO bibliothecaire (utilisateur_id, matricule) VALUES
(2, 'BIB-2024-001'),
(3, 'BIB-2024-002');

-- 10 Étudiants
INSERT INTO utilisateur (utilisateur_id, email, mot_de_passe_hash, nom, prenom, type_utilisateur) VALUES
(4, 'etudiant1@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'YAO', 'Kouadio', 'ETUDIANT'),
(5, 'etudiant2@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'KONAN', 'Amani', 'ETUDIANT'),
(6, 'etudiant3@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'BROU', 'Adjoua', 'ETUDIANT'),
(7, 'etudiant4@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'KAKOU', 'Aya', 'ETUDIANT'),
(8, 'etudiant5@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'N''GUESSAN', 'Koffi', 'ETUDIANT'),
(9, 'etudiant6@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'DIABATE', 'Mariam', 'ETUDIANT'),
(10, 'etudiant7@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'ASSI', 'Jean', 'ETUDIANT'),
(11, 'etudiant8@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'OUATTARA', 'Fatou', 'ETUDIANT'),
(12, 'etudiant9@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'KONE', 'Moussa', 'ETUDIANT'),
(13, 'etudiant10@upb.ci', '$2a$10$abcdefghijklmnopqrstuvwxyz123456', 'BILE', 'Sandrine', 'ETUDIANT');

INSERT INTO etudiant (utilisateur_id, departement, annee_etude, score_reputation) VALUES
(4, 'MIAGE', 3, 95),
(5, 'MIAGE', 3, 88),
(6, 'MIAGE', 3, 92),
(7, 'Informatique', 2, 85),
(8, 'Informatique', 2, 78),
(9, 'Mathematiques', 1, 90),
(10, 'Gestion', 3, 82),
(11, 'Economie', 2, 75),
(12, 'MIAGE', 3, 93),
(13, 'Informatique', 1, 88);

-- ===== LIVRES =====

INSERT INTO livre (livre_id, isbn, titre, auteurs, categorie, exemplaires_totaux, exemplaires_disponibles) VALUES
-- Informatique (8 livres)
(1, '978-2100547548', 'Algorithmique et structures de données', '["Thomas Cormen", "Charles Leiserson", "Ronald Rivest"]', 'Informatique', 5, 3),
(2, '978-2212134360', 'Design Patterns', '["Erich Gamma", "Richard Helm", "Ralph Johnson"]', 'Informatique', 3, 2),
(3, '978-2744074875', 'Clean Code', '["Robert Martin"]', 'Informatique', 4, 1),
(4, '978-2100801268', 'SQL pour les nuls', '["Allen Taylor"]', 'Informatique', 3, 3),
(5, '978-2100825394', 'Java : Les fondamentaux', '["Barry Burd"]', 'Informatique', 4, 2),
(6, '978-2409021350', 'Python pour la Data Science', '["Jake VanderPlas"]', 'Informatique', 3, 3),
(7, '978-2100812202', 'Réseaux et Internet', '["Andrew Tanenbaum"]', 'Informatique', 4, 4),
(8, '978-2409036392', 'Intelligence Artificielle', '["Stuart Russell", "Peter Norvig"]', 'Informatique', 2, 0),

-- Mathématiques (5 livres)
(9, '978-2729856779', 'Mathématiques L1 : Algèbre', '["Jean-Pierre Marco"]', 'Mathématiques', 6, 5),
(10, '978-2804162696', 'Statistiques descriptives', '["Claire Durand"]', 'Mathématiques', 4, 4),
(11, '978-2100775415', 'Probabilités et statistiques', '["Bernard Py"]', 'Mathématiques', 5, 3),
(12, '978-2311404821', 'Analyse mathématique', '["Walter Rudin"]', 'Mathématiques', 3, 2),
(13, '978-2100815562', 'Algèbre linéaire', '["Serge Lang"]', 'Mathématiques', 4, 4),

-- Gestion/Économie (5 livres)
(14, '978-2744065842', 'Management des organisations', '["Stephen Robbins", "Timothy Judge"]', 'Gestion', 4, 2),
(15, '978-2100820511', 'Comptabilité générale', '["Béatrice Grandguillot"]', 'Gestion', 5, 5),
(16, '978-2340051515', 'Gestion de projet Agile', '["Véronique Messager"]', 'Gestion', 3, 1),
(17, '978-2818807378', 'Économie générale', '["Jacques Généreux"]', 'Économie', 4, 4),
(18, '978-2100825936', 'Microéconomie', '["Hal Varian"]', 'Économie', 3, 2),

-- Langues (3 livres)
(19, '978-0521618960', 'English Grammar in Use', '["Raymond Murphy"]', 'Anglais', 6, 4),
(20, '978-1108457682', 'Cambridge Advanced English', '["Guy Brook-Hart"]', 'Anglais', 4, 3),
(21, '978-2090382167', 'Grammaire Progressive Français', '["Maïa Grégoire"]', 'Français', 5, 5),

-- Littérature (4 livres)
(22, '978-2266302319', 'Le Petit Prince', '["Antoine de Saint-Exupéry"]', 'Littérature', 3, 2),
(23, '978-2070360178', 'Une vie de boy', '["Ferdinand Oyono"]', 'Littérature', 4, 3),
(24, '978-2253002864', 'Germinal', '["Émile Zola"]', 'Littérature', 3, 1),
(25, '978-2070413119', 'L''Étranger', '["Albert Camus"]', 'Littérature', 4, 4),

-- Sciences (5 livres)
(26, '978-2215090236', 'Physique générale', '["Paul Tipler"]', 'Physique', 4, 3),
(27, '978-2804185343', 'Chimie générale', '["Raymond Chang"]', 'Chimie', 3, 3),
(28, '978-2100819515', 'Introduction à la biologie', '["Neil Campbell"]', 'Biologie', 4, 4),
(29, '978-2100825622', 'Mécanique quantique', '["Claude Cohen-Tannoudji"]', 'Physique', 2, 1),
(30, '978-2804194549', 'Chimie organique', '["John McMurry"]', 'Chimie', 3, 2);

-- ===== EMPRUNTS =====

-- Emprunts EN_COURS (5)
INSERT INTO emprunt (emprunt_id, utilisateur_id, livre_id, date_emprunt, date_echeance, date_retour, statut) VALUES
(1, 4, 1, datetime('now', '-5 days'), datetime('now', '+9 days'), NULL, 'EN_COURS'),
(2, 5, 2, datetime('now', '-3 days'), datetime('now', '+11 days'), NULL, 'EN_COURS'),
(3, 6, 3, datetime('now', '-7 days'), datetime('now', '+7 days'), NULL, 'EN_COURS'),
(4, 7, 5, datetime('now', '-2 days'), datetime('now', '+12 days'), NULL, 'EN_COURS'),
(5, 8, 11, datetime('now', '-4 days'), datetime('now', '+10 days'), NULL, 'EN_COURS');

-- Emprunts EN_RETARD (2)
INSERT INTO emprunt (emprunt_id, utilisateur_id, livre_id, date_emprunt, date_echeance, date_retour, statut) VALUES
(6, 9, 16, datetime('now', '-20 days'), datetime('now', '-6 days'), NULL, 'EN_RETARD'),
(7, 10, 24, datetime('now', '-18 days'), datetime('now', '-4 days'), NULL, 'EN_RETARD');

-- Emprunts RETOURNES (3)
INSERT INTO emprunt (emprunt_id, utilisateur_id, livre_id, date_emprunt, date_echeance, date_retour, statut) VALUES
(8, 11, 14, datetime('now', '-30 days'), datetime('now', '-16 days'), datetime('now', '-17 days'), 'RETOURNE'),
(9, 12, 18, datetime('now', '-25 days'), datetime('now', '-11 days'), datetime('now', '-12 days'), 'RETOURNE'),
(10, 13, 22, datetime('now', '-28 days'), datetime('now', '-14 days'), datetime('now', '-15 days'), 'RETOURNE');

-- ===== VALIDATIONS EMPRUNTS =====

INSERT INTO validation_emprunt (emprunt_id, bibliothecaire_id, date_validation, commentaire, statut_validation) VALUES
(1, 2, datetime('now', '-5 days'), 'Emprunt validé', 'VALIDE'),
(2, 2, datetime('now', '-3 days'), 'Emprunt validé', 'VALIDE'),
(3, 3, datetime('now', '-7 days'), 'Emprunt validé', 'VALIDE'),
(8, 2, datetime('now', '-30 days'), 'Emprunt validé', 'VALIDE'),
(9, 3, datetime('now', '-25 days'), 'Emprunt validé', 'VALIDE');

-- ===== RETOURS LIVRES =====

INSERT INTO retour_livre (emprunt_id, bibliothecaire_id, date_retour, etat_livre, amende_paye) VALUES
(8, 2, datetime('now', '-17 days'), 'BON', 0.0),
(9, 3, datetime('now', '-12 days'), 'BON', 0.0),
(10, 2, datetime('now', '-15 days'), 'MOYEN', 0.0);

-- ===== RÉSERVATIONS =====

INSERT INTO reservation (reservation_id, utilisateur_id, livre_id, date_reservation, statut, position_file_attente) VALUES
(1, 11, 8, datetime('now', '-2 days'), 'EN_ATTENTE', 1),
(2, 12, 8, datetime('now', '-1 days'), 'EN_ATTENTE', 2),
(3, 13, 3, datetime('now', '-3 days'), 'EN_ATTENTE', 1);

-- ===== ANNOTATIONS =====

INSERT INTO annotation (annotation_id, utilisateur_id, livre_id, texte_annotation, numero_page, date_creation, nombre_votes) VALUES
(1, 4, 1, 'Excellent chapitre sur les arbres binaires. Très bien expliqué avec des exemples concrets.', 145, datetime('now', '-4 days'), 12),
(2, 5, 1, 'La complexité temporelle est bien détaillée ici. À relire avant l''examen.', 178, datetime('now', '-3 days'), 8),
(3, 6, 2, 'Le pattern Singleton est particulièrement utile dans notre projet Spring Boot.', 89, datetime('now', '-6 days'), 15),
(4, 7, 3, 'Principes SOLID très bien expliqués. À appliquer dans nos projets.', 45, datetime('now', '-5 days'), 10),
(5, 8, 5, 'Les streams Java 8 changent vraiment la façon de coder. Super chapitre !', 234, datetime('now', '-2 days'), 7),
(6, 9, 9, 'Les démonstrations mathématiques sont claires et progressives.', 67, datetime('now', '-7 days'), 11),
(7, 10, 14, 'Théories du management très pertinentes pour notre cours.', 112, datetime('now', '-8 days'), 9),
(8, 12, 1, 'Algorithme de tri rapide bien détaillé avec analyse de complexité.', 201, datetime('now', '-1 days'), 5);

-- ===== NOTIFICATIONS =====

INSERT INTO notification (notification_id, utilisateur_id, titre, message, est_lue) VALUES
-- Notifications non lues
(1, 4, 'Retour dans 3 jours', 'Le livre "Algorithmique et structures de données" doit être retourné le 18/01/2025.', 0),
(2, 5, 'Retour dans 5 jours', 'Le livre "Design Patterns" doit être retourné le 20/01/2025.', 0),
(3, 9, '⚠️ Livre en retard', 'Le livre "Gestion de projet Agile" est en retard de 6 jours. Amende: 3000 FCFA.', 0),
(4, 10, '⚠️ Livre en retard', 'Le livre "Germinal" est en retard de 4 jours. Amende: 2000 FCFA.', 0),
(5, 11, '📚 Livre disponible', 'Le livre "Intelligence Artificielle" que vous avez réservé est maintenant disponible.', 0),

-- Notifications lues
(6, 4, '✅ Emprunt validé', 'Votre emprunt du livre "Algorithmique et structures de données" a été validé.', 1),
(7, 5, '✅ Emprunt validé', 'Votre emprunt du livre "Design Patterns" a été validé.', 1),
(8, 6, '👍 Annotation populaire', 'Votre annotation sur "Design Patterns" a reçu 15 votes positifs !', 1),
(9, 12, '✅ Retour enregistré', 'Le retour du livre "Microéconomie" a été enregistré. Merci !', 1),
(10, 13, '✅ Retour enregistré', 'Le retour du livre "Le Petit Prince" a été enregistré. Merci !', 1);

-- ================================================
-- VUES UTILES
-- ================================================

-- Vue : Emprunts actifs avec détails
CREATE VIEW vue_emprunts_actifs AS
SELECT 
    e.emprunt_id,
    u.nom || ' ' || u.prenom AS nom_complet,
    u.email,
    et.departement,
    l.titre AS titre_livre,
    l.isbn,
    e.date_emprunt,
    e.date_echeance,
    e.statut,
    CASE 
        WHEN e.statut = 'EN_RETARD' THEN julianday('now') - julianday(e.date_echeance)
        ELSE 0
    END AS jours_retard
FROM emprunt e
JOIN utilisateur u ON e.utilisateur_id = u.utilisateur_id
JOIN etudiant et ON e.utilisateur_id = et.utilisateur_id
JOIN livre l ON e.livre_id = l.livre_id
WHERE e.statut IN ('EN_COURS', 'EN_RETARD');

-- Vue : Livres populaires
CREATE VIEW vue_livres_populaires AS
SELECT 
    l.livre_id,
    l.titre,
    l.auteurs,
    l.categorie,
    COUNT(e.emprunt_id) AS nombre_emprunts,
    l.exemplaires_disponibles,
    l.exemplaires_totaux
FROM livre l
LEFT JOIN emprunt e ON l.livre_id = e.livre_id
GROUP BY l.livre_id
ORDER BY nombre_emprunts DESC;

-- Vue : Statistiques étudiants
CREATE VIEW vue_statistiques_etudiants AS
SELECT 
    u.utilisateur_id,
    u.nom || ' ' || u.prenom AS nom_complet,
    u.email,
    et.departement,
    et.annee_etude,
    et.score_reputation,
    COUNT(DISTINCT e.emprunt_id) AS total_emprunts,
    COUNT(DISTINCT CASE WHEN e.statut = 'EN_COURS' THEN e.emprunt_id END) AS emprunts_actifs,
    COUNT(DISTINCT CASE WHEN e.statut = 'EN_RETARD' THEN e.emprunt_id END) AS emprunts_retard,
    COUNT(DISTINCT a.annotation_id) AS total_annotations,
    COALESCE(SUM(a.nombre_votes), 0) AS total_votes_recus
FROM utilisateur u
JOIN etudiant et ON u.utilisateur_id = et.utilisateur_id
LEFT JOIN emprunt e ON u.utilisateur_id = e.utilisateur_id
LEFT JOIN annotation a ON u.utilisateur_id = a.utilisateur_id
GROUP BY u.utilisateur_id;

-- ================================================
-- FIN DU SCRIPT
-- ================================================

-- Vérification finale
SELECT 'Base de données initialisée avec succès!' AS message;
SELECT COUNT(*) AS total_utilisateurs FROM utilisateur;
SELECT COUNT(*) AS total_etudiants FROM etudiant;
SELECT COUNT(*) AS total_bibliothecaires FROM bibliothecaire;
SELECT COUNT(*) AS total_administrateurs FROM administrateur;
SELECT COUNT(*) AS total_livres FROM livre;
SELECT COUNT(*) AS total_emprunts FROM emprunt;
SELECT COUNT(*) AS total_reservations FROM reservation;
SELECT COUNT(*) AS total_annotations FROM annotation;
SELECT COUNT(*) AS total_notifications FROM notification;