class Emprunt {
  final int? empruntId;
  final String dateEmprunt;
  final String dateRetourPrevue;
  final String? dateRetourEffective;
  final String statut;
  final int nombreProlongations;
  final Map<String, dynamic>? livre;

  Emprunt({
    this.empruntId,
    required this.dateEmprunt,
    required this.dateRetourPrevue,
    this.dateRetourEffective,
    required this.statut,
    this.nombreProlongations = 0,
    this.livre,
  });

  factory Emprunt.fromJson(Map<String, dynamic> json) => Emprunt(
    empruntId: json['empruntId'],
    dateEmprunt: json['dateEmprunt'] ?? '',
    dateRetourPrevue: json['dateRetourPrevue'] ?? '',
    dateRetourEffective: json['dateRetourEffective'],
    statut: json['statut'] ?? 'EN_COURS',
    nombreProlongations: json['nombreProlongations'] ?? 0,
    livre: json['livre'],
  );

  String get titreLivre => livre?['titre'] ?? 'Livre inconnu';
  bool get enRetard => statut == 'EN_RETARD';
  bool get peutProlonger => nombreProlongations == 0;
}