import 'package:flutter/material.dart';
import '../../config/constants.dart';

class PlantAreasView extends StatelessWidget {
  const PlantAreasView({super.key});

  @override
  Widget build(BuildContext context) {
    // Exact plant areas requested by prompt:
    // Area A – Reactor Unit
    // Area B – Storage Unit
    // Area C – Distillation
    // Area D – Utility
    // Area E – Packing Unit
    // Tank Farm
    final areas = [
      {
        'name': 'Area A – Reactor Unit',
        'type': 'Catalytic High-Pressure Vessels',
        'workers': '2 Workers (Ravi, Rajesh)',
        'status': 'SAFE',
        'color': AppColors.safe,
        'icon': Icons.precision_manufacturing_rounded,
        'hazard': 'Class 1 Pressurized Systems',
      },
      {
        'name': 'Area B – Storage Unit',
        'type': 'Raw Materials & Chemical Inventory',
        'workers': '1 Worker (Karthik)',
        'status': 'WARNING',
        'color': AppColors.warning,
        'icon': Icons.inventory_2_rounded,
        'hazard': 'Combustible Material Storage',
      },
      {
        'name': 'Area B – Chemical Unit',
        'type': 'Active Reaction & Synthesis Chamber',
        'workers': '1 Worker (Suresh)',
        'status': 'DANGER',
        'color': AppColors.danger,
        'icon': Icons.science_rounded,
        'hazard': 'Toxic Gas & Thermal Hazard',
      },
      {
        'name': 'Area C – Distillation',
        'type': 'Fractional Distillation Columns',
        'workers': '2 Workers (Arun, Vikram)',
        'status': 'SAFE',
        'color': AppColors.safe,
        'icon': Icons.local_fire_department_rounded,
        'hazard': 'Thermal Evaporation Column',
      },
      {
        'name': 'Area D – Utility',
        'type': 'Power Grid & Water Treatment Plant',
        'workers': '2 Workers (Manoj, Anand)',
        'status': 'SAFE',
        'color': AppColors.safe,
        'icon': Icons.build_rounded,
        'hazard': 'High Voltage Transformers',
      },
      {
        'name': 'Area E – Packing Unit',
        'type': 'Finished Product Dispatch Bay',
        'workers': '4 Workers (Priya, Deepa, Bala, Siva)',
        'status': 'SAFE',
        'color': AppColors.safe,
        'icon': Icons.all_inbox_rounded,
        'hazard': 'Heavy Forklift Transport',
      },
      {
        'name': 'Tank Farm – Zone 1',
        'type': 'Pressurized Bulk Chemical Reservoirs',
        'workers': '0 Workers Inside',
        'status': 'RESTRICTED',
        'color': AppColors.danger,
        'icon': Icons.gpp_maybe_rounded,
        'hazard': 'Restricted Geofence Zone',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Plant Areas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.factory_rounded, color: AppColors.safetyAccent, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Chemical Industry Plant: 6 Operational Sectors + 1 Geofenced Hazard Zone.',
                        style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              const Text(
                'MONITORED FACILITY SECTORS',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 1.0),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  itemCount: areas.length,
                  itemBuilder: (context, index) {
                    final a = areas[index];
                    final color = a['color'] as Color;
                    final isDanger = a['status'] == 'DANGER';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDanger ? AppColors.danger : AppColors.border,
                          width: isDanger ? 1.4 : 1.0,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: color.withValues(alpha: 0.5)),
                          ),
                          child: Icon(a['icon'] as IconData, color: color, size: 22),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                a['name'] as String,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryText),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: color),
                              ),
                              child: Text(
                                a['status'] as String,
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: color, letterSpacing: 0.5),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(a['type'] as String, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                            const SizedBox(height: 2),
                            Text(
                              '${a['workers']} • ${a['hazard']}',
                              style: TextStyle(fontSize: 11, color: isDanger ? AppColors.danger : AppColors.mutedText),
                            ),
                          ],
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
}
