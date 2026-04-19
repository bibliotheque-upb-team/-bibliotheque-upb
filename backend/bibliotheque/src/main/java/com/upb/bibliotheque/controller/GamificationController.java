package com.upb.bibliotheque.controller;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.service.GamificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/gamification")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class GamificationController {
    private final GamificationService gamificationService;

    @GetMapping("/quiz")
    public List<Quiz> listerQuiz() { return gamificationService.listerQuiz(); }

    @GetMapping("/quiz/{quizId}/questions")
    public List<QuizQuestion> getQuestions(@PathVariable Long quizId) {
        return gamificationService.getQuestions(quizId);
    }

    @PostMapping("/quiz/{quizId}/soumettre")
    public ResponseEntity<Map<String, Object>> soumettre(@PathVariable Long quizId,
                                                          @RequestBody Map<String, Object> body) {
        Long etudiantId = Long.valueOf(body.get("etudiantId").toString());
        @SuppressWarnings("unchecked")
        List<Integer> reponses = (List<Integer>) body.get("reponses");
        return ResponseEntity.ok(gamificationService.soumettre(quizId, etudiantId, reponses));
    }

    @GetMapping("/classement")
    public List<Etudiant> classement() { return gamificationService.classement(); }

    @GetMapping("/badges/{etudiantId}")
    public List<Badge> mesBadges(@PathVariable Long etudiantId) {
        return gamificationService.mesBadges(etudiantId);
    }
}
