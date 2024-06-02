import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/features/client/view/home/home_client.dart';
import 'package:pfe_1/features/client/view/settings/settings_client.dart';
import 'package:pfe_1/features/appointment/view/appointment_page_client.dart';
import 'package:pfe_1/features/notification/view/notification_client_view.dart'; // Import AppointmentPage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NavigationMenuClient extends StatelessWidget {
  const NavigationMenuClient({super.key,});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
            () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) => controller.selectedIndex.value = index,
          destinations: [
            const NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            const NavigationDestination(icon: Icon(Iconsax.calendar), label: "Appointment"),
            NavigationDestination(
              icon: Stack(
                children: [
                  const Icon(Iconsax.notification),
                  if (controller.unseenNotificationCount.value > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${controller.unseenNotificationCount.value}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: "Notification",
            ),
            const NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  Rx<int> selectedIndex = 0.obs;
  Rx<int> unseenNotificationCount = 0.obs;
  late List<Widget> screens;

  @override
  void onInit() {
    super.onInit();
    String? clientId = FirebaseAuth.instance.currentUser?.uid;

    if (clientId == null) {
      screens = [
        const HomeClientScreen(),
        const AppointmentPage(),
        const PlaceholderWidget('User not logged in'),  // Example placeholder
        const AppSettingsClientScreen(),
      ];
    } else {
      screens = [
        const HomeClientScreen(),
        const AppointmentPage(),
        NotificationScreenClient(clientId: clientId),  // Now safely passing a non-null userId
        const AppSettingsClientScreen(),
      ];
      fetchUnseenNotificationCount(clientId);
    }
  }

  void fetchUnseenNotificationCount(String clientId) {
    DateTime now = DateTime.now();
    DateTime twoDaysFromNow = now.add(const Duration(days: 2));
    String formattedTwoDaysFromNow = DateFormat('yyyy-MM-dd').format(twoDaysFromNow);

    FirebaseFirestore.instance
        .collection('Notifications')
        .where('relatedUserId', isEqualTo: clientId)
        .where('read', isEqualTo: false)
        .where('date', isLessThanOrEqualTo: formattedTwoDaysFromNow)
        .snapshots()
        .listen((snapshot) {
      unseenNotificationCount.value = snapshot.docs.length;
    });
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String message;

  const PlaceholderWidget(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
