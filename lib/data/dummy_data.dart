import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../models/driver.dart';
import '../models/client.dart';
import '../models/vehicle_request.dart';
import '../models/client_feedback.dart';

/// ============================================================================
/// DUMMY DATA — replace each list below with a real API/database call when
/// the backend is ready.
///
/// Suggested replacement pattern (kept here for the backend developer):
///
///   Future<List<VehicleRequest>> fetchVRs() async {
///     // BACKEND: GET /api/vehicle-requests
///     final res = await http.get(Uri.parse('$baseUrl/vehicle-requests'));
///     final data = jsonDecode(res.body) as List;
///     return data.map((e) => VehicleRequest.fromJson(e)).toList();
///   }
///
/// For now everything below is hard-coded so the UI can be built & demoed.
/// ============================================================================
class DummyData {
  // ---------------------------------------------------------------------------
  // VEHICLES — sourced from the workbook's "Drop Down Data" sheet
  // ---------------------------------------------------------------------------
  static const List<Vehicle> vehicles = [
    Vehicle(
      id: 'v1',
      plateNumber: 'WQS 393',
      type: 'Grandia',
      codingDay: 'Tuesday',
      parkingSlot: 'B1-13',
      conductionSticker: 'T25 711',
      capacitySeatbelt: 7,
      capacityMax: 10,
    ),
    Vehicle(
      id: 'v2',
      plateNumber: 'UHO 687',
      type: 'Grandia',
      codingDay: 'Thursday',
      parkingSlot: 'B1-16',
      conductionSticker: '',
      capacitySeatbelt: 7,
      capacityMax: 10,
    ),
    Vehicle(
      id: 'v3',
      plateNumber: 'ABO 6724',
      type: 'Grandia',
      codingDay: 'Tuesday',
      parkingSlot: 'B1-13',
      conductionSticker: 'YP7 764',
      capacitySeatbelt: 7,
      capacityMax: 10,
    ),
    Vehicle(
      id: 'v4',
      plateNumber: 'NEZ 4290',
      type: 'Grandia',
      codingDay: 'Friday',
      parkingSlot: '2F-16',
      conductionSticker: 'WS956A',
      capacitySeatbelt: 7,
      capacityMax: 10,
    ),
    Vehicle(
      id: 'v5',
      plateNumber: 'NES 7360',
      type: 'Innova',
      codingDay: 'Friday',
      parkingSlot: 'M-11',
      conductionSticker: 'S4M 842',
      capacitySeatbelt: 3,
      capacityMax: 5,
    ),
    Vehicle(
      id: 'v6',
      plateNumber: 'AKA 5239',
      type: 'Innova',
      codingDay: 'Friday',
      parkingSlot: 'B1-08',
      conductionSticker: 'XL4457',
      capacitySeatbelt: 3,
      capacityMax: 5,
    ),
    Vehicle(
      id: 'v7',
      plateNumber: 'BEY 892',
      type: 'Innova',
      codingDay: 'Monday',
      parkingSlot: 'B1-09',
      conductionSticker: '',
      capacitySeatbelt: 3,
      capacityMax: 5,
    ),
    Vehicle(
      id: 'v8',
      plateNumber: 'NHS 1470',
      type: 'Innova',
      codingDay: 'Friday',
      parkingSlot: 'M-12',
      conductionSticker: 'Z6U 114',
      capacitySeatbelt: 3,
      capacityMax: 5,
    ),
    Vehicle(
      id: 'v9',
      plateNumber: 'ABE 5802',
      type: 'Montero',
      codingDay: 'Monday',
      parkingSlot: 'M-13',
      conductionSticker: 'NJ 0753',
      capacitySeatbelt: 3,
      capacityMax: 6,
    ),
    Vehicle(
      id: 'v10',
      plateNumber: 'ABO 6723',
      type: 'Fortuner',
      codingDay: 'Tuesday',
      parkingSlot: 'M-02',
      conductionSticker: '3939',
      capacitySeatbelt: 3,
      capacityMax: 6,
    ),
    Vehicle(
      id: 'v11',
      plateNumber: 'ABO 6725',
      type: 'Fortuner',
      codingDay: 'Wednesday',
      parkingSlot: 'M-03',
      conductionSticker: 'YP4019',
      capacitySeatbelt: 3,
      capacityMax: 6,
    ),
    Vehicle(
      id: 'v12',
      plateNumber: 'BEY 874',
      type: 'Hilux',
      codingDay: 'Tuesday',
      parkingSlot: '—',
      conductionSticker: 'T25 442',
      capacitySeatbelt: 2,
      capacityMax: 3,
    ),
    Vehicle(
      id: 'v13',
      plateNumber: 'NJA 1382',
      type: 'Urvan',
      codingDay: 'Monday',
      parkingSlot: 'M-15',
      conductionSticker: 'NI276A',
      capacitySeatbelt: 5,
      capacityMax: 9,
    ),
  ];

