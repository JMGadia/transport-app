import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_repository.dart';
import '../models/vehicle_request.dart';
import '../theme/app_theme.dart';
import '../widgets/app_route.dart';
import '../widgets/vr_card.dart';
import 'vr_detail_screen.dart';
import 'create_vr_screen.dart';

/// List of all Vehicle Requests with filter chips (status + billing).
///
/// On desktop the "New VR" action is a top-right button; on mobile it's a FAB.
/// On desktop, tapping a VR opens it in a centered modal dialog; on mobile,
/// it pushes a full page.
class VRListScreen extends StatefulWidget {
  const VRListScreen({super.key});

  @override
  State<VRListScreen> createState() => _VRListScreenState();
}

class _VRListScreenState extends State<VRListScreen> {
  VRStatus? _statusFilter;
  BillingType? _billingFilter;
  String _searchQuery = '';

  void _openDetail(VehicleRequest vr) {
    // AppRoute picks modal-on-desktop / full-page-on-mobile automatically.
    AppRoute.show(
      context,
      title: 'VR #${vr.vrNumber}',
      maxWidth: 720,
      child: VRDetailScreen(vrNumber: vr.vrNumber, embedded: true),
    );
  }

  void _openCreate() {
    AppRoute.show(
      context,
      title: 'New Vehicle Request',
      maxWidth: 640,
      child: const CreateVRScreen(embedded: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<DataRepository>();
    final isMobile = MediaQuery.of(context).size.width < 700;

    // Apply filters
    Iterable<VehicleRequest> filtered = repo.allRequests;
    if (_statusFilter != null) {
      filtered = filtered.where((vr) => vr.status == _statusFilter);
    }
    if (_billingFilter != null) {
      filtered = filtered.where((vr) => vr.billingType == _billingFilter);
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((vr) =>
          vr.vrNumber.toLowerCase().contains(q) ||
          vr.clientName.toLowerCase().contains(q) ||
          vr.driverName.toLowerCase().contains(q) ||
          vr.plateNumber.toLowerCase().contains(q));
    }
    final list = filtered.toList();

    return Scaffold(
      body: Center(
        // Cap the list width on big monitors so cards don't stretch awkwardly.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              // --- Top toolbar (search + new button on desktop) ---
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText:
                              'Search by VR#, client, driver, or plate...',
                          prefixIcon: Icon(Icons.search, size: 20),
                          isDense: true,
                        ),
                        onChanged: (v) => setState(() => _searchQuery = v),
                      ),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _openCreate,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('New VR'),
                      ),
                    ],
                  ],
                ),
              ),

              // --- Filter chips ---
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _filterChip(
                      label: 'All Status',
                      selected: _statusFilter == null,
                      onTap: () => setState(() => _statusFilter = null),
                    ),
                    ...VRStatus.values.map(
                      (s) => _filterChip(
                        label: s.label,
                        selected: _statusFilter == s,
                        color: s.color,
                        onTap: () => setState(() => _statusFilter = s),
                      ),
                    ),
                    const VerticalDivider(width: 16),
                    _filterChip(
                      label: 'All Billing',
                      selected: _billingFilter == null,
                      onTap: () => setState(() => _billingFilter = null),
                    ),
                    ...BillingType.values.map(
                      (b) => _filterChip(
                        label: b.label,
                        selected: _billingFilter == b,
                        onTap: () => setState(() => _billingFilter = b),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // --- VR list ---
              Expanded(
                child: list.isEmpty
                    ? const Center(
                        child: Text(
                          'No vehicle requests match your filters.',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: list.length,
                        itemBuilder: (_, i) => VRCard(
                          vr: list[i],
                          onTap: () => _openDetail(list[i]),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      // FAB only on mobile — on desktop the New VR button lives in the toolbar.
      floatingActionButton: isMobile
          ? FloatingActionButton.extended(
              onPressed: _openCreate,
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('New VR'),
            )
          : null,
    );
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final activeColor = color ?? AppTheme.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: activeColor.withValues(alpha: 0.15),
        labelStyle: TextStyle(
          color: selected ? activeColor : AppTheme.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected ? activeColor : AppTheme.border,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
