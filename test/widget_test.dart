// StyleHub smoke test: the app boots into its splash screen.
import 'package:flutter_test/flutter_test.dart';

import 'package:stylehub/main.dart';

void main() {
  testWidgets('StyleHub shows splash screen on launch', (tester) async {
    await tester.pumpWidget(const StyleHubApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('StyleHub'), findsOneWidget);
    expect(find.text('Fashion that finds you'), findsOneWidget);
  });
}
