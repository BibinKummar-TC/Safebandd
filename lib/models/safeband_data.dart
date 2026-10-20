import 'package:flutter/material.dart';
import '../config/constants.dart';

enum WorkerSafetyStatus { safe, warning, danger }

class SafeBandWorker {
  final String id;
  final String name;
  final String area;
  final String department;
  final WorkerSafetyStatus status;
  final String lastUpdate;
  final double mapX; // 0.0 - 1.0 relative coordinates
  final double mapY;
  final String phone;
  final String shift;
  final String initials;

  const SafeBandWorker({
    required this.id,
    required this.name,
    required this.area,
    required this.department,
    required this.status,
    required this.lastUpdate,
    required this.mapX,
    required this.mapY,
    required this.phone,
    required this.shift,
    required this.initials,
  });

  Color get statusColor {
    switch (status) {
      case WorkerSafetyStatus.danger:
        return AppColors.danger;
      case WorkerSafetyStatus.warning:
        return AppColors.warning;
      case WorkerSafetyStatus.safe:
        return AppColors.safe;
    }
  }

  String get statusText {
    switch (status) {
      case WorkerSafetyStatus.danger:
        return 'DANGER';
      case WorkerSafetyStatus.warning:
        return 'WARNING';
      case WorkerSafetyStatus.safe:
        return 'SAFE';
    }
  }
}

class SafeBandData {
  static const String simulationDisclaimer =
      'Hardware not connected. Sensor values are currently shown as zero.';

  // 12 Total Workers in the Chemical Industry Plant
  static final List<SafeBandWorker> workers = [
    const SafeBandWorker(
      id: 'SB1021',
      name: 'Ravi',
      area: 'Area A – Reactor Unit',
      department: 'Reactor Operations',
      status: WorkerSafetyStatus.safe,
      lastUpdate: '10:20 AM',
      mapX: 0.28,
      mapY: 0.22,
      phone: '+91 98401 10001',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'R',
    ),
    const SafeBandWorker(
      id: 'SB1022',
      name: 'Karthik',
      area: 'Area B – Storage',
      department: 'Storage & Logistics',
      status: WorkerSafetyStatus.warning,
      lastUpdate: '10:22 AM',
      mapX: 0.22,
      mapY: 0.42,
      phone: '+91 98401 10002',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'K',
    ),
    const SafeBandWorker(
      id: 'SB1023',
      name: 'Suresh',
      area: 'Area B – Chemical Unit',
      department: 'Chemical Unit',
      status: WorkerSafetyStatus.danger,
      lastUpdate: '10:24 AM',
      mapX: 0.52,
      mapY: 0.48,
      phone: '+91 98401 10003',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'S',
    ),
    const SafeBandWorker(
      id: 'SB1024',
      name: 'Arun',
      area: 'Area C – Distillation',
      department: 'Distillation Unit',
      status: WorkerSafetyStatus.safe,
      lastUpdate: '10:18 AM',
      mapX: 0.78,
      mapY: 0.28,
      phone: '+91 98401 10004',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'A',
    ),
    const SafeBandWorker(
      id: 'SB1025',
      name: 'Manoj',
      area: 'Area D – Utility',
      department: 'Utility & Power',
      status: WorkerSafetyStatus.safe,
      lastUpdate: '10:15 AM',
      mapX: 0.32,
      mapY: 0.72,
      phone: '+91 98401 10005',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'M',
    ),
    // Additional roster workers to reach Total 12
    const SafeBandWorker(
      id: 'SB1026',
      name: 'Priya',
      area: 'Area E – Packing Unit',
      department: 'Packaging & Dispatch',
      status: WorkerSafetyStatus.safe,
      lastUpdate: '10:12 AM',
      mapX: 0.74,
      mapY: 0.62,
      phone: '+91 98401 10006',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'P',
    ),
    const SafeBandWorker(
      id: 'SB1027',
      name: 'Rajesh',
      area: 'Area A – Reactor Unit',
      department: 'Reactor Operations',
      status: WorkerSafetyStatus.safe,
      lastUpdate: '10:10 AM',
      mapX: 0.35,
      mapY: 0.26,
      phone: '+91 98401 10007',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'R',
    ),
    const SafeBandWorker(
      id: 'SB1028',
      name: 'Vikram',
      area: 'Area C – Distillation',
      department: 'Distillation Unit',
      status: WorkerSafetyStatus.safe,
      lastUpdate: '10:08 AM',
      mapX: 0.82,
      mapY: 0.36,
      phone: '+91 98401 10008',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'V',
    ),
    const SafeBandWorker(
      id: 'SB1029',
      name: 'Anand',
      area: 'Area D – Utility',
      department: 'Utility & Power',
      status: WorkerSafetyStatus.safe,
      lastUpdate: '10:05 AM',
      mapX: 0.25,
      mapY: 0.78,
      phone: '+91 98401 10009',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'A',
    ),
    const SafeBandWorker(
      id: 'SB1030',
      name: 'Deepa',
      area: 'Area E – Packing Unit',
      department: 'Packaging & Dispatch',
      status: WorkerSafetyStatus.safe,
      lastUpdate: '10:02 AM',
      mapX: 0.68,
      mapY: 0.68,
      phone: '+91 98401 10010',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'D',
    ),
    const SafeBandWorker(
      id: 'SB1031',
      name: 'Bala',
      area: 'Area E – Packing Unit',
      department: 'Packaging & Dispatch',
      status: WorkerSafetyStatus.safe,
      lastUpdate: '10:00 AM',
      mapX: 0.72,
      mapY: 0.74,
      phone: '+91 98401 10011',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'B',
    ),
    const SafeBandWorker(
      id: 'SB1032',
      name: 'Siva',
      area: 'Area E – Packing Unit',
      department: 'Packaging & Dispatch',
      status: WorkerSafetyStatus.safe,
      lastUpdate: '09:58 AM',
      mapX: 0.80,
      mapY: 0.70,
      phone: '+91 98401 10012',
      shift: 'Morning Shift (06:00 - 14:00)',
      initials: 'S',
    ),
  ];

  static SafeBandWorker getWorkerByName(String name) {
    return workers.firstWhere(
      (w) => w.name.toLowerCase() == name.toLowerCase(),
      orElse: () => workers[2], // Suresh default
    );
  }
}
