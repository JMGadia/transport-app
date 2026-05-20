/// Represents a driver employed by the transport department.
class Driver {
  final String id;
  final String name;
  final bool
      isSelfDrive; // some entries are tagged "Self-Drive" instead of a driver name
  final String?
      licenseNo; // optional — not in the source sheet but commonly tracked
  final String? contactNo;

  const Driver({
    required this.id,
    required this.name,
    this.isSelfDrive = false,
    this.licenseNo,
    this.contactNo,
  });

  // BACKEND: replace with real DTO mapping when API is wired up.
  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        id: json['id'] as String,
        name: json['name'] as String,
        isSelfDrive: json['is_self_drive'] as bool? ?? false,
        licenseNo: json['license_no'] as String?,
        contactNo: json['contact_no'] as String?,
      );
}
