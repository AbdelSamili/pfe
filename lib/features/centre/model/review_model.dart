class ReviewModel {
  final String id;
  final String description;
  final int stars;
  final String centerId;
  final String clientId;
  final String clientName;
  final String clientImage;

  ReviewModel({
    required this.id,
    required this.description,
    required this.stars,
    required this.centerId,
    required this.clientId,
    required this.clientName,
    required this.clientImage,
  });

  factory ReviewModel.fromDocument(Map<String, dynamic> doc) {
    return ReviewModel(
      id: doc['id'],
      description: doc['description'],
      stars: doc['stars'],
      centerId: doc['centerId'],
      clientId: doc['clientId'],
      clientName: doc['clientName'],
      clientImage: doc['clientImage'],
    );
  }
}
