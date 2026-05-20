/// Represents a client / company that requests transport services.
/// In the source spreadsheet these come from the Drop Down Data > Client column.
class Client {
  final String id;
  final String name; // e.g. "ExxonMobil Upstream", "Weatherford", "SOS"
  final String? code; // billing reference code (e.g. "9943", "3519")

  const Client({
    required this.id,
    required this.name,
    this.code,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json['id'] as String,
        name: json['name'] as String,
        code: json['code'] as String?,
      );
}
