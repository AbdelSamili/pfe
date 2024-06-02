import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/features/centre/controller/employe_controller.dart';
import 'package:pfe_1/features/centre/model/employe_model.dart';
import 'package:pfe_1/features/centre/view/employe/add_employe_view.dart';
import 'package:pfe_1/features/centre/view/employe/appointment_selcetion.dart';

class EmployeeViewScreen extends StatelessWidget {
  const EmployeeViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EmployeeController controller = Get.put(EmployeeController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Get.to(() => AddEmployeeScreen());
              },
              color: Colors.blue,
              iconSize: 30,
              padding: EdgeInsets.all(10),
              splashColor: Colors.white,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.employees.isEmpty) {
          return Center(child: Text('No employees found'));
        } else {
          return ListView.builder(
            itemCount: controller.employees.length,
            itemBuilder: (context, index) {
              final Employee employee = controller.employees[index];
              return EmployeeCard(employee: employee);
            },
          );
        }
      }),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(employee.imageUrl),
                  radius: 30,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.fullName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'ID: ${employee.identification}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: Colors.blue[200]),
            SizedBox(height: 10),
            Text(
              'Date of Birth: ${employee.dateOfBirth}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[600],
              ),
            ),
            Text(
              'Phone Number: ${employee.phoneNumber}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[600],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => AppointmentSelectionPage(employee: employee));
                },
                child: Text('Associate with Appointment'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
