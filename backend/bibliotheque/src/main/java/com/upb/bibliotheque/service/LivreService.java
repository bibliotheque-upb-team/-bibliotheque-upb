package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LivreService {
    private final LivreRepository livreRepo;
    private final CatalogueRepository catalogueRepo;

    public List<Livre> listerTous() { return livreRepo.findAll(); }

    public Livre trouverParId(Long id) {
        return livreRepo.findById(id).orElseThrow(() -> new RuntimeException("Non trouvé"));
    }

    public List<Livre> rechercherParTitre(String titre) {
        return livreRepo.findByTitreContainingIgnoreCase(titre);
    }

    public Livre ajouter(Livre livre, Long catalogueId) {
        if (catalogueId != null) livre.setCatalogue(catalogueRepo.findById(catalogueId).orElse(null));
        return livreRepo.save(livre);
    }

    public Livre modifier(Long id, Livre modif) {
        Livre l = trouverParId(id);
        l.setTitre(modif.getTitre()); l.setAuteur(modif.getAuteur());
        l.setCategorie(modif.getCategorie()); l.setDescription(modif.getDescription());
        l.setExemplairesTotaux(modif.getExemplairesTotaux());
        l.setExemplairesDisponibles(modif.getExemplairesDisponibles());
        return livreRepo.save(l);
    }

    public void supprimer(Long id) { livreRepo.deleteById(id); }
}