  // ---------------------------------------------------------------------------
  // DRIVERS — sourced from "Drivers" and "Self-Drive" columns
  // ---------------------------------------------------------------------------
  static const List<Driver> drivers = [
    Driver(id: 'd1', name: 'Allan Llagas'),
    Driver(id: 'd2', name: 'Fidel Dacanay'),
    Driver(id: 'd3', name: 'Florante Rapisura'),
    Driver(id: 'd4', name: 'Jaime Villanueva'),
    Driver(id: 'd5', name: 'Ramon Daza'),
    Driver(id: 'd6', name: 'Self-Drive', isSelfDrive: true),
    Driver(id: 'd7', name: 'Kat Agpuldo', isSelfDrive: true),
    Driver(id: 'd8', name: 'Jaycob Acain', isSelfDrive: true),
    Driver(id: 'd9', name: 'Raff Palma', isSelfDrive: true),
    Driver(id: 'd10', name: 'Alfrederik Laygo', isSelfDrive: true),
    Driver(id: 'd11', name: 'Jeric Espiritu', isSelfDrive: true),
    Driver(id: 'd12', name: 'Matt Pamplona', isSelfDrive: true),
    Driver(id: 'd13', name: 'Jeffrey Rivera', isSelfDrive: true),
    Driver(id: 'd14', name: 'Faye Agaton', isSelfDrive: true),
    Driver(id: 'd15', name: 'Anthony Donato', isSelfDrive: true),
    Driver(id: 'd16', name: 'Ralph Remonte', isSelfDrive: true),
    Driver(id: 'd17', name: 'Jomel Manalo', isSelfDrive: true),
    Driver(id: 'd18', name: 'Menard Genciana', isSelfDrive: true),
  ];

  // ---------------------------------------------------------------------------
  // CLIENTS — sourced from the workbook's Client list with billing codes
  // ---------------------------------------------------------------------------
  static const List<Client> clients = [
    Client(id: 'c1', name: 'SOS', code: '3113'),
    Client(id: 'c2', name: 'SOMPS'),
    Client(id: 'c3', name: 'DOF Asia Pacific Pte Ltd', code: '3936'),
    Client(id: 'c4', name: 'AMEC Services Limited - Philippines', code: '3455'),
    Client(id: 'c5', name: 'ExxonMobil Asia Pacific Pte. Ltd.', code: '9943'),
    Client(id: 'c6', name: 'ExxonMobil Aviation Lubricants', code: '9943'),
    Client(id: 'c7', name: 'ExxonMobil Chemical Asia Pacific', code: '9943'),
    Client(
        id: 'c8', name: 'ExxonMobil Chemical Malaysia Sdn Bhd', code: '9943'),
    Client(
        id: 'c9', name: 'ExxonMobil Product Solutions Company', code: '9943'),
    Client(id: 'c10', name: 'ExxonMobil Limited'),
    Client(id: 'c11', name: 'ExxonMobil Upstream', code: '9943'),
    Client(id: 'c12', name: 'NPG', code: '3519'),
    Client(id: 'c13', name: 'Shell Pilipinas Corporation', code: '3876'),
    Client(id: 'c14', name: 'Weatherford', code: '9366'),
    Client(id: 'c15', name: 'MHI Investment Holdings, Inc.', code: '3883'),
    Client(id: 'c16', name: 'XISCO'),
    Client(id: 'c17', name: 'Fugro'),
    Client(id: 'c18', name: 'GCAT'),
  ];

