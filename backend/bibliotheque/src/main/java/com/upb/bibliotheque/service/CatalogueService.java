package com.upb.bibliotheque.service;

import com.upb.bibliotheque.entity.*;
import com.upb.bibliotheque.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CatalogueService {
    private final CatalogueRepository catalogueRepo;
    private final LivreRepository livreRepo;

    public List<Catalogue> listerTous() { return catalogueRepo.findAll(); }

    public Catalogue creer(Catalogue c) { return catalogueRepo.save(c); }

    public Catalogue modifier(Long id, Catalogue modif) {
        Catalogue c = catalogueRepo.findById(id).orElseThrow(() -> new RuntimeException("Non trouvé"));
        c.setTitre(modif.getTitre());
        c.setCategorie(modif.getCategorie());
        c.setDescription(modif.getDescription());
        c.setNumero(modif.getNumero());
        c.setIcone(modif.getIcone());
        c.setCouleur(modif.getCouleur());
        return catalogueRepo.save(c);
    }

    public void supprimer(Long id) { catalogueRepo.deleteById(id); }

    public List<Livre> livresParCatalogue(Long catalogueId) {
        return livreRepo.findByCatalogue(catalogueRepo.findById(catalogueId)
            .orElseThrow(() -> new RuntimeException("Non trouvé")));
    }
}
