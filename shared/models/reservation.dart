class Reservation {
  final int? reservationId;
  final String dateReservation;
  final String statut;
  final int positionFileAttente;
  final Map<String, dynamic>? livre;

  Reservation({
    this.reservationId,
    required this.dateReservation,
    required this.statut,
    required this.positionFileAttente,
    this.livre,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
    reservationId: json['reservationId'],
    dateReservation: json['dateReservation'] ?? '',
    statut: json['statut'] ?? 'EN_ATTENTE',
    positionFileAttente: json['positionFileAttente'] ?? 0,
    livre: json['livre'],
  );

  String get titreLivre => livre?['titre'] ?? 'Livre inconnu';
}