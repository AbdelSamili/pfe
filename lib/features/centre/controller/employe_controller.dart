import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pfe_1/data/repositories/center/center_repository.dart';
import 'package:pfe_1/features/centre/model/employe_model.dart';
import 'package:pfe_1/utils/popups/loaders.dart';

class EmployeeController extends GetxController {
  static EmployeeController get instance => Get.find();

  var employees = <Employee>[].obs;
  var isLoading = false.obs; // Add loading state
  final GlobalKey<FormState> employeeFormKey = GlobalKey<FormState>();

  TextEditingController fullName = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController identification = TextEditingController();
  TextEditingController imageUrl = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  var hidePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    final centerId = FirebaseAuth.instance.currentUser?.uid;
    if (centerId != null) {
      fetchEmployees(centerId);
    } else {
      print('Error: Center ID is null.');
    }
  }

  Future<void> fetchEmployees(String centerId) async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Centers')
          .doc(centerId)
          .collection('Employees')
          .get();

      var employeeList = snapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList();
      employees.assignAll(employeeList);
    } catch (e) {
      print('Error fetching employees: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> addEmployee(String centerId, Employee employee) async {
    try {
      await FirebaseFirestore.instance
          .collection('Centers')
          .doc(centerId)
          .collection('Employees')
          .add(employee.toMap());

      fetchEmployees(centerId);
    } catch (e) {
      print('Error adding employee: $e');
    }
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dateOfBirth.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (image != null) {
        final uploadedImageUrl = await CenterRepository().uploadImage(
            'Centers/Images/Employees/', image);

        imageUrl.text = uploadedImageUrl;

        AppLoaders.successSnackBar(
            title: 'Success',
            message: 'Employee Image has been updated!');
      }
    } catch (e) {
      AppLoaders.errorSnackBar(
          title: 'Error', message: 'Something went wrong: $e');
    }
  }
}
