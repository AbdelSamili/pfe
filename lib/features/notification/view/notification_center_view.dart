import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationScreenCenter extends StatelessWidget {
  final String centerId;

  const NotificationScreenCenter({super.key, required this.centerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Center Notifications"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Notifications')
            .where('relatedCenterId', isEqualTo: centerId)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error.toString()}"));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot notificationDoc = snapshot.data!.docs[index];
              Map<String, dynamic> notificationData = notificationDoc.data()! as Map<String, dynamic>;

              // Check for required fields and handle missing data
              if (!notificationData.containsKey('appointmentId') || !notificationData.containsKey('relatedUserId')) {
                return const ListTile(title: Text("Error: Notification data is incomplete"));
              }

              String appointmentId = notificationData['appointmentId'];
              String clientId = notificationData['relatedUserId'];
              String title = notificationData['title'] ?? 'No title';
              String body = notificationData['body'] ?? 'No details';

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('Clients').doc(clientId).get(),
                builder: (context, clientSnapshot) {
                  if (clientSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text("Loading client details..."));
                  }
                  if (clientSnapshot.hasError) {
                    print("Error loading client details: ${clientSnapshot.error}");
                    return const ListTile(title: Text("Error loading client details."));
                  }
                  if (!clientSnapshot.hasData || !clientSnapshot.data!.exists) {
                    print("Client details not found for ID: $clientId");
                    return const ListTile(title: Text("Client details not found."));
                  }

                  Map<String, dynamic> clientData = clientSnapshot.data!.data()! as Map<String, dynamic>;

                  // Handle potential null values
                  String clientName = clientData['UserName'] ?? 'Unknown Client';
                  String clientEmail = clientData['Email'] ?? 'Unknown Email';
                  String clientImage = clientData['ImageUrl'] ?? 'https://via.placeholder.com/150';

                  return Card(
                    color: notificationData['read'] ? Colors.white : Colors.blue[100],
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(clientImage),
                        radius: 25,
                      ),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(body),
                          const SizedBox(height: 5),
                          Text("Client: $clientName"),
                          Text("Email: $clientEmail"),
                        ],
                      ),
                      trailing: Icon(notificationData['read'] ? Icons.visibility : Icons.visibility_off),
                      onTap: () {
                        notificationDoc.reference.update({'read': true});
                        // Optional: Add additional action on tap
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