  // ---------------------------------------------------------------------------
  // DEPARTMENTS — list of valid departments for the VR form dropdown
  // ---------------------------------------------------------------------------
  static const List<String> departments = [
    'Support Services - Transport',
    'Support Services - Logistics',
    'Support Services - Technical',
    'Overseas Employment Group',
    'Administration',
    'Executive Office',
    'QHSE',
    'General',
    'Catering',
    'Sales and Marketing',
    'HR-LPE',
    'Finance',
    'Legal',
    'IT',
    'Domestic',
    'Chairman - President',
  ];

  // ---------------------------------------------------------------------------
  // VEHICLE REQUESTS — recreated from the actual logsheet rows
  // ---------------------------------------------------------------------------
  static List<VehicleRequest> vehicleRequests = [
    VehicleRequest(
      vrNumber: '2799',
      date: DateTime(2026, 1, 1),
      time: const TimeOfDay(hour: 4, minute: 0),
      vehicleType: 'Innova',
      plateNumber: 'NHS 1470 / Z6U 114',
      driverName: 'Ramon Daza',
      passengers: const ['Elmer Alvarez', 'George Torculas'],
      passengerCount: 2,
      itinerary: 'VALERO - T2\nT60110\n0630H departure',
      requestedBy: 'Mirella Grace De Vera',
      department: 'Overseas Employment Group',
      clientName: 'SOS',
      billingType: BillingType.unbillable,
      status: VRStatus.completed,
    ),
    VehicleRequest(
      vrNumber: '2800',
      date: DateTime(2026, 1, 1),
      time: const TimeOfDay(hour: 14, minute: 55),
      vehicleType: 'Innova',
      plateNumber: 'NHS 1470 / Z6U 114',
      driverName: 'Florante Rapisura',
      passengers: const ['Ricaredo Larga', 'Gerald Tumlos', 'Raul Mendoza'],
      passengerCount: 3,
      itinerary: 'CLARK - SOS - Y2\n\nCharged to NPG',
      requestedBy: 'Mirella Grace De Vera',
      department: 'Support Services - Transport',
      clientName: 'NPG',
      billingReference: 'Charge to NPG',
      billingType: BillingType.billable,
      status: VRStatus.completed,
      rateAmount: 4500.00,
    ),
    VehicleRequest(
      vrNumber: '2803',
      date: DateTime(2026, 1, 3),
      time: const TimeOfDay(hour: 18, minute: 30),
      vehicleType: 'Fortuner',
      plateNumber: 'ABO 6725',
      driverName: 'Florante Rapisura',
      passengers: const ['Nazim Ghole'],
      passengerCount: 1,
      itinerary: 'NAIA T2 - T3',
      requestedBy: 'Mirella Grace De Vera',
      department: 'Support Services - Transport',
      clientName: 'NPG',
      billingType: BillingType.billable,
      status: VRStatus.completed,
      rateAmount: 2800.00,
    ),
    VehicleRequest(
      vrNumber: '2807',
      date: DateTime(2026, 1, 5),
      time: const TimeOfDay(hour: 18, minute: 0),
      vehicleType: 'Innova',
      plateNumber: 'NHS 1470 / Z6U 114',
      driverName: 'Florante Rapisura',
      passengers: const ['Philippa Godfrey'],
      passengerCount: 1,
      itinerary: '1800H - Pick up at NAIA T3 (QF Flight)',
      requestedBy: 'Philippa Godfrey',
      department: 'Support Services - Transport',
      clientName: 'ExxonMobil Upstream',
      billingReference: '9943',
      billingType: BillingType.billable,
      status: VRStatus.completed,
      rateAmount: 3200.00,
      arrivalTime: const TimeOfDay(hour: 17, minute: 30),
    ),
    VehicleRequest(
      vrNumber: '2809',
      date: DateTime(2026, 1, 6),
      time: const TimeOfDay(hour: 16, minute: 30),
      vehicleType: 'Innova',
      plateNumber: 'NES 7360',
      driverName: 'Allan Llagas',
      passengers: const ['Colin Loh'],
      passengerCount: 1,
      itinerary: 'Arrival to Manila MH704 1245/1630H from KUL',
      requestedBy: 'Colin Loh',
      department: 'Support Services - Transport',
      clientName: 'ExxonMobil Chemical Malaysia Sdn Bhd',
      billingReference: '9943',
      billingType: BillingType.billable,
      status: VRStatus.completed,
      rateAmount: 3200.00,
    ),
    VehicleRequest(
      vrNumber: '2811',
      date: DateTime(2026, 1, 6),
      time: const TimeOfDay(hour: 10, minute: 30),
      vehicleType: 'Fortuner',
      plateNumber: 'ABO 6723',
      driverName: 'Jaime Villanueva',
      passengers: const ['Ruela Bacolod', 'Amilah Hadji Jalil'],
      passengerCount: 2,
      itinerary: 'SOS Office to ff offices:\n1. Nido Petroleum\n2. DOE',
      requestedBy: 'Amilah Hadji Jalil',
      department: 'Executive Office',
      clientName: 'SOS',
      billingType: BillingType.unbillable,
      status: VRStatus.completed,
    ),
    VehicleRequest(
      vrNumber: '2812',
      date: DateTime(2026, 1, 6),
      time: const TimeOfDay(hour: 8, minute: 0),
      vehicleType: 'Fortuner',
      plateNumber: 'ABO 6725',
      driverName: 'Ramon Daza',
      passengers: const ['1 x Crate 55x45x52cm', '1 x Box'],
      passengerCount: 0,
      itinerary: '0800H or before 1500H\n\nLocation: Weatherford warehouse',
      requestedBy: 'Miriam Geroy',
      department: 'Support Services - Logistics',
      clientName: 'Weatherford',
      billingReference: '9366',
      billingType: BillingType.billable,
      status: VRStatus.completed,
      rateAmount: 5200.00,
    ),
    VehicleRequest(
      vrNumber: '2820',
      date: DateTime(2026, 1, 7),
      time: const TimeOfDay(hour: 13, minute: 0),
      vehicleType: 'Montero',
      plateNumber: 'ABE 5802',
      driverName: 'Self-Drive',
      passengers: const ['Jeffrey Rivera', 'Rhene Rose Abelar'],
      passengerCount: 2,
      itinerary: 'SOS - Wells Fargo',
      requestedBy: 'Rhene Rose Abelar',
      department: 'Catering',
      clientName: 'SOS',
      billingType: BillingType.unbillable,
      status: VRStatus.completed,
    ),
    VehicleRequest(
      vrNumber: '3617',
      date: DateTime(2026, 5, 19),
      time: const TimeOfDay(hour: 8, minute: 0),
      vehicleType: 'Grandia',
      plateNumber: 'WQS 393',
      driverName: 'Allan Llagas',
      passengers: const ['Ady Ayatullah', 'Team of 4'],
      passengerCount: 5,
      itinerary:
          '0800H Pick up at EDSA Shangri-La\nMeeting at ExxonMobil Office',
      requestedBy: 'Mirella Grace De Vera',
      department: 'Support Services - Transport',
      clientName: 'ExxonMobil Chemical Asia Pacific',
      billingReference: '9943',
      billingType: BillingType.complimentary,
      status: VRStatus.ongoing,
    ),
    VehicleRequest(
      vrNumber: '3618',
      date: DateTime(2026, 5, 20),
      time: const TimeOfDay(hour: 9, minute: 30),
      vehicleType: 'Urvan',
      plateNumber: 'NJA 1382',
      driverName: 'Fidel Dacanay',
      passengers: const ['Kat Agpuldo', 'Philip Pacarat', 'Team of 5'],
      passengerCount: 7,
      itinerary: 'SOS Office - Evangelista - Back to SOS',
      requestedBy: 'Kat Agpuldo',
      department: 'Support Services - Transport',
      clientName: 'SOS',
      billingType: BillingType.unbillable,
      status: VRStatus.approved,
    ),
    VehicleRequest(
      vrNumber: '3619',
      date: DateTime(2026, 5, 21),
      time: const TimeOfDay(hour: 7, minute: 0),
      vehicleType: 'Innova',
      plateNumber: 'NES 7360',
      driverName: 'Ramon Daza',
      passengers: const ['Colin Loh', 'James Lim'],
      passengerCount: 2,
      itinerary: 'Hotel pickup - Flexo Packaging - Prima Plastic',
      requestedBy: 'Colin Loh',
      department: 'Support Services - Transport',
      clientName: 'ExxonMobil Chemical Malaysia Sdn Bhd',
      billingReference: '9943',
      billingType: BillingType.billable,
      status: VRStatus.pending,
      rateAmount: 4200.00,
    ),
    VehicleRequest(
      vrNumber: '3620',
      date: DateTime(2026, 5, 22),
      time: const TimeOfDay(hour: 14, minute: 0),
      vehicleType: 'Hilux',
      plateNumber: 'BEY 874',
      driverName: 'Menard Genciana',
      passengers: const ['Equipment delivery — 3 crates'],
      passengerCount: 0,
      itinerary: 'SOS - Subic Bay Freeport',
      requestedBy: 'Ma. Teresa Bolanos',
      department: 'Support Services - Logistics',
      clientName: 'Fugro',
      billingType: BillingType.billable,
      status: VRStatus.pending,
      rateAmount: 6800.00,
    ),
  ];

