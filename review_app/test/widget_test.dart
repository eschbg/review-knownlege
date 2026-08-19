import 'package:flutter_test/flutter_test.dart';
import 'package:review_app/main.dart';

void main() {
  testWidgets('App loads Tech Mastery Review Hub smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TechMasteryApp());
    expect(find.text('Tech Mastery'), findsOneWidget);
  });
}
