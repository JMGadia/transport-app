import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_toast.dart';
import 'dashboard_screen.dart';
import 'vr_list_screen.dart';
import 'fleet_screen.dart';
import 'feedback_screen.dart';

/// Top-level shell that hosts navigation and switches between the four main
/// sections of the app. The layout automatically adapts:
///
///   < 700 px   → mobile     : bottom navigation bar
///   700–1099px → tablet     : collapsed icon-only side rail
///   ≥ 1100 px  → desktop    : full sidebar with labels (DEFAULT)
///
/// Tune the breakpoint constants below to taste.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  // Breakpoints — adjust here to change responsive behavior across the app.
  static const double _mobileMaxWidth = 700;
  static const double _tabletMaxWidth = 1100;

  static const _titles = [
    'Dashboard',
    'Vehicle Requests',
    'Fleet',
    'Client Feedback',
  ];

  // Each destination's icon set + label, used by all three layouts.
  static const _destinations = [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
    _NavItem(Icons.assignment_outlined, Icons.assignment, 'Requests'),
    _NavItem(Icons.directions_car_outlined, Icons.directions_car, 'Fleet'),
    _NavItem(Icons.star_outline, Icons.star, 'Feedback'),
  ];

  // Each screen is built fresh on switch — cheap because they read from Provider.
  Widget _screenFor(int i) {
    switch (i) {
      case 0:
        return DashboardScreen(
          onSeeAllRequests: () => setState(() => _index = 1),
        );
      case 1:
        return const VRListScreen();
      case 2:
        return const FleetScreen();
      case 3:
        return const FeedbackScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= _tabletMaxWidth) {
      return _buildDesktopLayout();
    } else if (width >= _mobileMaxWidth) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  // ===========================================================================
  // DESKTOP LAYOUT — full sidebar with labels (default for browser users)
  // ===========================================================================
  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 240,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: AppTheme.border)),
            ),
            child: Column(
              children: [
                // Brand header
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.local_shipping,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transport',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              'Schedule System',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                const SizedBox(height: 8),

                // Nav items
                ...List.generate(_destinations.length, (i) {
                  final item = _destinations[i];
                  final selected = i == _index;
                  return _SidebarItem(
                    icon: selected ? item.selectedIcon : item.icon,
                    label: item.label,
                    selected: selected,
                    onTap: () => setState(() => _index = i),
                  );
                }),

                const Spacer(),

                // Footer (could become a user profile / settings button later)
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppTheme.border)),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTheme.primary,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin User',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'admin@transport.ph',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // BACKEND: hook a real logout / settings menu here.
                      IconButton(
                        icon: const Icon(Icons.logout, size: 18),
                        tooltip: 'Sign out',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Column(
              children: [
                _ContentAppBar(title: _titles[_index]),
                Expanded(child: _screenFor(_index)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TABLET LAYOUT — collapsed icon-only side rail
  // ===========================================================================
  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Colors.white,
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            labelType: NavigationRailLabelType.all,
            selectedIconTheme: const IconThemeData(color: AppTheme.primary),
            selectedLabelTextStyle: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
            unselectedLabelTextStyle: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_shipping,
                    color: Colors.white, size: 20),
              ),
            ),
            destinations: _destinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1, color: AppTheme.border),
          Expanded(
            child: Column(
              children: [
                _ContentAppBar(title: _titles[_index]),
                Expanded(child: _screenFor(_index)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MOBILE LAYOUT — bottom navigation bar
  // ===========================================================================
  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
            onPressed: () => AppToast.show(context, 'No new notifications'),
          ),
        ],
      ),
      body: _screenFor(_index),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        indicatorColor: AppTheme.primary.withValues(alpha: 0.12),
        destinations: _destinations
            .map(
              (d) => NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Plain data class so the same destination definitions feed all three layouts.
class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _NavItem(this.icon, this.selectedIcon, this.label);
}

/// Custom sidebar list item (used in desktop layout).
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTheme.primary : AppTheme.textSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: selected
            ? AppTheme.primary.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Top app-bar style header used on the content panel in desktop/tablet
/// layouts (instead of the global Scaffold AppBar that mobile uses).
class _ContentAppBar extends StatelessWidget {
  final String title;
  const _ContentAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.textSecondary),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppTheme.textSecondary),
            tooltip: 'Notifications',
            onPressed: () => AppToast.show(context, 'No new notifications'),
          ),
        ],
      ),
    );
  }
}
