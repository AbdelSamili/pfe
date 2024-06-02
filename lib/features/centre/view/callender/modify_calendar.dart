import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class ModifyCalendarPage extends StatefulWidget {
  const ModifyCalendarPage({Key? key}) : super(key: key);

  @override
  _ModifyCalendarPageState createState() => _ModifyCalendarPageState();
}

class _ModifyCalendarPageState extends State<ModifyCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final DateTime _firstDay = DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
  final DateTime _lastDay = DateTime(DateTime.now().year, 12, 31);

  Map<DateTime, Map<String, bool>> _calendarData = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    removePastDays().then((_) {
      fetchCalendarData();
    });
  }

  void fetchCalendarData() async {
    setState(() {
      _isLoading = true;
    });
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = await FirebaseFirestore.instance.collection('calendars').doc(uid).get();
    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data()!['dates'] ?? {};
      setState(() {
        _calendarData.clear();
        data.forEach((key, value) {
          DateTime date = DateTime.parse(key);
          Map<String, bool> timesWithReservation = {};
          Map<String, dynamic> timeSlots = value as Map<String, dynamic>;
          timeSlots.forEach((timeKey, timeValue) {
            bool reservedStatus = timeValue['reserved'] as bool;
            timesWithReservation[timeKey] = reservedStatus;
          });
          _calendarData[date] = timesWithReservation;
        });
        _isLoading = false;
      });
    }
  }

  DateTime normalizeDateTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modify Calendar'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!mounted) return;
              setState(() {
                _selectedDay = normalizeDateTime(selectedDay);
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
          ),
          Expanded(
            child: _buildTimeSlots(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveCalendarToFirebase,
        backgroundColor: Colors.green,
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildTimeSlots() {
    Map<String, bool> workingHours = _calendarData[normalizeDateTime(_selectedDay)] ?? {};
    final List<String> allHours = List.generate(24, (index) => "$index:00");

    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: allHours.map((hour) {
        bool? isReserved = workingHours[hour];
        Color backgroundColor = isReserved == null ? Colors.white : (isReserved ? Colors.red : Colors.blue);
        TextStyle textStyle = TextStyle(color: isReserved == null ? Colors.black : Colors.white);

        return GestureDetector(
          onTap: () {
            if (isReserved == true) {
              // Display a dialog stating that the hour cannot be removed because it's reserved
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Cannot Remove Hour'),
                  content: const Text('This hour is reserved for an appointment and cannot be removed.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              // Toggle the hour: add if not present, remove if present and not reserved
              setState(() {
                if (isReserved == null) {
                  // Add hour with reserved = false
                  workingHours[hour] = false;
                } else {
                  // Remove the hour
                  workingHours.remove(hour);
                }
                _calendarData[normalizeDateTime(_selectedDay)] = workingHours;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: backgroundColor,
            ),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              hour,
              style: textStyle,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _saveCalendarToFirebase() async {
    setState(() {
      _isLoading = true;
    });
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> data = {
      'dates': {},
    };

    _calendarData.forEach((date, timeSlots) {
      Map<String, dynamic> formattedTimeSlots = {};
      timeSlots.forEach((time, reserved) {
        formattedTimeSlots[time] = {'reserved': reserved};
      });
      data['dates'][DateFormat('yyyy-MM-dd').format(date)] = formattedTimeSlots;
    });

    await FirebaseFirestore.instance.collection('calendars').doc(uid).set(data);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calendar updated')));
    Navigator.of(context).pop(true); // Pass true to indicate that changes were made
  }
  Future<void> removePastDays() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = await FirebaseFirestore.instance.collection('calendars').doc(
        uid).get();
    if (snapshot.exists && snapshot.data() != null) {
      Map<String, dynamic> data = snapshot.data()!['dates'] ?? {};
      DateTime now = DateTime.now();
      DateTime startOfToday = DateTime(now.year, now.month, now.day);
      List<String> keysToRemove = [];

      data.forEach((key, value) {
        DateTime date = DateTime.parse(key);
        if (date.isBefore(startOfToday)) {
          keysToRemove.add(key);
        }
      });

      if (keysToRemove.isNotEmpty) {
        for (String key in keysToRemove) {
          data.remove(key);
        }

        await FirebaseFirestore.instance.collection('calendars')
            .doc(uid)
            .update({
          'dates': data,
        });
      }
    }
  }
}
