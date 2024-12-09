import 'dart:math';

class MockDataService {
  static final Random _random = Random();

  static int getTotalUsers() => _random.nextInt(10000) + 1000;
  static int getTotalServicesBooked() => _random.nextInt(5000) + 500;
  static int getHealthAlerts() => _random.nextInt(100) + 10;
  static int getActiveLocations() => _random.nextInt(500) + 50;

  static List<Map<String, dynamic>> getLatestUpdates() {
    return List.generate(
        5,
        (index) => {
              'title': 'Update ${index + 1}',
              'description':
                  'This is a brief description of update ${index + 1}.',
              'date': DateTime.now().subtract(Duration(days: index)),
            });
  }

  static Map<String, int> getUserTypeBreakdown() {
    return {
      'Caregivers': _random.nextInt(1000) + 100,
      'Elderly Users': _random.nextInt(5000) + 500,
      'Family Members': _random.nextInt(3000) + 300,
      'Emergency Contacts': _random.nextInt(2000) + 200,
    };
  }
}
