class Livre {
  final int? livreId;
  final String titre;
  final String auteur;
  final String? categorie;
  final String? isbn;
  final String? description;
  final int exemplairesTotaux;
  final int exemplairesDisponibles;
  final String? imageUrl;
  final String? couleur3d;
  final int? epaisseur3d;
  final int? hauteur3d;

  Livre({
    this.livreId,
    required this.titre,
    required this.auteur,
    this.categorie,
    this.isbn,
    this.description,
    this.exemplairesTotaux = 1,
    this.exemplairesDisponibles = 1,
    this.imageUrl,
    this.couleur3d,
    this.epaisseur3d,
    this.hauteur3d,
  });

  factory Livre.fromJson(Map<String, dynamic> json) => Livre(
    livreId: json['livreId'],
    titre: json['titre'] ?? '',
    auteur: json['auteur'] ?? '',
    categorie: json['categorie'],
    isbn: json['isbn'],
    description: json['description'],
    exemplairesTotaux: json['exemplairesTotaux'] ?? 1,
    exemplairesDisponibles: json['exemplairesDisponibles'] ?? 1,
    imageUrl: json['imageUrl'],
    couleur3d: json['couleur3d'],
    epaisseur3d: json['epaisseur3d'],
    hauteur3d: json['hauteur3d'],
  );

  bool get estDisponible => exemplairesDisponibles > 0;
}