/// Mirrors the "Client Feedback" sheet from the source workbook.
/// Ratings are 1 (Poor) to 5 (Outstanding) for each criterion.
class ClientFeedback {
  final String id;
  final String company;
  final String name;
  final DateTime date;
  final String time;

  // Service
  final int professionalism;
  // Personnel
  final int skills;
  final int workAttitude;
  final int safety;
  // Vehicle
  final int performance;
  final int cleanliness;
  final int condition;

  final String? comments;

  const ClientFeedback({
    required this.id,
    required this.company,
    required this.name,
    required this.date,
    required this.time,
    required this.professionalism,
    required this.skills,
    required this.workAttitude,
    required this.safety,
    required this.performance,
    required this.cleanliness,
    required this.condition,
    this.comments,
  });

  /// Average rating across all criteria (1.0 – 5.0).
  double get averageRating {
    final total = professionalism +
        skills +
        workAttitude +
        safety +
        performance +
        cleanliness +
        condition;
    return total / 7.0;
  }

  /// Human-readable label for the average rating.
  String get ratingLabel {
    final avg = averageRating;
    if (avg >= 4.5) return 'Outstanding';
    if (avg >= 3.5) return 'Very good';
    if (avg >= 2.5) return 'Satisfactory';
    if (avg >= 1.5) return 'Needs Improvement';
    return 'Poor';
  }
}
