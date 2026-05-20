import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_repository.dart';
import '../models/vehicle_request.dart';
import '../theme/app_theme.dart';
import '../widgets/app_toast.dart';

/// Form to create a new Vehicle Request.
/// Mirrors the "Blank VR" template sheet in the source workbook.
///
/// When [embedded] is true, the form is rendered without its own Scaffold/
/// AppBar — the parent (e.g. AppRoute's modal dialog) provides those.
class CreateVRScreen extends StatefulWidget {
  final bool embedded;
  const CreateVRScreen({super.key, this.embedded = false});

  @override
  State<CreateVRScreen> createState() => _CreateVRScreenState();
}

class _CreateVRScreenState extends State<CreateVRScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _passengersCtrl = TextEditingController();
  final _itineraryCtrl = TextEditingController();
  final _requestedByCtrl = TextEditingController();
  final _passengerCountCtrl = TextEditingController(text: '1');

  // Form state
  String? _vehiclePlate;
  String? _driverName;
  String? _clientName;
  String? _department;
  BillingType _billing = BillingType.unbillable;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);

  @override
  void dispose() {
    _passengersCtrl.dispose();
    _itineraryCtrl.dispose();
    _requestedByCtrl.dispose();
    _passengerCountCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_vehiclePlate == null || _driverName == null || _clientName == null) {
      AppToast.show(context, 'Please complete all dropdown fields.',
          kind: ToastKind.error);
      return;
    }

    final repo = context.read<DataRepository>();
    final vehicle =
        repo.vehicles.firstWhere((v) => v.plateNumber == _vehiclePlate);

    final passengers = _passengersCtrl.text
        .split('\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    // BACKEND: replace this with a POST /api/vehicle-requests call.
    // The server should auto-generate the VR number; we generate one locally.
    final nextVRNumber = _generateNextVRNumber(repo);

    final newVR = VehicleRequest(
      vrNumber: nextVRNumber,
      date: _date,
      time: _time,
      vehicleType: vehicle.type,
      plateNumber: vehicle.plateNumber,
      driverName: _driverName!,
      passengers: passengers,
      passengerCount:
          int.tryParse(_passengerCountCtrl.text) ?? passengers.length,
      itinerary: _itineraryCtrl.text,
      requestedBy: _requestedByCtrl.text,
      department: _department ?? 'Support Services - Transport',
      clientName: _clientName!,
      billingType: _billing,
      status: VRStatus.pending,
    );

    await repo.addRequest(newVR);

    if (!mounted) return;
    Navigator.pop(context);
    AppToast.show(context, 'VR #$nextVRNumber created.',
        kind: ToastKind.success);
  }

  /// Generate the next VR number based on the highest existing numeric VR.
  /// BACKEND: this logic should live server-side; client just receives it back.
  String _generateNextVRNumber(DataRepository repo) {
    final nums = repo.allRequests
        .map((vr) => int.tryParse(vr.vrNumber.split('-').first) ?? 0)
        .toList();
    final max = nums.fold<int>(0, (a, b) => a > b ? a : b);
    return (max + 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<DataRepository>();

    final form = Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: widget.embedded,
        children: [
          _label('Date Required'),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _date = picked);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.calendar_today, size: 18),
              ),
              child: Text(
                '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
              ),
            ),
          ),
          const SizedBox(height: 14),
          _label('Time Required'),
          InkWell(
            onTap: () async {
              final picked =
                  await showTimePicker(context: context, initialTime: _time);
              if (picked != null) setState(() => _time = picked);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.access_time, size: 18),
              ),
              child: Text(_time.format(context)),
            ),
          ),
          const SizedBox(height: 14),
          _label('Vehicle'),
          DropdownButtonFormField<String>(
            initialValue: _vehiclePlate,
            isExpanded: true,
            hint: const Text('Select a vehicle'),
            items: repo.vehicles
                .map((v) => DropdownMenuItem(
                      value: v.plateNumber,
                      child: Text('${v.type} • ${v.plateNumber}'),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _vehiclePlate = v),
          ),
          const SizedBox(height: 14),
          _label('Driver'),
          DropdownButtonFormField<String>(
            initialValue: _driverName,
            isExpanded: true,
            hint: const Text('Select a driver'),
            items: repo.drivers
                .map((d) => DropdownMenuItem(
                      value: d.name,
                      child: Text(
                          d.isSelfDrive ? '${d.name} (Self-Drive)' : d.name),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _driverName = v),
          ),
          const SizedBox(height: 14),
          _label('Passengers (one per line)'),
          TextFormField(
            controller: _passengersCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'e.g.\nJohn Doe\nJane Smith',
            ),
          ),
          const SizedBox(height: 14),
          _label('Number of Passengers'),
          TextFormField(
            controller: _passengerCountCtrl,
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 14),
          _label('Itinerary / Place of Mobilization'),
          TextFormField(
            controller: _itineraryCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Pickup / drop-off / route...',
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 14),
          _label('Requested By'),
          TextFormField(
            controller: _requestedByCtrl,
            decoration: const InputDecoration(hintText: 'Requestor name'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 14),
          _label('Department'),
          DropdownButtonFormField<String>(
            initialValue: _department,
            isExpanded: true,
            hint: const Text('Select a department'),
            items: repo.departments
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) => setState(() => _department = v),
          ),
          const SizedBox(height: 14),
          _label('Client'),
          DropdownButtonFormField<String>(
            initialValue: _clientName,
            isExpanded: true,
            hint: const Text('Select a client'),
            items: repo.clients
                .map((c) => DropdownMenuItem(
                      value: c.name,
                      child: Text(c.name, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _clientName = v),
          ),
          const SizedBox(height: 14),
          _label('Charge To'),
          SegmentedButton<BillingType>(
            segments: const [
              ButtonSegment(value: BillingType.billable, label: Text('Client')),
              ButtonSegment(value: BillingType.unbillable, label: Text('SOS')),
              ButtonSegment(
                  value: BillingType.complimentary,
                  label: Text('Complimentary')),
            ],
            selected: {_billing},
            onSelectionChanged: (v) => setState(() => _billing = v.first),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Submit Request'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );

    // Embedded inside an AppRoute modal on desktop — return just the form.
    if (widget.embedded) return form;

    // Full-page mode (mobile).
    return Scaffold(
      appBar: AppBar(title: const Text('New Vehicle Request')),
      body: form,
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
      );
}
