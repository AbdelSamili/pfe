import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pfe_1/features/notification/model/notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<NotificationModel>> fetchNotificationsForUser(String userId) {
    return _firestore
        .collection('Notifications')
        .where('relatedUserId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => NotificationModel.fromSnapshot(doc)).toList());
  }

  Stream<List<NotificationModel>> fetchNotificationsForCenter(String centerId) {
    return _firestore
        .collection('Notifications')
        .where('relatedCenterId', isEqualTo: centerId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => NotificationModel.fromSnapshot(doc)).toList());
  }

  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('Notifications').doc(notificationId).update({'read': true});
  }
}
