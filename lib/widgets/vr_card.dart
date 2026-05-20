import 'package:flutter/material.dart';
import '../models/vehicle_request.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'status_badge.dart';

/// Compact card representing a single Vehicle Request in list views.
/// Tapping triggers [onTap] (typically navigation to the detail screen).
class VRCard extends StatelessWidget {
  final VehicleRequest vr;
  final VoidCallback? onTap;

  const VRCard({super.key, required this.vr, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row: VR# + status badges
              Row(
                children: [
                  Text(
                    'VR #${vr.vrNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusBadge.status(vr.status),
                  const Spacer(),
                  StatusBadge.billing(vr.billingType),
                ],
              ),
              const SizedBox(height: 8),

              // Vehicle + driver line
              Row(
                children: [
                  const Icon(Icons.directions_car,
                      size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${vr.vehicleType} • ${vr.plateNumber}',
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person,
                      size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      vr.driverName,
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      vr.itinerary.split('\n').first,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Footer row: date + time + client
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 12, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${Formatters.shortDate(vr.date)} • ${Formatters.time(vr.time)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      vr.clientName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
