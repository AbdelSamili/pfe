import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime date;
  final bool read;
  final String type; // "client" or "center"
  final String relatedUserId;
  final String relatedCenterId;
  final String appointmentId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.read,
    required this.type,
    required this.relatedUserId,
    required this.relatedCenterId,
    required this.appointmentId,
  });

  factory NotificationModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data()!;
    return NotificationModel(
      id: snapshot.id,
      title: data['title'],
      body: data['body'],
      date: (data['date'] as Timestamp).toDate(),
      read: data['read'],
      type: data['type'],
      relatedUserId: data['relatedUserId'],
      relatedCenterId: data['relatedCenterId'],
      appointmentId: data['appointmentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'date': Timestamp.fromDate(date),
      'read': read,
      'type': type,
      'relatedUserId': relatedUserId,
      'relatedCenterId': relatedCenterId,
      'appointmentId': appointmentId,
    };
  }
}
