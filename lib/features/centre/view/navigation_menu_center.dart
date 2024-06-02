import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pfe_1/features/appointment/view/appointment_page_center.dart';
import 'package:pfe_1/features/centre/view/home/home_center.dart';
import 'package:pfe_1/features/centre/view/settings/settings_center.dart';
import 'package:pfe_1/features/notification/view/notification_center_view.dart';

class NavigationMenuCenter extends StatelessWidget {
  const NavigationMenuCenter({super.key});

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
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(icon: Icon(Iconsax.edit), label: "Gestion"),
            NavigationDestination(icon: Icon(Iconsax.notification), label: "Notification"),
            NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  Rx<int> selectedIndex = 0.obs;
  late List<Widget> screens;

  @override
  void onInit() {
    super.onInit();
    String centerId = FirebaseAuth.instance.currentUser?.uid ?? 'center_not_logged_in';

    // Use the centerId safely
    screens = [
      HomeCenterScreen(centerId: centerId),
      const AppointmentPageCenter(),
      centerId == 'center_not_logged_in'
          ? const PlaceholderWidget('Center not logged in')
          : NotificationScreenCenter(centerId: centerId),
      const AppSettingsCenterScreen(),
    ];
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
