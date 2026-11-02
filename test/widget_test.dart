import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_app/main.dart';

void main() {
  testWidgets('TaskManagerApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TaskManagerApp(),
      ),
    );
  });
}
