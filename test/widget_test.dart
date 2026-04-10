import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ebzim_app/main.dart';
import 'package:ebzim_app/screens/splash_screen.dart';

void main() {
  testWidgets('EbzimApp smoke test - verifies splash screen and initial navigation', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: EbzimApp()));

    // Verify that the splash screen is the initial route.
    expect(find.byType(SplashScreen), findsOneWidget);

    // Verify common splash screen elements.
    // Note: Since localization might take a frame to load or use defaults in tests, 
    // we focus on structural elements or specific widget types.
    expect(find.byType(Image), findsWidgets); // Should find the logo

    // In a real test, we might check for specific text, but let's keep it robust 
    // to localization changes for now.
    
    // Find the text button to navigate to the language screen
    // The button contains an arrow icon
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

    // Tap the 'Explorer' button (it has loc.splashAction)
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    // After tapping, we should no longer be on the splash screen 
    // (it should have navigated to /language)
    expect(find.byType(SplashScreen), findsNothing);
  });
}
