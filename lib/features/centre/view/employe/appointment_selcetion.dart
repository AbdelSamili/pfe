import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_1/features/appointment/controller/appointment_controller.dart';
import 'package:pfe_1/features/appointment/models/appointment.dart';
import 'package:pfe_1/features/centre/model/employe_model.dart';

class AppointmentSelectionPage extends StatelessWidget {
  final Employee employee;

  const AppointmentSelectionPage({required this.employee, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppointmentController controller = Get.put(AppointmentController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Appointment for ${employee.fullName}'),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: controller.getAvailableUpcomingAppointments(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading appointments'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No upcoming appointments found'));
          } else {
            final appointments = snapshot.data!;
            print('Appointments found: ${appointments.length}'); // Debug print
            return ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return ListTile(
                  title: Text('${appointment.date} ${appointment.time}'),
                  subtitle: Text('State: ${appointment.etat}'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await controller.associateEmployeeWithAppointment(employee.id, appointment.id);
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Employee associated with appointment successfully',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Text('Select'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
