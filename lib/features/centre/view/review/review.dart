import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  final String centerId;

  const ReviewsPage({super.key, required this.centerId});

  Future<List<Map<String, dynamic>>> _fetchReviews() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Reviews')
        .where('centerId', isEqualTo: centerId)
        .get();

    List<Map<String, dynamic>> reviews = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Clients')
          .doc(data['userId'])
          .get();
      data['userName'] = userDoc['UserName'];
      data['userImage'] = userDoc['ImageUrl']; // Assuming user profile image URL is stored here
      reviews.add(data);
    }
    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reviews found."));
          }

          List<Map<String, dynamic>> reviews = snapshot.data!;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> review = reviews[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(review['userImage'] ?? 'https://via.placeholder.com/150'),
                            radius: 25,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review['userName'] ?? 'Unknown User',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < review['stars'] ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(review['description']),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
