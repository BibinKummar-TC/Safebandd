import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../modules/supervisor_dashboard_view.dart';
import '../modules/live_map_view.dart';
import '../modules/alerts_view.dart';
import '../modules/workers_list_view.dart';
import '../modules/more_view.dart';
import '../modules/worker_details_view.dart';
import '../modules/profile_view.dart';

class AppShell extends StatefulWidget {
  final int initialTab;
  final String? focusedWorker;

  const AppShell({
    super.key,
    this.initialTab = 0,
    this.focusedWorker,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _selectedIndex;
  String? _workerToFocus;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
    _workerToFocus = widget.focusedWorker;
  }

  void _onSelectWorker(String name) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WorkerDetailsView(workerName: name)),
    );
  }

  void _navigateToTab(int index, [String? worker]) {
    setState(() {
      _selectedIndex = index;
      if (worker != null) {
        _workerToFocus = worker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    // 5 Main Navigation Tabs as requested by prompt:
    // Home, Map, Alerts, Workers, More
    final List<_NavigationTabItem> tabs = [
      _NavigationTabItem(
        title: 'Home',
        icon: Icons.grid_view_rounded,
        screen: SupervisorDashboardView(
          onNavigateTab: (idx) => _navigateToTab(idx),
          onSelectWorker: _onSelectWorker,
        ),
      ),
      _NavigationTabItem(
        title: 'Map',
        icon: Icons.map_outlined,
        screen: LiveMapView(
          onSelectWorker: _onSelectWorker,
          initialWorkerName: _workerToFocus ?? 'Suresh',
        ),
      ),
      _NavigationTabItem(
        title: 'Alerts',
        icon: Icons.notifications_none_rounded,
        screen: AlertsView(
          onNavigateTab: (idx) => _navigateToTab(idx),
        ),
        hasBadge: true,
      ),
      _NavigationTabItem(
        title: 'Workers',
        icon: Icons.people_outline_rounded,
        screen: WorkersListView(
          onSelectWorker: _onSelectWorker,
        ),
      ),
      _NavigationTabItem(
        title: 'More',
        icon: Icons.more_horiz_rounded,
        screen: const MoreView(),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.safetyAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.shield_rounded, color: AppColors.background, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'SafeBand',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  'Chemical Industry Plant',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.safetyAccent,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Notification Bell
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primaryText, size: 22),
                tooltip: 'Alert Center',
                onPressed: () => _navigateToTab(2),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.danger,
                  ),
                ),
              ),
            ],
          ),

          // Supervisor Avatar Button
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileView()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.safetyAccent, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.cardBackground,
                child: Text(
                  auth.currentProfile?.fullName.isNotEmpty == true
                      ? auth.currentProfile!.fullName[0].toUpperCase()
                      : 'S',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.safetyAccent),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          if (isDesktop) _buildDesktopRail(tabs),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: tabs.map((t) => t.screen).toList(),
            ),
          ),
        ],
      ),
      // Mobile Bottom Navigation
      bottomNavigationBar: !isDesktop
          ? Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border, width: 1.0)),
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (idx) => _navigateToTab(idx),
                backgroundColor: AppColors.surface,
                selectedItemColor: AppColors.safetyAccent, // Yellow/gold accent
                unselectedItemColor: AppColors.secondaryText,
                selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                type: BottomNavigationBarType.fixed,
                items: tabs.map((tab) {
                  return BottomNavigationBarItem(
                    icon: tab.hasBadge
                        ? Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(tab.icon),
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.danger,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Icon(tab.icon),
                    label: tab.title,
                  );
                }).toList(),
              ),
            )
          : null,
    );
  }

  Widget _buildDesktopRail(List<_NavigationTabItem> tabs) {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: ListView.builder(
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final t = tabs[index];
          final isSelected = _selectedIndex == index;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.cardBackground : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected ? Border.all(color: AppColors.border) : null,
            ),
            child: ListTile(
              dense: true,
              leading: Icon(
                t.icon,
                color: isSelected ? AppColors.safetyAccent : AppColors.secondaryText,
              ),
              title: Text(
                t.title,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryText : AppColors.secondaryText,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              onTap: () => _navigateToTab(index),
            ),
          );
        },
      ),
    );
  }
}

class _NavigationTabItem {
  final String title;
  final IconData icon;
  final Widget screen;
  final bool hasBadge;

  _NavigationTabItem({
    required this.title,
    required this.icon,
    required this.screen,
    this.hasBadge = false,
  });
}
