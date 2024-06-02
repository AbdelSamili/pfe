import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/features/centre/controller/employe_controller.dart';
import 'package:pfe_1/features/centre/model/employe_model.dart';
import 'package:pfe_1/features/centre/view/employe/widgets/employe_form.dart';
import 'package:pfe_1/utils/constants/sizes.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmployeeController());
    // Get the authenticated user's UID
    final centerId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Employee"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          children: [
            const EmployeeForm(),
            const SizedBox(height: AppSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.employeeFormKey.currentState!.validate()) {
                    final employee = Employee(
                      fullName: controller.fullName.text,
                      dateOfBirth: controller.dateOfBirth.text,
                      identification: controller.identification.text,
                      imageUrl: controller.imageUrl.text,
                      phoneNumber: controller.phoneNumber.text,
                      id: '',
                    );

                    if (centerId != null) {
                      await controller.addEmployee(centerId, employee); // Use the non-null centerId
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Employee added successfully',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'User not authenticated',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  }
                },
                child: const Text("Add Employee"),
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwInputFields),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