  // ---------------------------------------------------------------------------
  // CLIENT FEEDBACK — sample feedback responses
  // ---------------------------------------------------------------------------
  static List<ClientFeedback> feedback = [
    ClientFeedback(
      id: 'f1',
      company: 'ExxonMobil Upstream',
      name: 'Philippa Godfrey',
      date: DateTime(2026, 1, 7),
      time: '17:30',
      professionalism: 5,
      skills: 5,
      workAttitude: 5,
      safety: 5,
      performance: 4,
      cleanliness: 5,
      condition: 4,
      comments: 'Florante was very professional. Smooth airport pickup.',
    ),
    ClientFeedback(
      id: 'f2',
      company: 'ExxonMobil Chemical Malaysia',
      name: 'Colin Loh',
      date: DateTime(2026, 1, 6),
      time: '18:00',
      professionalism: 5,
      skills: 4,
      workAttitude: 5,
      safety: 5,
      performance: 5,
      cleanliness: 5,
      condition: 5,
      comments: 'Excellent service throughout my entire stay.',
    ),
    ClientFeedback(
      id: 'f3',
      company: 'Weatherford',
      name: 'Miriam Geroy',
      date: DateTime(2026, 1, 6),
      time: '15:00',
      professionalism: 4,
      skills: 4,
      workAttitude: 4,
      safety: 5,
      performance: 4,
      cleanliness: 4,
      condition: 4,
      comments: 'Delivery handled with care.',
    ),
    ClientFeedback(
      id: 'f4',
      company: 'NPG',
      name: 'Nazim Ghole',
      date: DateTime(2026, 1, 3),
      time: '20:00',
      professionalism: 5,
      skills: 5,
      workAttitude: 5,
      safety: 5,
      performance: 5,
      cleanliness: 5,
      condition: 5,
      comments: 'Perfect — on time and professional.',
    ),
  ];

  // ---------------------------------------------------------------------------
  // DASHBOARD KPIs — derived from the SUMMARY sheet
  // ---------------------------------------------------------------------------
  static const double monthlySales = 454125.40;
  static const double monthlyGoal = 500000.00;
  static int get billableCount => vehicleRequests
      .where((vr) => vr.billingType == BillingType.billable)
      .length;
  static int get unbillableCount => vehicleRequests
      .where((vr) => vr.billingType == BillingType.unbillable)
      .length;
  static int get complimentaryCount => vehicleRequests
      .where((vr) => vr.billingType == BillingType.complimentary)
      .length;
  static int get totalTrips => vehicleRequests.length;
}
