import 'package:flutter/material.dart';

/// Billing classification of a vehicle request.
/// Drives both filtering and the color tag in the UI.
enum BillingType {
  billable,
  unbillable,
  complimentary;

  String get label {
    switch (this) {
      case BillingType.billable:
        return 'Billable';
      case BillingType.unbillable:
        return 'Unbillable';
      case BillingType.complimentary:
        return 'Complimentary';
    }
  }

  /// Parse from the spreadsheet's "Billable / Unbillable" column string.
  static BillingType fromString(String value) {
    final v = value.trim().toLowerCase();
    if (v.contains('comp')) return BillingType.complimentary;
    if (v.contains('un')) return BillingType.unbillable;
    return BillingType.billable;
  }
}

/// Status of a vehicle request through its lifecycle.
enum VRStatus {
  pending, // requested, not yet assigned
  approved, // assigned to a driver/vehicle
  ongoing, // trip in progress
  completed, // trip finished and logged
  cancelled;

  String get label {
    switch (this) {
      case VRStatus.pending:
        return 'Pending';
      case VRStatus.approved:
        return 'Approved';
      case VRStatus.ongoing:
        return 'Ongoing';
      case VRStatus.completed:
        return 'Completed';
      case VRStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case VRStatus.pending:
        return const Color(0xFFF59E0B);
      case VRStatus.approved:
        return const Color(0xFF3B82F6);
      case VRStatus.ongoing:
        return const Color(0xFF8B5CF6);
      case VRStatus.completed:
        return const Color(0xFF16A34A);
      case VRStatus.cancelled:
        return const Color(0xFF6B7280);
    }
  }
}

/// A single Vehicle Request — corresponds to one row in "Logsheet 2025 (2)"
/// AND to one of the per-VR sheets (e.g. "3617") in the source workbook.
class VehicleRequest {
  final String vrNumber; // e.g. "2803", "2800-A"
  final DateTime date; // trip date
  final TimeOfDay time; // requested time
  final String vehicleType; // e.g. "Innova", "Fortuner"
  final String plateNumber;
  final String driverName;
  final List<String> passengers; // list of passenger names
  final int passengerCount;
  final String itinerary; // free-text route description
  final String requestedBy;
  final String department; // e.g. "Support Services - Transport"
  final String clientName;
  final String? billingReference; // e.g. "9943"
  final BillingType billingType;
  final VRStatus status;
  final double? rateAmount; // amount charged (for Billable trips)

  // Optional fields populated when the trip is completed
  final TimeOfDay? departureTime;
  final TimeOfDay? arrivalTime;
  final double? kilometrageOut;
  final double? kilometrageIn;
  final double? tollFees;
  final double? parkingFees;
  final double? fuelAmount;

  const VehicleRequest({
    required this.vrNumber,
    required this.date,
    required this.time,
    required this.vehicleType,
    required this.plateNumber,
    required this.driverName,
    required this.passengers,
    required this.passengerCount,
    required this.itinerary,
    required this.requestedBy,
    required this.department,
    required this.clientName,
    this.billingReference,
    required this.billingType,
    required this.status,
    this.rateAmount,
    this.departureTime,
    this.arrivalTime,
    this.kilometrageOut,
    this.kilometrageIn,
    this.tollFees,
    this.parkingFees,
    this.fuelAmount,
  });

  /// Total expenses incurred during the trip (toll + parking + fuel).
  double get totalExpenses =>
      (tollFees ?? 0) + (parkingFees ?? 0) + (fuelAmount ?? 0);

  /// Total kilometers travelled.
  double? get distanceTravelled =>
      (kilometrageOut != null && kilometrageIn != null)
          ? (kilometrageIn! - kilometrageOut!)
          : null;

  // BACKEND: implement when wiring to API — payload schema TBD by backend team.
  factory VehicleRequest.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError(
        'Backend wiring pending. Map API fields to VehicleRequest here.');
  }

  Map<String, dynamic> toJson() {
    // BACKEND: used when POSTing a new VR to the server.
    return {
      'vr_number': vrNumber,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'vehicle_type': vehicleType,
      'plate_number': plateNumber,
      'driver_name': driverName,
      'passengers': passengers,
      'passenger_count': passengerCount,
      'itinerary': itinerary,
      'requested_by': requestedBy,
      'department': department,
      'client_name': clientName,
      'billing_reference': billingReference,
      'billing_type': billingType.name,
      'status': status.name,
      'rate_amount': rateAmount,
    };
  }
}
