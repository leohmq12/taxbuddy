import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxbuddy/main.dart';

void main() {
  testWidgets('App loads and shows login screen when user is not logged in', (WidgetTester tester) async {
    // Simulate a logged-out user
    User? mockUser = null;
    bool isFirstTime = false;

    // Build the app
    await tester.pumpWidget(MyApp(user: mockUser, isFirstTime: isFirstTime));

    // Verify that the login screen is shown
    expect(find.text('Login'), findsOneWidget);
  });
}
