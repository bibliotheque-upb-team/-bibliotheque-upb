package com.upb.bibliotheque.repository;
import com.upb.bibliotheque.entity.Catalogue;
import org.springframework.data.jpa.repository.JpaRepository;
public interface CatalogueRepository extends JpaRepository<Catalogue, Long> {}