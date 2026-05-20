import 'package:flutter/foundation.dart';
import '../models/vehicle.dart';
import '../models/driver.dart';
import '../models/client.dart';
import '../models/vehicle_request.dart';
import '../models/client_feedback.dart';
import 'dummy_data.dart';

/// Central data store for the app, exposed via `Provider`.
///
/// Today this just returns dummy data. When the backend exists, replace each
/// method body with an actual HTTP/database call — the rest of the UI does not
/// need to change.
class DataRepository extends ChangeNotifier {
  // ===========================================================================
  // VEHICLE REQUESTS
  // ===========================================================================

  List<VehicleRequest> get allRequests => DummyData.vehicleRequests;

  /// Returns VRs filtered by status. Pass `null` for all.
  List<VehicleRequest> requestsByStatus(VRStatus? status) {
    if (status == null) return allRequests;
    return allRequests.where((vr) => vr.status == status).toList();
  }

  /// Returns VRs filtered by billing type. Pass `null` for all.
  List<VehicleRequest> requestsByBilling(BillingType? type) {
    if (type == null) return allRequests;
    return allRequests.where((vr) => vr.billingType == type).toList();
  }

  /// Returns a single VR by its VR number, or null if not found.
  VehicleRequest? findRequest(String vrNumber) {
    try {
      return allRequests.firstWhere((vr) => vr.vrNumber == vrNumber);
    } catch (_) {
      return null;
    }
  }

  /// Adds a new VR to the local list and notifies listeners.
  /// BACKEND: replace with `await http.post(...)` and refresh from server.
  Future<void> addRequest(VehicleRequest vr) async {
    DummyData.vehicleRequests.insert(0, vr);
    notifyListeners();
  }

  /// Updates an existing VR (e.g. status change from Pending → Approved).
  /// BACKEND: replace with `await http.put(...)`.
  Future<void> updateRequestStatus(String vrNumber, VRStatus newStatus) async {
    final index =
        DummyData.vehicleRequests.indexWhere((vr) => vr.vrNumber == vrNumber);
    if (index == -1) return;
    final old = DummyData.vehicleRequests[index];
    DummyData.vehicleRequests[index] = VehicleRequest(
      vrNumber: old.vrNumber,
      date: old.date,
      time: old.time,
      vehicleType: old.vehicleType,
      plateNumber: old.plateNumber,
      driverName: old.driverName,
      passengers: old.passengers,
      passengerCount: old.passengerCount,
      itinerary: old.itinerary,
      requestedBy: old.requestedBy,
      department: old.department,
      clientName: old.clientName,
      billingReference: old.billingReference,
      billingType: old.billingType,
      status: newStatus,
      rateAmount: old.rateAmount,
      departureTime: old.departureTime,
      arrivalTime: old.arrivalTime,
      kilometrageOut: old.kilometrageOut,
      kilometrageIn: old.kilometrageIn,
      tollFees: old.tollFees,
      parkingFees: old.parkingFees,
      fuelAmount: old.fuelAmount,
    );
    notifyListeners();
  }

  // ===========================================================================
  // VEHICLES / DRIVERS / CLIENTS
  // ===========================================================================

  List<Vehicle> get vehicles => DummyData.vehicles;
  List<Driver> get drivers => DummyData.drivers;
  List<Client> get clients => DummyData.clients;
  List<String> get departments => DummyData.departments;

  // ===========================================================================
  // FEEDBACK
  // ===========================================================================

  List<ClientFeedback> get feedback => DummyData.feedback;

  Future<void> addFeedback(ClientFeedback fb) async {
    DummyData.feedback.insert(0, fb);
    notifyListeners();
  }

  // ===========================================================================
  // DASHBOARD KPIs
  // ===========================================================================

  double get monthlySales => DummyData.monthlySales;
  double get monthlyGoal => DummyData.monthlyGoal;
  int get billableCount => DummyData.billableCount;
  int get unbillableCount => DummyData.unbillableCount;
  int get complimentaryCount => DummyData.complimentaryCount;
  int get totalTrips => DummyData.totalTrips;
  double get progressPercent => monthlySales / monthlyGoal;
}
