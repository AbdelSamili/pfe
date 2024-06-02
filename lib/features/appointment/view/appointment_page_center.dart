import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pfe_1/features/appointment/controller/appointment_controller.dart';
import 'package:pfe_1/features/client/controller/client_controller.dart'; // Import ClientController
import 'package:pfe_1/features/client/model/client_model.dart';
import 'package:pfe_1/utils/config.dart';
import 'package:flutter/material.dart';

class AppointmentPageCenter extends StatefulWidget {
  const AppointmentPageCenter({super.key});

  @override
  State<AppointmentPageCenter> createState() => _AppointmentPageState();
}

// enum for appointment status
enum FilterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPageCenter> {
  FilterStatus status = FilterStatus.upcoming; // initial status
  Alignment _alignment = Alignment.centerLeft;
  bool isLoading = true;
  final appointmentController = Get.put(AppointmentController());

  List<dynamic> schedules = [];

  @override
  void initState() {
    getAppointments();
    super.initState();
  }

  Future<void> getAppointments() async {
    try {
      // Get the currently signed-in user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print(user.uid);

        // Use the already initialized controller in NavigationMenuClient
        List<Map<String, dynamic>> appointments = await appointmentController
            .getAppointmentsForCenterWithCentreDetails(user.uid);
        print(appointments);

        setState(() {
          schedules = appointments;
          isLoading = false;
        });
      } else {
        print('User is not currently signed in.');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    // final controller = CenterController.instance;
    final clientController = Get.put(ClientController()); // Get an instance of ClientController
    List<dynamic> filteredSchedules = schedules.where((var schedule) {
      switch (schedule['etat']) {
        case 'upcoming':
          schedule['etat'] = FilterStatus.upcoming;
          break;
        case 'complete':
          schedule['etat'] = FilterStatus.complete;
          break;
        case 'cancel':
          schedule['etat'] = FilterStatus.cancel;
          break;
      }
      return schedule['etat'] == status;
    }).toList();
    if (isLoading) {
      return const Center(
        child:
        CircularProgressIndicator(), // Circular loading indicator
      );
    } else {
      return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Appointment Schedule',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Filter tabs
                          for (FilterStatus filterStatus in FilterStatus.values)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (filterStatus == FilterStatus.upcoming) {
                                      status = FilterStatus.upcoming;
                                      _alignment = Alignment.centerLeft;
                                    } else if (filterStatus ==
                                        FilterStatus.complete) {
                                      status = FilterStatus.complete;
                                      _alignment = Alignment.center;
                                    } else if (filterStatus ==
                                        FilterStatus.cancel) {
                                      status = FilterStatus.cancel;
                                      _alignment = Alignment.centerRight;
                                    }
                                  });
                                },
                                child: Center(
                                  child: Text(filterStatus.name),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    AnimatedAlign(
                      alignment: _alignment,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Config.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            status.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Config.spaceSmall,
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredSchedules.length,
                    itemBuilder: ((context, index) {
                      var schedule = filteredSchedules[index];
                      bool isLastElement = filteredSchedules.length + 1 == index;

                      return FutureBuilder<ClientModel>(
                        future: clientController.getClientInformation(schedule['userId']), // Fetch client information for each appointment
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show loading indicator while fetching client information
                          } else {
                            if (snapshot.hasData) {
                              var client = snapshot.data!;
                              return Card(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: !isLastElement
                                    ? const EdgeInsets.only(bottom: 20)
                                    : EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(client.profileImage), // Display client's profile image
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${client.firstName} ${client.lastName}', // Display client's name
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                client.email,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      ScheduleCard(
                                        date: schedule['date'],
                                        day: schedule['day'],
                                        time: schedule['time'],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Expanded(
                                      //       child: OutlinedButton(
                                      //         style: OutlinedButton.styleFrom(
                                      //           backgroundColor: Colors.red[600],
                                      //         ),
                                      //         onPressed: () {
                                      //           // Update appointment state to 'cancel'
                                      //           // Here you can call your method to update appointment state
                                      //         },
                                      //         child: const Text(
                                      //           'Cancel',
                                      //           style: TextStyle(color: Colors.white),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     const SizedBox(
                                      //       width: 20,
                                      //     ),
                                      //     Expanded(
                                      //       child: OutlinedButton(
                                      //         style: OutlinedButton.styleFrom(
                                      //           backgroundColor: Colors.green[600],
                                      //         ),
                                      //         onPressed: () {
                                      //           // Update appointment state to 'complete'
                                      //           // Here you can call your method to update appointment state
                                      //         },
                                      //         child: const Text(
                                      //           'Accept',
                                      //           style: TextStyle(color: Colors.white),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const Text('No data');
                            }
                          }
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
      );
    }
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard(
      {super.key, required this.date, required this.day, required this.time});
  final String date;
  final String day;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.black,
            size: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '$day, $date',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Colors.black,
            size: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
                time,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ))
        ],
      ),
    );
  }
}
