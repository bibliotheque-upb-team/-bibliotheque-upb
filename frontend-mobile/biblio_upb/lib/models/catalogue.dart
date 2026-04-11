class Catalogue {
  final int? catalogueId;
  final int numero;
  final String titre;
  final String categorie;
  final String description;
  final String icone;
  final String couleur;

  Catalogue({
    this.catalogueId,
    required this.numero,
    required this.titre,
    required this.categorie,
    required this.description,
    required this.icone,
    required this.couleur,
  });

  factory Catalogue.fromJson(Map<String, dynamic> json) => Catalogue(
    catalogueId: json['catalogueId'],
    numero: json['numero'] ?? 0,
    titre: json['titre'] ?? '',
    categorie: json['categorie'] ?? '',
    description: json['description'] ?? '',
    icone: json['icone'] ?? 'Package',
    couleur: json['couleur'] ?? 'blue',
  );
}