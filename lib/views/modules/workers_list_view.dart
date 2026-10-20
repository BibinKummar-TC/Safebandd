import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/safeband_data.dart';
import 'worker_details_view.dart';

class WorkersListView extends StatefulWidget {
  final Function(String workerName)? onSelectWorker;

  const WorkersListView({super.key, this.onSelectWorker});

  @override
  State<WorkersListView> createState() => _WorkersListViewState();
}

class _WorkersListViewState extends State<WorkersListView> {
  String _selectedFilter = 'All'; // All, Safe, Warning, Danger
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SafeBandWorker> get _filteredWorkers {
    final query = _searchController.text.toLowerCase().trim();

    return SafeBandData.workers.where((worker) {
      final matchesSearch = query.isEmpty ||
          worker.name.toLowerCase().contains(query) ||
          worker.area.toLowerCase().contains(query) ||
          worker.id.toLowerCase().contains(query);

      if (!matchesSearch) return false;

      if (_selectedFilter == 'Safe') {
        return worker.status == WorkerSafetyStatus.safe;
      } else if (_selectedFilter == 'Warning') {
        return worker.status == WorkerSafetyStatus.warning;
      } else if (_selectedFilter == 'Danger') {
        return worker.status == WorkerSafetyStatus.danger;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Workers',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryText,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      '${SafeBandData.workers.length} Plant Workers',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search Bar
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 13, color: AppColors.primaryText),
                  decoration: InputDecoration(
                    hintText: 'Search worker...',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.mutedText),
                    prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.secondaryText),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.secondaryText),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Filter Chips: All, Safe, Warning, Danger
              Row(
                children: [
                  _filterButton('All', AppColors.safetyAccent),
                  const SizedBox(width: 8),
                  _filterButton('Safe', AppColors.safe),
                  const SizedBox(width: 8),
                  _filterButton('Warning', AppColors.warning),
                  const SizedBox(width: 8),
                  _filterButton('Danger', AppColors.danger),
                ],
              ),
              const SizedBox(height: 14),

              // Workers List
              Expanded(
                child: _filteredWorkers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.person_search_rounded, size: 48, color: AppColors.mutedText),
                            SizedBox(height: 12),
                            Text(
                              'No workers match your filter',
                              style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredWorkers.length,
                        itemBuilder: (context, index) {
                          final worker = _filteredWorkers[index];
                          final isDanger = worker.status == WorkerSafetyStatus.danger;
                          final isWarning = worker.status == WorkerSafetyStatus.warning;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: isDanger ? AppColors.surface : AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDanger
                                    ? AppColors.danger
                                    : (isWarning ? AppColors.warning.withValues(alpha: 0.5) : AppColors.border),
                                width: isDanger ? 1.5 : 1.0,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  if (widget.onSelectWorker != null) {
                                    widget.onSelectWorker!(worker.name);
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => WorkerDetailsView(workerName: worker.name),
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  child: Row(
                                    children: [
                                      // Profile Circle
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: worker.statusColor.withValues(alpha: 0.15),
                                          border: Border.all(color: worker.statusColor, width: 1.5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            worker.initials,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              color: worker.statusColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Name & Area
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  worker.name,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.primaryText,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  '(${worker.id})',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.mutedText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              worker.area,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Status Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: worker.statusColor.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: worker.statusColor),
                                        ),
                                        child: Text(
                                          worker.statusText,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.6,
                                            color: worker.statusColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Arrow
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        size: 20,
                                        color: AppColors.secondaryText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButton(String label, Color color) {
    final isSelected = _selectedFilter == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? color : AppColors.border),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : AppColors.secondaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
