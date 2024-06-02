import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/features/appointment/controller/appointment_controller.dart';

class AppointmentsWithEmployeesPage extends StatelessWidget {
  const AppointmentsWithEmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppointmentController controller = Get.put(AppointmentController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments with Employees'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: controller.getAppointmentsWithEmployees(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading appointments'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No appointments found'));
          } else {
            final appointmentsWithEmployees = snapshot.data!;
            return ListView.builder(
              itemCount: appointmentsWithEmployees.length,
              itemBuilder: (context, index) {
                final appointmentData = appointmentsWithEmployees[index];
                final employeeData = appointmentData['employee'];
                final clientData = appointmentData['client'];
                return AppointmentEmployeeCard(
                  appointmentData: appointmentData,
                  employeeData: employeeData,
                  clientData: clientData,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class AppointmentEmployeeCard extends StatelessWidget {
  final Map<String, dynamic> appointmentData;
  final Map<String, dynamic>? employeeData;
  final Map<String, dynamic>? clientData;

  const AppointmentEmployeeCard({
    required this.appointmentData,
    required this.employeeData,
    required this.clientData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${appointmentData['date']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Time: ${appointmentData['time']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            Divider(),
            Text(
              'Employee Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            if (employeeData != null) ...[
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(employeeData!['imageUrl']),
                    radius: 30,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeData!['fullName'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Phone: ${employeeData!['phoneNumber']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'ID: ${employeeData!['identification']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
