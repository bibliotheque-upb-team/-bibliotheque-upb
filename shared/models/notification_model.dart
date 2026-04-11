class NotificationModel {
  final int? notificationId;
  final String titre;
  final String message;
  final String type;
  final bool lue;
  final String dateCreation;

  NotificationModel({
    this.notificationId,
    required this.titre,
    required this.message,
    required this.type,
    this.lue = false,
    required this.dateCreation,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        notificationId: json['notificationId'],
        titre: json['titre'] ?? '',
        message: json['message'] ?? '',
        type: json['type'] ?? 'INFO',
        lue: json['lue'] ?? false,
        dateCreation: json['dateCreation'] ?? '',
      );
}