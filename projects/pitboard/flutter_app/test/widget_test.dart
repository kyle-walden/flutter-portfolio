import 'package:flutter_test/flutter_test.dart';
import 'package:pitboard/app/app.dart';

void main() {
  testWidgets('smoke test - app builds', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Pitboard (Abstract)'), findsOneWidget);
  });
}
