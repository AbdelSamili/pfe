import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pfe_1/features/centre/view/callender/modify_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
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
    } else {
      createDefaultCalendar(uid); // Create default calendar if it doesn't exist
    }
  }

  void createDefaultCalendar(String uid) async {
    // Create default calendar data
    Map<DateTime, Map<String, bool>> defaultCalendarData = {};
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime(DateTime.now().year, 12, 31);

    for (DateTime date = startDate; date.isBefore(endDate) || date.isAtSameMomentAs(endDate); date = date.add(const Duration(days: 1))) {
      if (!defaultCalendarData.containsKey(date)) {
        defaultCalendarData[date] = {};
      }
      for (int hour = 8; hour <= 13; hour++) {
        defaultCalendarData[date]!['$hour:00'] = true;
      }
    }

    // Save the default calendar data to Firestore
    Map<String, dynamic> calendarData = {
      'centerId': uid,
      'dates': defaultCalendarData.map((key, value) {
        return MapEntry(DateFormat('yyyy-MM-dd').format(key), value);
      }),
    };

    await FirebaseFirestore.instance.collection('calendars').doc(uid).set(calendarData);
    fetchCalendarData(); // Reload the calendar data
  }

  DateTime normalizeDateTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              bool? modified = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ModifyCalendarPage(),
                ),
              );
              if (modified == true) {
                fetchCalendarData(); // Reload calendar if modifications were made
              }
            },
          ),
        ],
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

        return Container(
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
        );
      }).toList(),
    );
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
