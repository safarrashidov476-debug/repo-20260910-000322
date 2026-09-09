import 'package:flutter_test/flutter_test.dart';
import 'package:ozbek_tv_mobile/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const OzbekTVApp());
    expect(find.text("O'zbek TV"), findsOneWidget);
  });
}
