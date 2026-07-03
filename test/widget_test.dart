import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_design/main.dart';
import 'package:todo_design/screens/home/controller/dashboard_controller.dart';
import 'package:todo_design/services/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await Preferences.init();
    Get.reset();
    Get.put(DashboardController(), permanent: true);
  });

  testWidgets('shows dashboard home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('My Day'), findsOneWidget);
  });
}
