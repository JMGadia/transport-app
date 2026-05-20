# Transport Schedule & Vehicle Request Management

A Flutter app for managing the daily operations of a transport department:
vehicle requests, trip logs, fleet, drivers, clients, and feedback.

This is a **UI-complete prototype** seeded with dummy data taken from the source
spreadsheet. Every place that will eventually call a real backend is marked
with a `// BACKEND:` comment.

---

## Getting started (Flutter Web)

```bash
flutter pub get
flutter create . --platforms=web    # adds /web folder if missing
flutter run -d chrome
```

To build a deployable static site:

```bash
flutter build web --release
# Output → build/web/   (deploy this folder to any static host)
```

Requires Flutter `>=3.10.0`. The app also runs unchanged on Android, iOS,
Windows, macOS, and Linux if you add those platforms.

### Why does the app look like a phone in the middle of my browser?

`main.dart` wraps the app in a `WebFrame` widget that constrains it to ~520px
wide on desktop so the layout stays readable. Delete that wrapper when you
want a true wide-screen desktop layout (sidebar nav, multi-column, etc.).

---

## Project structure

```
lib/
├── main.dart                  # App entry point; sets up Provider + theme
├── theme/
│   └── app_theme.dart         # Brand colors, typography, component styling
├── models/                    # Plain data classes (no UI, no Flutter deps)
│   ├── vehicle.dart           # Plate, type, coding day, capacity, slot
│   ├── driver.dart            # Drivers list (company + self-drive)
│   ├── client.dart            # Clients with billing codes
│   ├── vehicle_request.dart   # The core VR entity + BillingType + VRStatus
│   └── client_feedback.dart   # Rating responses (7 criteria)
├── data/                      # Data layer — swap dummy → API here
│   ├── dummy_data.dart        # Hard-coded seed data from the spreadsheet
│   └── data_repository.dart   # Single source the UI talks to (Provider)
├── utils/
│   └── formatters.dart        # Date / time / currency formatting helpers
├── widgets/                   # Reusable UI pieces
│   ├── status_badge.dart      # Color chip for VR status & billing type
│   ├── vr_card.dart           # List tile for a Vehicle Request
│   └── kpi_tile.dart          # KPI card used on Dashboard
└── screens/                   # Full-page UIs
    ├── home_shell.dart        # Bottom-nav host
    ├── dashboard_screen.dart  # Monthly sales + KPI grid + recent VRs
    ├── vr_list_screen.dart    # Searchable, filterable list of all VRs
    ├── vr_detail_screen.dart  # Full VR details (mirrors per-VR sheets)
    ├── create_vr_screen.dart  # Form to submit a new VR
    ├── fleet_screen.dart      # Tabs: Vehicles / Drivers
    └── feedback_screen.dart   # Client feedback ratings
```

---

## Where to wire the backend

All hooks live in **`lib/data/data_repository.dart`**. Each method is a one-line
change away from being a real HTTP call:

```dart
// Today
List<VehicleRequest> get allRequests => DummyData.vehicleRequests;

// Tomorrow
Future<List<VehicleRequest>> get allRequests async {
  final res = await http.get(Uri.parse('$baseUrl/vehicle-requests'));
  final data = jsonDecode(res.body) as List;
  return data.map((e) => VehicleRequest.fromJson(e)).toList();
}
```

`VehicleRequest.toJson()` is already implemented in `models/vehicle_request.dart`
for `POST` requests. `VehicleRequest.fromJson()` is stubbed and waiting for the
backend's response shape to be decided.

To swap the HTTP client in, uncomment `http: ^1.2.0` in `pubspec.yaml`.

---

## Data this app understands (from the source workbook)

| Entity         | Where it came from                                      |
|----------------|---------------------------------------------------------|
| Vehicles       | "Drop Down Data" — Plate / Vehicle / Coding / Slot / Cap |
| Drivers        | "Drop Down Data" — Drivers + Self-Drive columns         |
| Clients        | "Drop Down Data" — Client + Code columns                |
| Departments    | "Drop Down Data" — Department Codes section             |
| Vehicle Requests | "Logsheet 2025 (2)" + per-VR sheets (e.g. "3617")     |
| Billing types  | "Billable / Unbillable" column → BillingType enum       |
| Feedback       | "Client Feedback" sheet (7 criteria, 1–5 scale)         |
| Dashboard KPIs | "SUMMARY" sheet — monthly sales, trip counts            |

---

## State management

Single `ChangeNotifierProvider<DataRepository>` at the root. Screens read with
`context.watch<DataRepository>()` and rebuild automatically when data changes
(e.g. after creating a new VR or updating status).

Swap this for `riverpod` / `bloc` later if you need more structure — the
repository class is already isolated, so only `main.dart` and the screens
that call `context.watch/read` need adjusting.
