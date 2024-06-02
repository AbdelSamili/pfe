import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pfe_1/features/centre/view/components/custom_appbar.dart';
import 'package:pfe_1/features/centre/view/screen/success_booked.dart';

class BookingPage extends StatefulWidget {
  final String idCentre;

  const BookingPage({super.key, required this.idCentre});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final Map<DateTime, Map<String, bool>> _calendarData = {};

  @override
  void initState() {
    super.initState();
    fetchCalendarData(_selectedDay);
  }

  void fetchCalendarData(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('calendars')
          .doc(widget.idCentre)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;  // Explicit casting
        Map<String, dynamic> dates = data['dates'] as Map<String, dynamic> ?? {};  // Ensuring it is cast as Map

        Map<String, bool> timesWithReservation = {};
        if (dates.containsKey(formattedDate)) {
          Map<String, dynamic> timeSlots = dates[formattedDate] as Map<String, dynamic>;  // Ensure this cast
          timeSlots.forEach((key, value) {
            if (value is Map<String, dynamic>) {  // Check for proper structure
              timesWithReservation[key] = value['reserved'] as bool;  // Safe casting for boolean values
            }
          });
        }
        setState(() {
          _calendarData[date] = timesWithReservation;
        });
      }
    } catch (e) {
      print('Error fetching calendar data: $e');
    }
  }


  Widget _buildTimeSlots() {
    Map<String, bool> workingHours = _calendarData[_selectedDay] ?? {};
    final List<Widget> slots = [];
    for (var i = 0; i < 24; i++) {
      String hour = '$i:00';
      bool? isReserved = workingHours[hour];
      slots.add(
          Container(
            decoration: BoxDecoration(
              color: isReserved == false ? Colors.blue : Colors.white,  // blue if available, white if not listed or reserved
              border: Border.all(color: isReserved == false ? Colors.blue : Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: isReserved == false ? () => _bookAppointment(hour) : null,  // Disable button if not available
              child: Text(
                hour,
                style: TextStyle(color: isReserved == false ? Colors.white : Colors.grey),
              ),
            ),
          )
      );
    }

    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: slots,
    );
  }

  Future<void> _bookAppointment(String time) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final dayOfWeek = DateFormat('EEEE').format(_selectedDay); // Get the day of the week
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You need to be logged in to book an appointment.")));
      return;
    }

    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Text('Do you want to book the appointment at $time on $formattedDate?'),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Confirm')),
        ],
      ),
    ) ?? false;

    if (!confirmed) return;

    try {
      DocumentReference appointmentRef = await FirebaseFirestore.instance.collection('Appointements').add({
        'centreId': widget.idCentre,
        'userId': currentUser.uid,
        'date': formattedDate,
        'day': dayOfWeek, // Add the day of the week
        'time': time,
        'etat': 'upcoming',
        'employeeId': 'null'
      });

      await FirebaseFirestore.instance.collection('calendars').doc(widget.idCentre).update({
        'dates.$formattedDate.$time.reserved': true
      });

      // Create a notification for the center
      await FirebaseFirestore.instance.collection('Notifications').add({
        'title': 'New Appointment Booked',
        'body': 'Appointment booked by ${currentUser.email} at $time on $formattedDate',
        'date': Timestamp.now(),
        'read': false,
        'type': 'center',  // Indicating this is for the center
        'relatedUserId': currentUser.uid,
        'relatedCenterId': widget.idCentre,
        'appointmentId': appointmentRef.id,
      });
      Get.to(() => const AppointmentBooked());
    } catch (e) {
      print('Error booking appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to book the appointment, please try again.")));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appTitle: 'Book Appointment', icon: FaIcon(Icons.arrow_back_ios)),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusDay,
            firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
            lastDay: DateTime(DateTime.now().year + 1, 12, 31),
            calendarFormat: _format,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusDay = focusedDay;
              });
              fetchCalendarData(selectedDay);
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          ),
          Expanded(child: _buildTimeSlots()),
        ],
      ),
    );
  }
}
