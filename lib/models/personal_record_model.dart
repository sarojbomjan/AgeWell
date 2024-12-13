class PersonalRecord {
  String gender;
  double age;
  double weight;
  double height;
  String bloodType;

  PersonalRecord({
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.bloodType,
  });

  // Convert the model to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
      'bloodType': bloodType,
    };
  }

  // Factory method to create an instance from a Firestore document
  factory PersonalRecord.fromMap(Map<String, dynamic> map) {
    return PersonalRecord(
      gender: map['gender'],
      age: map['age'],
      weight: map['weight'],
      height: map['height'],
      bloodType: map['bloodType'],
    );
  }
}
