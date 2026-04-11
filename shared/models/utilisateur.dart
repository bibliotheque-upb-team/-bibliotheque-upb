class Utilisateur {
  final int? utilisateurId;
  final String identifiant;
  final String email;
  final String nom;
  final String prenom;
  final String? filiere;
  final String? anneeEtude;
  final int scoreReputation;
  final bool actif;
  final String typeUtilisateur;

  Utilisateur({
    this.utilisateurId,
    required this.identifiant,
    required this.email,
    required this.nom,
    required this.prenom,
    this.filiere,
    this.anneeEtude,
    this.scoreReputation = 0,
    this.actif = true,
    this.typeUtilisateur = 'ETUDIANT',
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) => Utilisateur(
    utilisateurId: json['utilisateurId'],
    identifiant: json['identifiant'] ?? '',
    email: json['email'] ?? '',
    nom: json['nom'] ?? '',
    prenom: json['prenom'] ?? '',
    filiere: json['filiere'],
    anneeEtude: json['anneeEtude'],
    scoreReputation: json['scoreReputation'] ?? 0,
    actif: json['actif'] ?? true,
    typeUtilisateur: json['type_utilisateur'] ?? 'ETUDIANT',
  );

  String get initiales =>
      '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}';
}