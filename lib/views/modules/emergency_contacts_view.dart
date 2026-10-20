import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../common/call_dialog.dart';

class EmergencyContactsView extends StatelessWidget {
  const EmergencyContactsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Exact 5 emergency contacts specified in prompt:
    // Plant Manager, Safety Officer, Medical Team, Fire & Rescue, Security Control
    final contacts = [
      {
        'name': 'Plant Manager',
        'role': 'Executive Safety Operations',
        'phone': '+91 98401 23456',
        'icon': Icons.business_center_rounded,
        'badge': 'EXECUTIVE',
      },
      {
        'name': 'Safety Officer',
        'role': 'Lead Industrial Safety Inspector',
        'phone': '+91 98402 34567',
        'icon': Icons.shield_rounded,
        'badge': 'SAFETY LEAD',
      },
      {
        'name': 'Medical Team',
        'role': 'Emergency First Responder Unit',
        'phone': '+91 98403 45678',
        'icon': Icons.local_hospital_rounded,
        'badge': 'PARAMEDIC',
      },
      {
        'name': 'Fire & Rescue',
        'role': 'Chemical Hazmat Rapid Response',
        'phone': '+91 98404 56789',
        'icon': Icons.local_fire_department_rounded,
        'badge': 'HAZMAT',
      },
      {
        'name': 'Security Control',
        'role': 'Perimeter Access & Surveillance',
        'phone': '+91 98405 67890',
        'icon': Icons.security_rounded,
        'badge': '24/7 DISPATCH',
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
        'Emergency Contacts',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryText),
      ),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notice Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: const [
                  Icon(Icons.headset_mic_rounded, size: 20, color: AppColors.safetyAccent),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Dedicated emergency dispatch hotline lines. Calls are prioritized with automated site recording.',
                      style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'PLANT EMERGENCY CONTACTS',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 1.0),
            ),
            const SizedBox(height: 8),

            // Contacts List
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final c = contacts[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.safetyAccent.withValues(alpha: 0.5)),
                        ),
                        child: Icon(c['icon'] as IconData, color: AppColors.safetyAccent, size: 22),
                      ),
                      title: Row(
                        children: [
                          Text(
                            c['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryText),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              c['badge'] as String,
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 3),
                          Text(c['role'] as String, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                          const SizedBox(height: 2),
                          Text(c['phone'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.safetyAccent)),
                        ],
                      ),
                      trailing: SizedBox(
                        height: 36,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.safetyAccent,
                            foregroundColor: AppColors.background,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.phone_rounded, size: 14),
                          label: const Text('CALL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                          onPressed: () {
                            EmergencyCallDialog.show(
                              context,
                              contactName: c['name'] as String,
                              contactSubtitle: '${c['role']} • ${c['badge']}',
                              phoneNumber: c['phone'] as String,
                              isWorker: false,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Emergency Broadcast Call
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.campaign_rounded, size: 20),
                label: const Text(
                  'ALL-STATION EMERGENCY BROADCAST',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.8),
                ),
                onPressed: () {
                  EmergencyCallDialog.show(
                    context,
                    contactName: 'ALL PLANT STATIONS',
                    contactSubtitle: 'Simultaneous Emergency Broadcast to All Units',
                    isWorker: false,
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
