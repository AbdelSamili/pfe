import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pfe_1/features/appointment/controller/appointment_controller.dart';
import 'package:pfe_1/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_1/utils/popups/loaders.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;
  bool isLoading = true;
  final appointmentController = AppointmentController.instance;
  List<dynamic> schedules = [];

  @override
  void initState() {
    getAppointments();
    super.initState();
    updateAppointmentStatuses();
  }

  Future<void> getAppointments() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<Map<String, dynamic>> appointments = await appointmentController
            .getAppointmentsForUserWithCentreDetails(user.uid);
        setState(() {
          schedules = appointments;
          isLoading = false;
        });
      } else {
        print('User is not currently signed in.');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  Future<void> updateAppointmentStatuses() async {
    try {
      final now = DateTime.now();
      final appointments = await FirebaseFirestore.instance.collection('Appointements').get();

      for (var doc in appointments.docs) {
        final data = doc.data();
        final appointmentDate = DateFormat('yyyy-MM-dd HH:mm').parse('${data['date']} ${data['time']}');
        if (appointmentDate.add(Duration(hours: 1)).isBefore(now) && data['etat'] == 'upcoming') {
          await doc.reference.update({'etat': 'complete'});
          await FirebaseFirestore.instance.collection('Notifications').add({
            'title': 'Appointment Complete',
            'body': 'Your appointment scheduled for ${data['time']} on ${data['date']} is now complete.',
            'date': Timestamp.now(),
            'read': false,
            'type': 'user',
            'relatedUserId': data['userId'],
            'relatedCenterId': data['centreId'],
            'appointmentId': doc.id,
          });
        }
      }
      getAppointments();
    } catch (e) {
      print('Error updating appointment statuses: $e');
    }
  }

  Future<void> cancelAppointment(Map<String, dynamic> appointment) async {
    try {
      final appointmentDate = DateFormat('yyyy-MM-dd').parse(appointment['date']);
      final difference = appointmentDate.difference(DateTime.now()).inDays;

      if (difference <= 3) {
        AppLoaders.errorSnackBar(title: "Appointment Can't Cancel", message: "You can't cancel the appointment less than 3 days before.");
        return;
      }

      await FirebaseFirestore.instance.collection('Appointements').doc(appointment['id']).update({
        'etat': 'cancel',
      });

      await FirebaseFirestore.instance.collection('calendars').doc(appointment['centreId']).update({
        'dates.${appointment['date']}.${appointment['time']}.reserved': false,
      });

      await FirebaseFirestore.instance.collection('Notifications').add({
        'title': 'Appointment Cancelled',
        'body': 'Appointment scheduled for ${appointment['time']} on ${appointment['date']} has been cancelled.',
        'date': Timestamp.now(),
        'read': false,
        'type': 'center',
        'relatedUserId': FirebaseAuth.instance.currentUser!.uid,
        'relatedCenterId': appointment['centreId'],
        'appointmentId': appointment['id'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment cancelled successfully.")),
      );

      getAppointments();
    } catch (e) {
      print('Error cancelling appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to cancel the appointment, please try again.")),
      );
    }
  }

  Future<void> rescheduleAppointment(Map<String, dynamic> appointment) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final difference = DateFormat('yyyy-MM-dd').parse(appointment['date']).difference(DateTime.now()).inDays;

    if (difference <= 3) {
      AppLoaders.errorSnackBar(title: "Appointment Can't Reschedule", message: "You can't reschedule the appointment less than 3 days before.");
      return;
    }

    final newTime = await showDialog<String>(
      context: context,
      builder: (context) => TimeSlotDialog(centerId: appointment['centreId'], date: appointment['date']),
    );

    if (newTime == null || newTime.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('Appointements').doc(appointment['id']).update({
        'time': newTime,
        'date': appointment['date'],
      });

      await FirebaseFirestore.instance.collection('calendars').doc(appointment['centreId']).update({
        'dates.${appointment['date']}.${appointment['time']}.reserved': false,
        'dates.${appointment['date']}.$newTime.reserved': true,
      });

      await FirebaseFirestore.instance.collection('Notifications').add({
        'title': 'Appointment Rescheduled',
        'body': 'Appointment rescheduled to $newTime on ${appointment['date']}',
        'date': Timestamp.now(),
        'read': false,
        'type': 'center',
        'relatedUserId': FirebaseAuth.instance.currentUser!.uid,
        'relatedCenterId': appointment['centreId'],
        'appointmentId': appointment['id'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment rescheduled successfully.")),
      );

      getAppointments();
    } catch (e) {
      print('Error rescheduling appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to reschedule the appointment, please try again.")),
      );
    }
  }

  Future<void> deleteAppointment(Map<String, dynamic> appointment) async {
    try {
      await FirebaseFirestore.instance.collection('Appointements').doc(appointment['id']).delete();

      await FirebaseFirestore.instance.collection('Notifications').add({
        'title': 'Appointment Deleted',
        'body': 'Appointment scheduled for ${appointment['time']} on ${appointment['date']} has been deleted.',
        'date': Timestamp.now(),
        'read': false,
        'type': 'center',
        'relatedUserId': FirebaseAuth.instance.currentUser!.uid,
        'relatedCenterId': appointment['centreId'],
        'appointmentId': appointment['id'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment deleted successfully.")),
      );

      getAppointments();
    } catch (e) {
      print('Error deleting appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete the appointment, please try again.")),
      );
    }
  }

  Future<void> _showCancelDialog(Map<String, dynamic> appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Cancellation'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      cancelAppointment(appointment);
    }
  }

  Future<void> _showRescheduleDialog(Map<String, dynamic> appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Reschedule'),
        content: const Text('Are you sure you want to reschedule this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      rescheduleAppointment(appointment);
    }
  }

  Future<void> _showDeleteDialog(Map<String, dynamic> appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      deleteAppointment(appointment);
    }
  }

  Future<void> _showReviewDialog(Map<String, dynamic> appointment) async {
    await showDialog(
      context: context,
      builder: (context) => ReviewDialog(appointment: appointment),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: CircularProgressIndicator(),
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
                        for (FilterStatus filterStatus in FilterStatus.values)
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (filterStatus == FilterStatus.upcoming) {
                                    status = FilterStatus.upcoming;
                                    _alignment = Alignment.centerLeft;
                                  } else if (filterStatus == FilterStatus.complete) {
                                    status = FilterStatus.complete;
                                    _alignment = Alignment.center;
                                  } else if (filterStatus == FilterStatus.cancel) {
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
                                  backgroundImage: schedule['centreDetails'] != null &&
                                      schedule['centreDetails']['ImageUrl'] != null
                                      ? NetworkImage(schedule['centreDetails']['ImageUrl'])
                                      : null,
                                  child: schedule['centreDetails'] != null &&
                                      schedule['centreDetails']['ImageUrl'] == null
                                      ? const Icon(Icons.business, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      schedule['centreDetails'] != null &&
                                          schedule['centreDetails']['CenterName'] != null
                                          ? schedule['centreDetails']['CenterName']
                                          : 'Unknown Center',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      schedule['centreDetails'] != null &&
                                          schedule['centreDetails']['Matricule'] != null
                                          ? schedule['centreDetails']['Matricule']
                                          : '',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (schedule['etat'] == FilterStatus.upcoming)
                                  ...[
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.red[600],
                                        ),
                                        onPressed: () => _showCancelDialog(schedule),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: Colors.green[600],
                                        ),
                                        onPressed: () => _showRescheduleDialog(schedule),
                                        child: const Text(
                                          'Reschedule',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                if (schedule['etat'] == FilterStatus.cancel)
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.red[600],
                                      ),
                                      onPressed: () => _showDeleteDialog(schedule),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                if (schedule['etat'] == FilterStatus.complete)
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.blue[600],
                                      ),
                                      onPressed: () => _showReviewDialog(schedule),
                                      child: const Text(
                                        'Add Review',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
  const ScheduleCard({super.key, required this.date, required this.day, required this.time});
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
            ),
          ),
        ],
      ),
    );
  }
}

