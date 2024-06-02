import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreenClient extends StatelessWidget {
  final String clientId;

  const NotificationScreenClient({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime twoDaysFromNow = now.add(const Duration(days: 2));
    String formattedTwoDaysFromNow = DateFormat('yyyy-MM-dd').format(twoDaysFromNow);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Upcoming Appointments"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Appointements')
            .where('userId', isEqualTo: clientId)
            .where('date', isLessThanOrEqualTo: formattedTwoDaysFromNow)
            .orderBy('date', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No upcoming appointments within two days."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot appointmentDoc = snapshot.data!.docs[index];
              Map<String, dynamic> appointmentData = appointmentDoc.data()! as Map<String, dynamic>;

              // Check for required fields and handle missing data
              if (!appointmentData.containsKey('date') || !appointmentData.containsKey('centreId')) {
                return const ListTile(title: Text("Error: Appointment data is incomplete"));
              }

              String dateStr = appointmentData['date'];
              String centreId = appointmentData['centreId'];
              String time = appointmentData['time'] ?? 'Unknown time';
              bool isRead = appointmentData['read'] ?? false;

              DateTime appointmentDate;
              try {
                appointmentDate = DateFormat('yyyy-MM-dd').parse(dateStr);
              } catch (e) {
                return ListTile(title: Text("Error parsing date: $e"));
              }

              // Debug print statements to trace the issue
              print("Appointment Date: $dateStr");
              print("Center ID: $centreId");

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('Centers').doc(centreId).get(),
                builder: (context, centerSnapshot) {
                  if (centerSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading center details..."));
                  }
                  if (centerSnapshot.hasError) {
                    print("Error loading center details: ${centerSnapshot.error}");
                    return const ListTile(title: Text("Error loading center details."));
                  }
                  if (!centerSnapshot.hasData || !centerSnapshot.data!.exists) {
                    print("Center details not found for ID: $centreId");
                    return const ListTile(title: Text("Center details not found."));
                  }

                  Map<String, dynamic> centerData = centerSnapshot.data!.data()! as Map<String, dynamic>;

                  // Debug print statements for center data
                  print("Center Data: $centerData");

                  // Handle potential null values
                  String centerName = centerData['CenterName'] ?? 'Unknown Center';
                  String centerImage = centerData['ImageUrl'] ?? 'https://via.placeholder.com/150'; // Placeholder image

                  return Card(
                    color: isRead ? Colors.grey[300] : Colors.blue[100], // Grey if read, blue if unread
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(centerImage),
                        radius: 25,
                      ),
                      title: Text(
                        centerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("Appointment on ${DateFormat('yyyy-MM-dd').format(appointmentDate)} at $time"),
                      trailing: Icon(isRead ? Icons.visibility : Icons.visibility_off),
                      onTap: () {
                        // Mark notification as read
                        appointmentDoc.reference.update({'read': true});
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
