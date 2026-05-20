/// Represents a vehicle in the fleet.
///
/// Columns from the source logsheet (Drop Down Data sheet):
/// Plate # | Vehicle | Coding | Slot | Conduction Sticker | Capacity (3pt SB) | Cap Max
class Vehicle {
  final String id; // internal id (e.g. plate normalized)
  final String plateNumber; // e.g. "WQS 393"
  final String type; // e.g. "Grandia", "Innova", "Fortuner"
  final String codingDay; // day of the week the vehicle is "coded" / off-road
  final String parkingSlot; // e.g. "B1-13"
  final String conductionSticker; // e.g. "T25 711"
  final int capacitySeatbelt; // safe seating with 3-point seatbelts
  final int capacityMax; // max passenger capacity

  const Vehicle({
    required this.id,
    required this.plateNumber,
    required this.type,
    required this.codingDay,
    required this.parkingSlot,
    required this.conductionSticker,
    required this.capacitySeatbelt,
    required this.capacityMax,
  });

  // BACKEND: when wiring to an API, replace dummy data with `Vehicle.fromJson`.
  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json['id'] as String,
        plateNumber: json['plate_number'] as String,
        type: json['type'] as String,
        codingDay: json['coding_day'] as String? ?? '',
        parkingSlot: json['parking_slot'] as String? ?? '',
        conductionSticker: json['conduction_sticker'] as String? ?? '',
        capacitySeatbelt: json['capacity_seatbelt'] as int? ?? 0,
        capacityMax: json['capacity_max'] as int? ?? 0,
      );
}
