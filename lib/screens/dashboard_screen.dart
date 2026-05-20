import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_repository.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/app_route.dart';
import '../widgets/kpi_tile.dart';
import '../widgets/vr_card.dart';
import 'vr_detail_screen.dart';

/// Dashboard / home screen.
/// Shows monthly KPIs from the SUMMARY sheet plus a list of the latest VRs.
///
/// [onSeeAllRequests] is invoked when the user taps "See all" — the parent
/// shell wires it to switch to the VR list tab.
class DashboardScreen extends StatelessWidget {
  final VoidCallback? onSeeAllRequests;
  const DashboardScreen({super.key, this.onSeeAllRequests});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<DataRepository>();
    final recentVRs = repo.allRequests.take(5).toList();
    final width = MediaQuery.of(context).size.width;

    // Responsive: 4 KPI tiles per row on desktop, 2 on mobile.
    final kpiColumns = width >= 1100 ? 4 : 2;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          // Cap content width on huge monitors so lines stay readable.
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Monthly sales progress card ---
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Sales',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            Formatters.currency(repo.monthlySales),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '/ ${Formatters.compactCurrency(repo.monthlyGoal)} goal',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: repo.progressPercent.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: AppTheme.border,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.primary),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${Formatters.percent(repo.progressPercent)} of monthly goal reached',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --- KPI grid (4 cols desktop, 2 cols mobile) ---
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: kpiColumns,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.45,
                children: [
                  KpiTile(
                    label: 'Total Trips',
                    value: repo.totalTrips.toString(),
                    icon: Icons.route,
                    color: AppTheme.primary,
                    subtitle: 'this period',
                  ),
                  KpiTile(
                    label: 'Billable',
                    value: repo.billableCount.toString(),
                    icon: Icons.attach_money,
                    color: AppTheme.success,
                    subtitle: 'revenue-earning',
                  ),
                  KpiTile(
                    label: 'Unbillable',
                    value: repo.unbillableCount.toString(),
                    icon: Icons.money_off,
                    color: AppTheme.danger,
                    subtitle: 'internal trips',
                  ),
                  KpiTile(
                    label: 'Complimentary',
                    value: repo.complimentaryCount.toString(),
                    icon: Icons.card_giftcard,
                    color: AppTheme.warning,
                    subtitle: 'no charge',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Recent VRs section ---
              Row(
                children: [
                  const Text(
                    'Recent Vehicle Requests',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onSeeAllRequests,
                    child: const Text('See all'),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ...recentVRs.map(
                (vr) => VRCard(
                  vr: vr,
                  onTap: () => AppRoute.show(
                    context,
                    title: 'VR #${vr.vrNumber}',
                    maxWidth: 720,
                    child: VRDetailScreen(
                      vrNumber: vr.vrNumber,
                      embedded: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
