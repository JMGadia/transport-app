// Basic smoke test for the Transport Schedule app.
//
// To test more screens, pump them inside a ChangeNotifierProvider with a
// DataRepository so the widgets have a data source to read from.

import 'package:flutter_test/flutter_test.dart';
import 'package:transport_app/main.dart';

void main() {
  testWidgets('App boots and shows Dashboard title',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TransportApp());
    await tester.pumpAndSettle();

    // The default landing tab is "Dashboard" — its title appears in the AppBar.
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
