import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_repository.dart';
import '../models/vehicle_request.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/app_toast.dart';
import '../widgets/status_badge.dart';

/// Full-detail view of a single Vehicle Request.
/// Mirrors the layout of the per-VR sheets in the source workbook.
///
/// When [embedded] is true, the screen is rendered without its own Scaffold/
/// AppBar — the parent (e.g. AppRoute's modal dialog) provides those.
class VRDetailScreen extends StatelessWidget {
  final String vrNumber;
  final bool embedded;
  const VRDetailScreen({
    super.key,
    required this.vrNumber,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<DataRepository>();
    final vr = repo.findRequest(vrNumber);

    if (vr == null) {
      const notFound = Center(child: Text('VR not found.'));
      return embedded
          ? notFound
          : Scaffold(
              appBar: AppBar(title: const Text('Vehicle Request')),
              body: notFound,
            );
    }

    // Action button shown in the top-right — used in both embedded & full-page modes.
    final statusMenu = PopupMenuButton<VRStatus>(
      icon: const Icon(Icons.more_vert),
      tooltip: 'Update status',
      onSelected: (newStatus) async {
        // BACKEND: PUT /api/vehicle-requests/{vrNumber}/status
        await repo.updateRequestStatus(vr.vrNumber, newStatus);
        if (context.mounted) {
          AppToast.show(context, 'Status set to ${newStatus.label}',
              kind: ToastKind.success);
        }
      },
      itemBuilder: (_) => VRStatus.values
          .map((s) => PopupMenuItem(
                value: s,
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: s.color),
                    const SizedBox(width: 8),
                    Text(s.label),
                  ],
                ),
              ))
          .toList(),
    );

    final body = ListView(
      padding: const EdgeInsets.all(16),
      shrinkWrap: embedded,
      children: [
        // --- Status + billing header ---
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatusBadge.status(vr.status),
            StatusBadge.billing(vr.billingType),
          ],
        ),
        const SizedBox(height: 16),

        // --- Trip summary card ---
        _SectionCard(
          title: 'Trip Information',
          icon: Icons.assignment,
          children: [
            _InfoRow(label: 'VR Number', value: vr.vrNumber),
            _InfoRow(label: 'Date', value: Formatters.date(vr.date)),
            _InfoRow(label: 'Time Required', value: Formatters.time(vr.time)),
            _InfoRow(label: 'Requested By', value: vr.requestedBy),
            _InfoRow(label: 'Department', value: vr.department),
          ],
        ),

        // --- Vehicle & Driver ---
        _SectionCard(
          title: 'Vehicle & Driver',
          icon: Icons.directions_car,
          children: [
            _InfoRow(label: 'Vehicle', value: vr.vehicleType),
            _InfoRow(label: 'Plate Number', value: vr.plateNumber),
            _InfoRow(label: 'Driver', value: vr.driverName),
          ],
        ),

        // --- Passengers ---
        _SectionCard(
          title: 'Passengers (${vr.passengerCount})',
          icon: Icons.people,
          children: [
            if (vr.passengers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'No passenger list (cargo/equipment).',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              )
            else
              ...vr.passengers.map(
                (p) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline,
                          size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(child: Text(p)),
                    ],
                  ),
                ),
              ),
          ],
        ),

        // --- Itinerary ---
        _SectionCard(
          title: 'Itinerary',
          icon: Icons.map,
          children: [
            Text(
              vr.itinerary,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
            ),
          ],
        ),

        // --- Billing ---
        _SectionCard(
          title: 'Billing',
          icon: Icons.receipt_long,
          children: [
            _InfoRow(label: 'Client', value: vr.clientName),
            if (vr.billingReference != null)
              _InfoRow(label: 'Billing Reference', value: vr.billingReference!),
            _InfoRow(label: 'Type', value: vr.billingType.label),
            if (vr.rateAmount != null)
              _InfoRow(
                label: 'Rate',
                value: Formatters.currency(vr.rateAmount!),
                emphasize: true,
              ),
          ],
        ),

        // --- Trip log (only shown if data exists) ---
        if (vr.kilometrageOut != null ||
            vr.tollFees != null ||
            vr.fuelAmount != null ||
            vr.arrivalTime != null)
          _SectionCard(
            title: 'Trip Log',
            icon: Icons.history,
            children: [
              if (vr.departureTime != null)
                _InfoRow(
                    label: 'Departure',
                    value: Formatters.time(vr.departureTime!)),
              if (vr.arrivalTime != null)
                _InfoRow(
                    label: 'Arrival', value: Formatters.time(vr.arrivalTime!)),
              if (vr.kilometrageOut != null)
                _InfoRow(
                    label: 'KM Out',
                    value: vr.kilometrageOut!.toStringAsFixed(1)),
              if (vr.kilometrageIn != null)
                _InfoRow(
                    label: 'KM In',
                    value: vr.kilometrageIn!.toStringAsFixed(1)),
              if (vr.distanceTravelled != null)
                _InfoRow(
                    label: 'Distance',
                    value: '${vr.distanceTravelled!.toStringAsFixed(1)} km'),
              if (vr.tollFees != null)
                _InfoRow(
                    label: 'Toll Fees',
                    value: Formatters.currency(vr.tollFees!)),
              if (vr.parkingFees != null)
                _InfoRow(
                    label: 'Parking Fees',
                    value: Formatters.currency(vr.parkingFees!)),
              if (vr.fuelAmount != null)
                _InfoRow(
                    label: 'Fuel', value: Formatters.currency(vr.fuelAmount!)),
              _InfoRow(
                label: 'Total Expenses',
                value: Formatters.currency(vr.totalExpenses),
                emphasize: true,
              ),
            ],
          ),
      ],
    );

    // Embedded mode (e.g. inside an AppRoute dialog on desktop) — render
    // without our own Scaffold/AppBar. The status menu floats top-right.
    if (embedded) {
      return Stack(
        children: [
          body,
          Positioned(top: 4, right: 4, child: statusMenu),
        ],
      );
    }

    // Full-page mode (mobile, or if pushed directly via Navigator.push).
    return Scaffold(
      appBar: AppBar(
        title: Text('VR #${vr.vrNumber}'),
        actions: [statusMenu],
      ),
      body: body,
    );
  }
}

/// Section container used inside the detail screen.
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppTheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasize;

  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: emphasize ? AppTheme.primary : AppTheme.textPrimary,
                fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
