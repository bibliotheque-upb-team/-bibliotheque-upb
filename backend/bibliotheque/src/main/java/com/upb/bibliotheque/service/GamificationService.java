package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;

@Service
@RequiredArgsConstructor
public class GamificationService {
    private final QuizRepository quizRepo;
    private final QuizQuestionRepository questionRepo;
    private final ParticipationRepository participationRepo;
    private final BadgeRepository badgeRepo;
    private final EtudiantRepository etudiantRepo;
    private final NotificationService notifService;

    public List<Quiz> listerQuiz() { return quizRepo.findByActifTrue(); }

    public List<QuizQuestion> getQuestions(Long quizId) {
        return questionRepo.findByQuiz(quizRepo.findById(quizId)
            .orElseThrow(() -> new RuntimeException("Non trouvé")));
    }

    @Transactional
    public Map<String, Object> soumettre(Long quizId, Long etudiantId, List<Integer> reponses) {
        Quiz quiz = quizRepo.findById(quizId).orElseThrow(() -> new RuntimeException("Non trouvé"));
        Etudiant etudiant = etudiantRepo.findById(etudiantId).orElseThrow(() -> new RuntimeException("Non trouvé"));
        List<QuizQuestion> questions = questionRepo.findByQuiz(quiz);
        int score = 0;
        for (int i = 0; i < Math.min(reponses.size(), questions.size()); i++)
            if (reponses.get(i).equals(questions.get(i).getBonneReponseIndex())) score++;
        int pointsGagnes = (int) ((double) score / questions.size() * quiz.getPointsAGagner());
        Participation p = new Participation();
        p.setEtudiant(etudiant); p.setQuiz(quiz); p.setScore(score); p.setPointsGagnes(pointsGagnes);
        participationRepo.save(p);
        ajouterPoints(etudiantId, pointsGagnes);
        return Map.of("score", score + "/" + questions.size(), "pointsGagnes", pointsGagnes,
            "scoreReputation", etudiant.getScoreReputation());
    }

    @Transactional
    public void ajouterPoints(Long etudiantId, int points) {
        Etudiant e = etudiantRepo.findById(etudiantId)
            .orElseThrow(() -> new RuntimeException("Non trouvé"));
        e.setScoreReputation(e.getScoreReputation() + points);
        etudiantRepo.save(e);
        List<String> existants = badgeRepo.findByEtudiant(e).stream().map(Badge::getNom).toList();
        String[][] paliers = {
            {"50","Lecteur Débutant","50 pts","BookOpen"},
            {"150","Lecteur Assidu","150 pts","Library"},
            {"300","Passionné","300 pts","Heart"},
            {"500","Rat de Bibliothèque","500 pts","Search"},
            {"1000","Érudit UPB","1000 pts","GraduationCap"}
        };
        for (String[] pal : paliers) {
            if (e.getScoreReputation() >= Integer.parseInt(pal[0]) && !existants.contains(pal[1])) {
                Badge b = new Badge();
                b.setEtudiant(e); b.setNom(pal[1]); b.setDescription(pal[2]);
                b.setIcone(pal[3]); b.setPointsRequis(Integer.parseInt(pal[0]));
                badgeRepo.save(b);
                notifService.envoyer(e.getUtilisateurId(), "Nouveau Badge !",
                    "Badge obtenu : " + pal[1], Notification.TypeNotification.SUCCESS);
            }
        }
    }

    public List<Etudiant> classement() { return etudiantRepo.findTop10ByOrderByScoreReputationDesc(); }

    public List<Badge> mesBadges(Long etudiantId) {
        return badgeRepo.findByEtudiant(etudiantRepo.findById(etudiantId)
            .orElseThrow(() -> new RuntimeException("Non trouvé")));
    }
}
