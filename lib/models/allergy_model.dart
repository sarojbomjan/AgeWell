class Allergy {
  String? id;
  final String name;
  final String symptoms;
  final String date;
  final String userId;

  Allergy({
    this.id,
    required this.name,
    required this.symptoms,
    required this.date,
    required this.userId,
  });

  // Convert Firestore document to Allergy model
  factory Allergy.fromFirestore(String id, Map<String, dynamic> data) {
    return Allergy(
      id: id,
      name: data['name'] ?? '',
      symptoms: data['symptoms'] ?? '',
      date: data['date'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  // Convert Allergy model to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'symptoms': symptoms,
      'date': date,
      'userId': userId,
    };
  }
}
