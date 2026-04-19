package com.upb.bibliotheque.config;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {
    private final UtilisateurRepository utilisateurRepo;
    private final EtudiantRepository etudiantRepo;
    private final CatalogueRepository catalogueRepo;
    private final LivreRepository livreRepo;
    private final QuizRepository quizRepo;
    private final QuizQuestionRepository questionRepo;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (utilisateurRepo.count() > 0) return;

        Administrateur admin = new Administrateur();
        admin.setIdentifiant("ADM001"); admin.setEmail("admin@upb.cd");
        admin.setMotDePasse(passwordEncoder.encode("admin123"));
        admin.setNom("Admin"); admin.setPrenom("UPB");
        utilisateurRepo.save(admin);

        Bibliothecaire biblio = new Bibliothecaire();
        biblio.setIdentifiant("LIB001"); biblio.setEmail("biblio@upb.cd");
        biblio.setMotDePasse(passwordEncoder.encode("biblio123"));
        biblio.setNom("Bibliothécaire"); biblio.setPrenom("Principal");
        utilisateurRepo.save(biblio);

        Etudiant e1 = new Etudiant();
        e1.setIdentifiant("2025001"); e1.setEmail("etudiant1@upb.cd");
        e1.setMotDePasse(passwordEncoder.encode("pass123"));
        e1.setNom("Mukendi"); e1.setPrenom("Jean"); e1.setFiliere("Informatique"); e1.setAnneeEtude("L2");
        etudiantRepo.save(e1);

        Etudiant e2 = new Etudiant();
        e2.setIdentifiant("2025002"); e2.setEmail("etudiant2@upb.cd");
        e2.setMotDePasse(passwordEncoder.encode("pass123"));
        e2.setNom("Kabila"); e2.setPrenom("Marie"); e2.setFiliere("Droit"); e2.setAnneeEtude("L1");
        etudiantRepo.save(e2);

        Catalogue catInfo = new Catalogue();
        catInfo.setTitre("Informatique"); catInfo.setCategorie("Sciences");
        catInfo.setDescription("Livres d'informatique et programmation");
        catInfo.setNumero(1); catInfo.setIcone("Code"); catInfo.setCouleur("#3B82F6");
        catalogueRepo.save(catInfo);

        Catalogue catDroit = new Catalogue();
        catDroit.setTitre("Droit & Législation"); catDroit.setCategorie("Sciences Sociales");
        catDroit.setDescription("Livres de droit congolais et international");
        catDroit.setNumero(2); catDroit.setIcone("Scale"); catDroit.setCouleur("#8B5CF6");
        catalogueRepo.save(catDroit);

        Catalogue catLitt = new Catalogue();
        catLitt.setTitre("Littérature"); catLitt.setCategorie("Humanités");
        catLitt.setDescription("Romans et littérature africaine");
        catLitt.setNumero(3); catLitt.setIcone("BookOpen"); catLitt.setCouleur("#10B981");
        catalogueRepo.save(catLitt);

        String[][] livresData = {
            {"Introduction aux Algorithmes", "Thomas Cormen", "Informatique", "Manuel de référence en algorithmique", "3", "3"},
            {"Java : La référence complète", "Herbert Schildt", "Informatique", "Guide complet du langage Java", "2", "2"},
            {"Clean Code", "Robert C. Martin", "Informatique", "Principes du code propre", "4", "4"},
            {"Le Code Civil Congolais", "Ministère de la Justice", "Droit", "Code civil de la RDC", "5", "5"},
            {"Droit Constitutionnel", "Jean Giquel", "Droit", "Manuel de droit constitutionnel", "2", "1"},
            {"Things Fall Apart", "Chinua Achebe", "Littérature", "Roman classique africain", "3", "3"},
            {"L'Aventure Ambiguë", "Cheikh Hamidou Kane", "Littérature", "Roman philosophique africain", "4", "4"},
        };

        Catalogue[] catalogues = {catInfo, catInfo, catInfo, catDroit, catDroit, catLitt, catLitt};
        for (int i = 0; i < livresData.length; i++) {
            Livre l = new Livre();
            l.setTitre(livresData[i][0]); l.setAuteur(livresData[i][1]);
            l.setCategorie(livresData[i][2]); l.setDescription(livresData[i][3]);
            l.setExemplairesTotaux(Integer.parseInt(livresData[i][4]));
            l.setExemplairesDisponibles(Integer.parseInt(livresData[i][5]));
            l.setCatalogue(catalogues[i]);
            livreRepo.save(l);
        }

        Quiz quiz = new Quiz();
        quiz.setTitre("Quiz Algorithmes"); quiz.setDescription("Testez vos connaissances en algorithmique");
        quiz.setPointsAGagner(50); quiz.setActif(true);
        quizRepo.save(quiz);

        String[][] questionsData = {
            {"Quelle est la complexité de la recherche binaire ?", "O(1)","O(n)","O(log n)","O(n²)", "2"},
            {"Quel tri a la meilleure complexité moyenne ?", "Tri à bulles","Tri rapide","Tri insertion","Tri sélection", "1"},
            {"Qu'est-ce qu'un algorithme récursif ?", "Un algo avec boucle","Un algo qui s'appelle lui-même","Un algo rapide","Un algo trié", "1"},
        };
        for (String[] qData : questionsData) {
            QuizQuestion q = new QuizQuestion();
            q.setQuiz(quiz); q.setQuestionTexte(qData[0]);
            q.setPropositionA(qData[1]); q.setPropositionB(qData[2]);
            q.setPropositionC(qData[3]); q.setPropositionD(qData[4]);
            q.setBonneReponseIndex(Integer.parseInt(qData[5]));
            questionRepo.save(q);
        }
    }
}
