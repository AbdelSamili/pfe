import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pfe_1/common/widgets/appbar/appbar.dart';
import 'package:pfe_1/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:pfe_1/features/appointment/controller/appointment_controller.dart';
import 'package:pfe_1/features/centre/controller/center_controller.dart';
import 'package:pfe_1/features/centre/model/center_model.dart';
import 'package:pfe_1/features/centre/view/components/centre_card.dart';
import 'package:pfe_1/utils/Config.dart';
import 'package:get/get.dart';

class HomeClientScreen extends StatefulWidget {
  const HomeClientScreen({super.key});

  @override
  State<HomeClientScreen> createState() => _HomeClientScreenState();
}

class _HomeClientScreenState extends State<HomeClientScreen> {
  Map<String, dynamic> user = {};
  List<CenterModel> centre = [];
  List<dynamic> favList = [];
  bool isLoading = true;
  List<dynamic> schedules = [];
  List<dynamic> appointmentToday = [];
  final controller = Get.put(CenterController());
  final appointmentController = Get.put(AppointmentController());

  @override
  void initState() {
    super.initState();
    getAppointments();
    fetchCenters(); // Call method to fetch centers when the page initializes
  }

  Future<void> getAppointments() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("Current user ID: ${user.uid}");

        List<Map<String, dynamic>> appointments = await appointmentController
            .getAppointmentsForUserWithCentreDetails(user.uid);
        print("Fetched appointments: $appointments");

        String dateToday = DateFormat('yyyy-MM-dd').format(DateTime.now());
        print("Today's date: $dateToday");

        for (var i = 0; i < appointments.length; i++) {
          print("Appointment date: ${appointments[i]['date']}");
          if (appointments[i]['date'] == dateToday) {
            appointmentToday.add(appointments[i]);
          }
        }

        setState(() {
          schedules = appointmentToday;
          isLoading = false;
          print("Appointments today: $schedules");
        });
      } else {
        print('User is not currently signed in.');
      }
    } catch (e) {
      print('Error fetching appointments: $e');
    }
  }

  Future<Map<String, double>> fetchCenterRatings() async {
    try {
      QuerySnapshot reviewsSnapshot = await FirebaseFirestore.instance.collection('Reviews').get();

      Map<String, List<int>> ratingsMap = {};

      for (var doc in reviewsSnapshot.docs) {
        Map<String, dynamic> reviewData = doc.data() as Map<String, dynamic>;
        String centerId = reviewData['centerId'];
        int stars = reviewData['stars'];

        if (ratingsMap.containsKey(centerId)) {
          ratingsMap[centerId]![0] += stars;
          ratingsMap[centerId]![1] += 1;
        } else {
          ratingsMap[centerId] = [stars, 1];
        }
      }

      Map<String, double> averageRatings = {};
      ratingsMap.forEach((centerId, values) {
        averageRatings[centerId] = values[0] / values[1];
      });

      return averageRatings;
    } catch (e) {
      print('Error fetching reviews: $e');
      return {};
    }
  }

  Future<void> fetchCenters() async {
    try {
      Map<String, double> centerRatings = await fetchCenterRatings();

      QuerySnapshot centersSnapshot = await FirebaseFirestore.instance.collection('Centers').get();

      List<CenterModel> fetchedCenters = [];

      for (var doc in centersSnapshot.docs) {
        Map<String, dynamic> centerData = doc.data() as Map<String, dynamic>;
        String centerId = doc.id;
        double averageRating = centerRatings[centerId] ?? 0.0;

        CenterModel center = CenterModel(
          id: centerId,
          centerName: centerData['CenterName'] ?? '',
          profileImage: centerData['ImageUrl'] ?? '',
          matricule: centerData['Matricule'] ?? '',
          rating: averageRating,
          email: centerData['Email'] ?? '',
          phoneNumber: centerData['Phone'] ?? '',
          password: centerData['Password'] ?? '',
          description: centerData['Description'] ?? '',
          creationDate: centerData['CreationDate'] ?? '',
        );

        fetchedCenters.add(center);
      }

      fetchedCenters.sort((a, b) => b.rating.compareTo(a.rating));

      setState(() {
        centre = fetchedCenters;
        isLoading = false;
      });

      print("Fetched centers: $centre");
    } catch (e) {
      print('Error fetching centers: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    Config.init(context);

    return Scaffold(
      body: user.isNotEmpty
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppPrimaryHeaderContainer(
                child: Column(
                  children: [
                    CAppBar(
                      title: Column(
                        children: [],
                      ),
                    ),
                  ],
                ),
              ),
              Config.spaceMedium,
              const Text(
                'Appointment Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
              schedules.isNotEmpty
                  ? Column(
                children: [
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: schedules.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final app = schedules[index];
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('Centers').doc(app['centreId']).get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text("Error: ${snapshot.error.toString()}"));
                          }
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Center(child: Text("Center details not found."));
                          }

                          Map<String, dynamic> centerData = snapshot.data!.data()! as Map<String, dynamic>;

                          String centerName = centerData['CenterName'] ?? 'Unknown Center';
                          String imageUrl = centerData['ImageUrl'] ?? 'assets/images/users-icon.jpg';

                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(imageUrl),
                              ),
                              title: Text(centerName),
                              subtitle: Text("Date: ${app['date']} Time: ${app['time']}"),
                              onTap: () {
                                // Optional: Add action on tap
                              },
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              )
                  : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No Appointment Today',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Config.spaceSmall,
              const Text(
                'Top Centre',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                children: List.generate(centre.length, (index) {
                  return CentreCard(
                    centre: centre[index],
                    isFav: true,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
