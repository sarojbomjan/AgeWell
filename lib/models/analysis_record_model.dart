class MedicalAnalysis {
  String? id;
  String userId; // ID of the user who owns the analysis
  String testDate;
  String fastingLevels;
  String ogtt;
  String hba1c;
  String uricAcid;
  String bloodSugar;
  String cholesterol;

  MedicalAnalysis({
    this.id,
    required this.userId,
    required this.testDate,
    required this.fastingLevels,
    required this.ogtt,
    required this.hba1c,
    required this.uricAcid,
    required this.bloodSugar,
    required this.cholesterol,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'testDate': testDate,
      'fastingLevels': fastingLevels,
      'ogtt': ogtt,
      'hba1c': hba1c,
      'uricAcid': uricAcid,
      'bloodSugar': bloodSugar,
      'cholesterol': cholesterol,
    };
  }

  factory MedicalAnalysis.fromMap(Map<String, dynamic> map, String documentId) {
    return MedicalAnalysis(
      id: documentId,
      userId: map['userId'] ?? '',
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
