import 'package:flutter/material.dart';
import '../models/vehicle_request.dart';
import '../theme/app_theme.dart';

/// Small colored chip used for billing type and VR status throughout the app.
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  /// Convenience constructor for a billing type tag.
  factory StatusBadge.billing(BillingType type) {
    Color color;
    switch (type) {
      case BillingType.billable:
        color = AppTheme.success;
        break;
      case BillingType.unbillable:
        color = AppTheme.danger;
        break;
      case BillingType.complimentary:
        color = AppTheme.warning;
        break;
    }
    return StatusBadge(label: type.label, color: color);
  }

  /// Convenience constructor for a VR status tag.
  factory StatusBadge.status(VRStatus status) {
    return StatusBadge(label: status.label, color: status.color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
