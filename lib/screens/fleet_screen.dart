import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_repository.dart';
import '../theme/app_theme.dart';

/// Fleet management screen — split into two tabs: Vehicles and Drivers.
class FleetScreen extends StatelessWidget {
  const FleetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: Colors.white,
            child: TabBar(
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primary,
              tabs: [
                Tab(icon: Icon(Icons.directions_car), text: 'Vehicles'),
                Tab(icon: Icon(Icons.person), text: 'Drivers'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [_VehiclesTab(), _DriversTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehiclesTab extends StatelessWidget {
  const _VehiclesTab();

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<DataRepository>();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: repo.vehicles.length,
          itemBuilder: (_, i) {
            final v = repo.vehicles[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.directions_car,
                          color: AppTheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${v.type} • ${v.plateNumber}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              _miniTag(
                                  Icons.event_busy, 'Coding: ${v.codingDay}'),
                              _miniTag(Icons.local_parking,
                                  'Slot: ${v.parkingSlot}'),
                              _miniTag(Icons.airline_seat_recline_normal,
                                  'Cap: ${v.capacitySeatbelt}/${v.capacityMax}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _miniTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _DriversTab extends StatelessWidget {
  const _DriversTab();

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<DataRepository>();
    final companyDrivers = repo.drivers.where((d) => !d.isSelfDrive).toList();
    final selfDrivers = repo.drivers.where((d) => d.isSelfDrive).toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _sectionHeader('Company Drivers (${companyDrivers.length})'),
            ...companyDrivers.map((d) => _driverTile(d.name, false)),
            const SizedBox(height: 16),
            _sectionHeader('Self-Drive (${selfDrivers.length})'),
            ...selfDrivers.map((d) => _driverTile(d.name, true)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
      );

  Widget _driverTile(String name, bool isSelfDrive) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSelfDrive
              ? AppTheme.warning.withValues(alpha: 0.15)
              : AppTheme.primary.withValues(alpha: 0.15),
          child: Icon(
            Icons.person,
            color: isSelfDrive ? AppTheme.warning : AppTheme.primary,
            size: 20,
          ),
        ),
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(isSelfDrive ? 'Self-Drive' : 'Company Driver',
            style:
                const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ),
    );
  }
}
