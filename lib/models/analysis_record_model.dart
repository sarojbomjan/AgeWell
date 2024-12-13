class MedicalAnalysis {
  String testDate;
  String fastingLevels;
  String ogtt;
  String hba1c;
  String uricAcid;
  String bloodSugar;
  String cholesterol;

  MedicalAnalysis({
    required this.testDate,
    required this.fastingLevels,
    required this.ogtt,
    required this.hba1c,
    required this.uricAcid,
    required this.bloodSugar,
    required this.cholesterol,
  });

  // Convert to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'testDate': testDate,
      'fastingLevels': fastingLevels,
      'ogtt': ogtt,
      'hba1c': hba1c,
      'uricAcid': uricAcid,
      'bloodSugar': bloodSugar,
      'cholesterol': cholesterol,
    };
  }

  // Create a model from Firestore data
  factory MedicalAnalysis.fromMap(Map<String, dynamic> map, String documentId) {
    return MedicalAnalysis(
      testDate: map['testDate'] ?? '',
      fastingLevels: map['fastingLevels'] ?? '',
      ogtt: map['ogtt'] ?? '',
      hba1c: map['hba1c'] ?? '',
      uricAcid: map['uricAcid'] ?? '',
      bloodSugar: map['bloodSugar'] ?? '',
      cholesterol: map['cholesterol'] ?? '',
    );
  }
}
