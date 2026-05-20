import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_repository.dart';
import '../models/client_feedback.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Displays client feedback / ratings. Mirrors the "Client Feedback" sheet.
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<DataRepository>();
    final feedbackList = repo.feedback;

    // Compute overall average across all feedback
    final overallAvg = feedbackList.isEmpty
        ? 0.0
        : feedbackList.map((f) => f.averageRating).reduce((a, b) => a + b) /
            feedbackList.length;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- Overall stats card ---
            Card(
              color: AppTheme.primary,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          overallAvg.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < overallAvg.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${feedbackList.length} responses',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.thumb_up,
                          color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Recent Feedback',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 10),

            // --- Individual feedback cards ---
            ...feedbackList.map((fb) => _FeedbackCard(feedback: fb)),
          ],
        ),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final ClientFeedback feedback;
  const _FeedbackCard({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: name + rating
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                  child: Text(
                    feedback.name.substring(0, 1),
                    style: const TextStyle(
                        color: AppTheme.primary, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(feedback.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 14)),
                      Text(feedback.company,
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < feedback.averageRating.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        ),
                      ),
                    ),
                    Text(
                      feedback.ratingLabel,
                      style: const TextStyle(
                          fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Detailed ratings
            _ratingRow('Professionalism', feedback.professionalism),
            _ratingRow('Skills', feedback.skills),
            _ratingRow('Work Attitude', feedback.workAttitude),
            _ratingRow('Safety', feedback.safety),
            _ratingRow('Vehicle Performance', feedback.performance),
            _ratingRow('Cleanliness', feedback.cleanliness),
            _ratingRow('Condition', feedback.condition),

            if (feedback.comments != null && feedback.comments!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"${feedback.comments}"',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),
            Text(
              '${Formatters.date(feedback.date)} • ${feedback.time}',
              style:
                  const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ratingRow(String label, int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style:
                  const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ),
          Expanded(
            child: Row(
              children: List.generate(
                5,
                (i) => Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Icon(
                    i < score ? Icons.circle : Icons.circle_outlined,
                    size: 10,
                    color: i < score ? AppTheme.success : AppTheme.border,
                  ),
                ),
              ),
            ),
          ),
          Text(
            '$score/5',
            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
