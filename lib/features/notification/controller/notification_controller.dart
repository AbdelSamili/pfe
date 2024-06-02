import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pfe_1/data/repositories/notification/notification_repository.dart';
import 'package:pfe_1/features/notification/model/notification_model.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();
  final Rx<List<NotificationModel>> clientNotifications = Rx<List<NotificationModel>>([]);
  final Rx<List<NotificationModel>> centerNotifications = Rx<List<NotificationModel>>([]);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Retrieve repository using Get.find()
  final NotificationRepository repository = Get.put(NotificationRepository());


  Stream<List<NotificationModel>> fetchClientNotifications(String userId) {
    return firestore.collection('Notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => NotificationModel.fromSnapshot(doc)).toList());
  }

  Stream<List<NotificationModel>> fetchNotificationsForCenter(String centerId) {
    return FirebaseFirestore.instance
        .collection('Notifications')
        .where('userId', isEqualTo: centerId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => NotificationModel.fromSnapshot(doc)).toList());
  }


  void markNotificationAsRead(String notificationId) {
    repository.markAsRead(notificationId);
  }
}
