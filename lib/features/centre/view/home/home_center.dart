import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfe_1/utils/constants/colors.dart';
import 'package:pfe_1/utils/helper/helper_function.dart';

class HomeCenterScreen extends StatelessWidget {
  final String centerId;

  const HomeCenterScreen({super.key, required this.centerId});

  Stream<QuerySnapshot> _fetchAppointmentsForToday() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    return FirebaseFirestore.instance
        .collection('Appointements')
        .where('centreId', isEqualTo: centerId)
        .where('date', isEqualTo: formattedDate)
        .snapshots();
  }

  Stream<QuerySnapshot> _fetchMostClients() {
    return FirebaseFirestore.instance
        .collection('Appointements')
        .where('centreId', isEqualTo: centerId)
        .snapshots();
  }

  Stream<QuerySnapshot> _fetchTotalAppointments() {
    return FirebaseFirestore.instance
        .collection('Appointements')
        .where('centreId', isEqualTo: centerId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Center Dashboard",style: Theme.of(context).textTheme.headlineMedium,),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader("Today's Appointments"),
              const SizedBox(height: 10),
              _buildAppointmentsForToday(),
              const SizedBox(height: 20),
              _buildHeader("Most Clients"),
              const SizedBox(height: 10),
              _buildMostClients(),
              const SizedBox(height: 20),
              _buildHeader("Statistics"),
              const SizedBox(height: 10),
              _buildStatistics(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
    );
  }

  Widget _buildAppointmentsForToday() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fetchAppointmentsForToday(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error.toString()}"));
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No appointments for today."));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot appointmentDoc = snapshot.data!.docs[index];
            Map<String, dynamic> appointmentData = appointmentDoc.data()! as Map<String, dynamic>;
            String userId = appointmentData['userId'];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('Clients').doc(userId).get(),
              builder: (context, clientSnapshot) {
                if (clientSnapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(title: Text("Loading client details..."));
                }
                if (clientSnapshot.hasError) {
                  return const ListTile(title: Text("Error loading client details."));
                }
                if (!clientSnapshot.hasData || !clientSnapshot.data!.exists) {
                  return const ListTile(title: Text("Client details not found."));
                }

                Map<String, dynamic> clientData = clientSnapshot.data!.data()! as Map<String, dynamic>;
                String userName = clientData['UserName'] ?? 'Unknown User';

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.blue),
                    title: Text("Client: $userName"),
                    subtitle: Text("Date: ${appointmentData['date']} Time: ${appointmentData['time']}"),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMostClients() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fetchMostClients(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error.toString()}"));
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No client data available."));
        }

        Map<String, int> clientCount = {};
        for (var doc in snapshot.data!.docs) {
          String userId = doc['userId'];
          if (clientCount.containsKey(userId)) {
            clientCount[userId] = clientCount[userId]! + 1;
          } else {
            clientCount[userId] = 1;
          }
        }

        var sortedClients = clientCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return ListView.builder(
          shrinkWrap: true,
          itemCount: sortedClients.length,
          itemBuilder: (context, index) {
            var client = sortedClients[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('Clients').doc(client.key).get(),
              builder: (context, clientSnapshot) {
                if (clientSnapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(title: Text("Loading client details..."));
                }
                if (clientSnapshot.hasError) {
                  return const ListTile(title: Text("Error loading client details."));
                }
                if (!clientSnapshot.hasData || !clientSnapshot.data!.exists) {
                  return const ListTile(title: Text("Client details not found."));
                }

                Map<String, dynamic> clientData = clientSnapshot.data!.data()! as Map<String, dynamic>;
                String firstName = clientData['FirstName'] ?? 'Unknown';
                String lastName = clientData['LastName'] ?? 'Client';
                String imageUrl = clientData['ImageUrl'] ?? 'https://via.placeholder.com/150';

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    title: Text("$firstName $lastName"),
                    subtitle: Text("Appointments: ${client.value}"),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatistics() {
    return StreamBuilder<QuerySnapshot>(
      stream: _fetchTotalAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error.toString()}"));
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No appointment data available."));
        }

        int totalAppointments = snapshot.data!.docs.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.assessment, color: Colors.blue),
                title: Text("Total Appointments: $totalAppointments"),
              ),
            ),
            _buildAppointmentList(snapshot.data!.docs),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentList(List<QueryDocumentSnapshot> appointments) {
    Map<String, int> appointmentCountPerDay = {};
    for (var doc in appointments) {
      String date = doc['date'];
      if (appointmentCountPerDay.containsKey(date)) {
        appointmentCountPerDay[date] = appointmentCountPerDay[date]! + 1;
      } else {
        appointmentCountPerDay[date] = 1;
      }
    }

    var sortedDates = appointmentCountPerDay.entries.toList()
      ..sort((a, b) => _parseDate(a.key).compareTo(_parseDate(b.key)));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        var entry = sortedDates[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.date_range, color: Colors.blue),
            title: Text("Date: ${entry.key}"),
            subtitle: Text("Appointments: ${entry.value}"),
          ),
        );
      },
    );
  }

  DateTime _parseDate(String date) {
    try {
      return DateFormat('yyyy-MM-dd').parse(date);
    } catch (e) {
      return DateTime.now(); // Default to now if parsing fails
    }
  }
}

