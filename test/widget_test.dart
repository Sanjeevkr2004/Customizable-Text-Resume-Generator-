import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:resume_app/main.dart'; // Replace with actual import path

// Mock class for HTTP client
class MockClient extends Mock implements http.Client {}

void main() {
  group('ResumeApp Widget Tests', () {
    late MockClient mockClient;

    // Set up the mock client before each test
    setUp(() {
      mockClient = MockClient();
    });

    testWidgets('Resume loads and displays data correctly', (WidgetTester tester) async {
      // Arrange mock response
      final mockResponse = {
        'name': 'Sanjeev Kumar Singh',
        'skills': ['Flutter', 'Dart', 'JavaScript'],
        'projects': [
          {'title': 'Project 1', 'description': 'Description 1', 'startDate': '2023-01-01', 'endDate': '2023-06-01'},
          {'title': 'Project 2', 'description': 'Description 2', 'startDate': '2023-07-01', 'endDate': '2023-12-01'}
        ],
      };

      // Correct URL for API request
      final url = Uri.parse("https://expressjs-api-resume-random.onrender.com/resume?name=Sanjeev%20Kumar%20Singh");

      // Stub the HTTP call using Mockito
      when(mockClient.get(url)).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      // Act: Load the app with the mock client
      await tester.pumpWidget(ResumeApp(client: mockClient));
      await tester.pumpAndSettle(); // Wait for async tasks to complete

      // Assert: Check expected output on screen
      expect(find.textContaining('Sanjeev Kumar Singh'), findsOneWidget);
      expect(find.textContaining('Flutter'), findsOneWidget);
      expect(find.textContaining('Dart'), findsOneWidget);
      expect(find.textContaining('Project 1'), findsOneWidget);
      expect(find.textContaining('Description 1'), findsOneWidget);
    });

    testWidgets('Font size slider works correctly', (WidgetTester tester) async {
      // Arrange mock response for testing slider behavior
      final mockResponse = {
        'name': 'Test',
        'skills': [],
        'projects': [],
      };

      final url = Uri.parse("https://expressjs-api-resume-random.onrender.com/resume?name=Test");

      // Stub the HTTP call using Mockito
      when(mockClient.get(url)).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      await tester.pumpWidget(ResumeApp(client: mockClient));
      await tester.pumpAndSettle(); // Wait for the app to load

      // Simulate dragging the font size slider
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(100.0, 0)); // Drag right to increase font size
      await tester.pump(); // Rebuild widget tree

      // No explicit text change expected, but it should not crash
    });

    testWidgets('Color picker dialog appears', (WidgetTester tester) async {
      // Arrange mock response for color picker test
      final mockResponse = {
        'name': 'Test',
        'skills': [],
        'projects': [],
      };

      final url = Uri.parse("https://expressjs-api-resume-random.onrender.com/resume?name=Test");

      // Stub the HTTP call using Mockito
      when(mockClient.get(url)).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      await tester.pumpWidget(ResumeApp(client: mockClient));
      await tester.pumpAndSettle(); // Wait for the app to load

      // Tap on Font Color button to open the color picker dialog
      final fontColorButton = find.text('Font Color');
      expect(fontColorButton, findsOneWidget);

      // Tap the button to trigger the dialog
      await tester.tap(fontColorButton);
      await tester.pumpAndSettle(); // Wait for the dialog to appear

      // Assert that the color picker dialog appears
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining('Pick a Font Color'), findsOneWidget);
    });

    testWidgets('Handles API failure gracefully', (WidgetTester tester) async {
      // Arrange mock response for API failure
      final url = Uri.parse("https://expressjs-api-resume-random.onrender.com/resume?name=Invalid");

      // Stub the HTTP call to simulate a failure (404 status code)
      when(mockClient.get(url)).thenAnswer((_) async => http.Response('Not Found', 404));

      await tester.pumpWidget(ResumeApp(client: mockClient));
      await tester.pumpAndSettle(); // Wait for the app to load

      // Assert: Verify that the app shows an error message
      expect(find.text("Failed to fetch resume."), findsOneWidget);
    });

    testWidgets('Handles empty resume data', (WidgetTester tester) async {
      // Arrange mock response with empty data
      final mockResponse = {
        'name': '',
        'skills': [],
        'projects': [],
      };

      final url = Uri.parse("https://expressjs-api-resume-random.onrender.com/resume?name=Empty");

      // Stub the HTTP call using Mockito
      when(mockClient.get(url)).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      await tester.pumpWidget(ResumeApp(client: mockClient));
      await tester.pumpAndSettle(); // Wait for the app to load

      // Assert: Check if it handles empty data gracefully
      expect(find.textContaining('N/A'), findsNWidgets(4)); // Check for 'N/A' values for missing data
    });
  });
}