class TimeSlotDialog extends StatelessWidget {
  final String centerId;
  final String date;

  TimeSlotDialog({required this.centerId, required this.date});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('calendars').doc(centerId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No time slots available."));
          }

          final calendarData = snapshot.data!.data() as Map<String, dynamic>;
          final timesWithReservation = (calendarData['dates'][date] as Map<String, dynamic>?) ?? {};

          final availableSlots = timesWithReservation.entries
              .where((entry) => entry.value['reserved'] == false)
              .map((entry) => entry.key)
              .toList();

          if (availableSlots.isEmpty) {
            return const Center(child: Text("No available time slots."));
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: availableSlots.length,
            itemBuilder: (context, index) {
              final timeSlot = availableSlots[index];
              return ListTile(
                title: Text(timeSlot),
                onTap: () {
                  Navigator.of(context).pop(timeSlot);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ReviewDialog extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const ReviewDialog({super.key, required this.appointment});

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final descriptionController = TextEditingController();
  int starRating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Review'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < starRating ? Icons.star : Icons.star_border,
                  color: index < starRating ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    starRating = index + 1;
                  });
                },
              );
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseFirestore.instance.collection('Reviews').add({
              'description': descriptionController.text,
              'stars': starRating,
              'centerId': widget.appointment['centreId'],
              'appointmentId': widget.appointment['id'],
              'userId': FirebaseAuth.instance.currentUser!.uid,
            });
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Review added successfully.")),
            );
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
