import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pfe_1/common/widgets/appbar/appbar.dart';
import 'package:pfe_1/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:pfe_1/common/widgets/image/circulat_image.dart';
import 'package:pfe_1/common/widgets/list_tile/user_profile_tile.dart';
import 'package:pfe_1/features/centre/controller/center_controller.dart';
import 'package:pfe_1/features/centre/controller/employe_controller.dart';
import 'package:pfe_1/features/centre/view/employe/add_employe_view.dart';
import 'package:pfe_1/features/centre/view/employe/appointments_with_employees_page.dart';
import 'package:pfe_1/features/centre/view/employe/employe_view.dart';
import 'package:pfe_1/features/centre/view/profile/profile_center.dart';
import 'package:pfe_1/features/centre/view/review/review.dart';
import 'package:pfe_1/features/centre/view/callender/calender.dart'; // Update the import to use CalendarPage
import 'package:pfe_1/features/centre/view/settings/widgets/section_heading.dart';
import 'package:pfe_1/utils/constants/colors.dart';
import 'package:pfe_1/utils/constants/images_strings.dart';
import 'package:pfe_1/utils/constants/sizes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppSettingsCenterScreen extends StatelessWidget {
  const AppSettingsCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CenterController());

    return RefreshIndicator(
      onRefresh: () async {
        await controller.fetchClientRecord();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppPrimaryHeaderContainer(
                child: Column(
                  children: [
                    CAppBar(
                      title: Text(
                        'Account',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Obx(
                          () => ListTile(
                        leading: Obx(() {
                          final networkImage = controller.center.value.profileImage;
                          final image = networkImage.isNotEmpty ? networkImage : AppImages.userImage;
                          return AppCircularImage(
                            image: image,
                            isNetworkImage: networkImage.isNotEmpty,
                          );
                        }),
                        title: Text(controller.center.value.centerName, style: Theme.of(context).textTheme.titleLarge!),
                        subtitle: Text(controller.center.value.email, style: Theme.of(context).textTheme.bodyMedium!),
                        trailing: IconButton(
                          onPressed: () => Get.to(() => const AppProfileScreenCenter()),
                          icon: const Icon(Iconsax.edit, color: AppColors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceBtwSections),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.defaultSpace),
                child: Column(
                  children: [
                    const AppSectionHeading(title: "Account Settings", showActionButton: false),
                    const SizedBox(height: AppSizes.spaceBtwItems),
                    AppSettingsMenuTile(
                      icon: Iconsax.star,
                      title: 'My Reviews',
                      subTitle: 'The Reviews for Completed Appointment',
                      onTap: () {
                        Get.to(() => ReviewsPage(centerId: controller.center.value.id));
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceBtwItems),
                    AppSettingsMenuTile(
                      icon: Iconsax.calendar,
                      title: 'My calendar',
                      subTitle: 'Create and modify your calendar',
                      onTap: () async {
                        await checkAndSetupDefaultCalendar();
                        Get.to(() => const CalendarPage());
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceBtwItems),
                    AppSettingsMenuTile(
                      icon: Iconsax.user,
                      title: 'Employes',
                      subTitle: 'add and assoicate employes with appointment',
                      onTap: () => Get.to(() => EmployeeViewScreen()),
                    ),
                    const SizedBox(height: AppSizes.spaceBtwItems),
                    AppSettingsMenuTile(
                      icon: Iconsax.bag_tick,
                      title: 'My Appointement',
                      subTitle: 'In-progress and Completed Appointement',
                      onTap: () => Get.to(() => AppointmentsWithEmployeesPage()),
                    ),
                    const SizedBox(height: AppSizes.spaceBtwSections),
                    const AppSectionHeading(title: 'App Settings', showActionButton: false),
                    const SizedBox(height: AppSizes.spaceBtwItems),
                    const AppSettingsMenuTile(
                      icon: Iconsax.document_upload,
                      title: 'Load Data',
                      subTitle: 'Upload Data to your Cloud Firebase',
                    ),
                    AppSettingsMenuTile(
                      icon: Iconsax.location,
                      title: 'Geolocation',
                      subTitle: 'Set recommendation based on location',
                      trailing: Switch(value: true, onChanged: (value) {}),
                    ),
                    const SizedBox(height: AppSizes.spaceBtwSections),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => controller.logOutAccountWarningPopup(),
                        child: const Text('Logout'),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceBtwSections * 2.5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkAndSetupDefaultCalendar() async {
    String centerId = FirebaseAuth.instance.currentUser!.uid;
    var calendarSnapshot = await FirebaseFirestore.instance.collection('calendars').doc(centerId).get();

    if (!calendarSnapshot.exists) {
      // Set up default calendar
      Map<String, dynamic> defaultCalendar = {
        'centerId': centerId,
        'dates': {},
      };

      DateTime startDate = DateTime.now();
      DateTime endDate = DateTime(DateTime.now().year, 12, 31);

      for (DateTime date = startDate;
      date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
      date = date.add(const Duration(days: 1))) {
        Map<String, dynamic> slots = {};
        for (int hour = 8; hour <= 13; hour++) {
          slots['$hour:00'] = {'reserved': false};
        }
        String dateKey = DateFormat('yyyy-MM-dd').format(date);
        defaultCalendar['dates'][dateKey] = slots;
      }

      await FirebaseFirestore.instance.collection('calendars').doc(centerId).set(defaultCalendar);
    }
  }
}
