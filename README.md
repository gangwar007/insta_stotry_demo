#Insta Story Demo
This Flutter project demonstrates a story feature similar to Instagram stories, where stories auto-advance every 5 seconds and can be manually navigated. The project uses the BLoC pattern for state management and follows clean architecture principles.

Table of Contents
- Features
- Getting Started
- Project Structure
- Running the App
- Running Integration Tests
- Contributing
- License
  
Features
Auto-Advance Stories: Stories automatically advance to the next one after a set duration (5 seconds).
Manual Navigation: Users can manually navigate between stories using UI controls (tap left or right).
Progress Indicator: A progress indicator shows the current story progress.
Error Handling: Displays a placeholder when images fail to load.
Getting Started
Prerequisites
Flutter
Dart
Installation
Clone the repository:
bash
Copy code
git clone https://github.com/your_username/insta_story_demo.git
cd insta_story_demo
Install dependencies:
bash
Copy code
flutter pub get
Project Structure
css
Copy code
lib/
├── bloc/
│   ├── story_bloc.dart
│   ├── story_event.dart
│   └── story_state.dart
├── data/
│   ├── data_sources/
│   │   └── story_local_data_source_impl.dart
│   └── repositories/
│       └── story_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── story.dart
│   └── repositories/
│       └── story_repository.dart
├── presentation/
│   ├── pages/
│   │   ├── stories_screen.dart
│   │   ├── story_detail_screen.dart
│   │   └── story_progress_indicator.dart
│   └── widgets/
│       └── story_widget.dart
├── main.dart
└── service_locator.dart
Running the App
To run the app on an emulator or physical device, use the following command:

bash
Copy code
flutter run
Running Integration Tests
Integration tests are included to verify the functionality of the story feature. To run the integration tests, follow these steps:

Ensure the device/emulator is running:
Start an emulator or connect a physical device.

Run the integration tests:
bash
Copy code
flutter test integration_test
Integration Tests Overview
The integration tests cover the following scenarios:

Initial Story Display: Verifies that the first story is displayed correctly.
Auto-Advance Functionality: Verifies that stories auto-advance after the set duration.
Manual Navigation: Verifies manual navigation between stories by tapping on the left and right sides of the screen.
Progress Indicator: Verifies that the progress indicator updates correctly.
Completion: Verifies that the screen pops back to the StoriesScreen after the last story.
Sample Integration Test Code
integration_test/story_detail_screen_test.dart

dart
Copy code
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:your_project_name/main.dart'; // Adjust the import to match your project structure
import 'package:get_it/get_it.dart';
import 'package:your_project_name/service_locator.dart';
import 'package:your_project_name/presentation/bloc/story_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
IntegrationTestWidgetsFlutterBinding.ensureInitialized();

setupLocator(); // Ensure GetIt is set up for tests

group('Story Detail Screen Integration Tests', () {
testWidgets('Initial story is displayed correctly', (WidgetTester tester) async {
await tester.pumpWidget(const MyApp());

      // Ensure that the StoriesScreen is loaded
      await tester.pumpAndSettle();

      // Verify that the StoriesScreen is displayed
      expect(find.byType(StoriesScreen), findsOneWidget);

      // Tap on the first story to open StoryDetailScreen
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Verify that the first story is displayed
      expect(find.byType(StoryDetailScreen), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Story auto-advance works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Ensure that the StoriesScreen is loaded
      await tester.pumpAndSettle();

      // Verify that the StoriesScreen is displayed
      expect(find.byType(StoriesScreen), findsOneWidget);

      // Tap on the first story to open StoryDetailScreen
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Wait for the auto-advance to trigger
      await tester.runAsync(() async {
        await Future.delayed(const Duration(seconds: 5));
      });
      await tester.pumpAndSettle();

      // Verify that the second story is displayed
      final storyDetailScreenFinder = find.byType(StoryDetailScreen);
      expect(storyDetailScreenFinder, findsOneWidget);

      final storyBloc = BlocProvider.of<StoryBloc>(tester.element(storyDetailScreenFinder));
      expect((storyBloc.state as StoryLoaded).currentStoryIndex, 1);
    });

    testWidgets('Manual navigation between stories works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Ensure that the StoriesScreen is loaded
      await tester.pumpAndSettle();

      // Verify that the StoriesScreen is displayed
      expect(find.byType(StoriesScreen), findsOneWidget);

      // Tap on the first story to open StoryDetailScreen
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Tap on the right side to go to the next story
      final size = tester.getSize(find.byType(GestureDetector).first);
      await tester.tapAt(Offset(size.width * 0.75, size.height / 2));
      await tester.pumpAndSettle();

      // Verify that the second story is displayed
      final storyDetailScreenFinder = find.byType(StoryDetailScreen);
      expect(storyDetailScreenFinder, findsOneWidget);

      final storyBloc = BlocProvider.of<StoryBloc>(tester.element(storyDetailScreenFinder));
      expect((storyBloc.state as StoryLoaded).currentStoryIndex, 1);

      // Tap on the left side to go back to the previous story
      await tester.tapAt(Offset(size.width * 0.25, size.height / 2));
      await tester.pumpAndSettle();

      // Verify that the first story is displayed again
      expect((storyBloc.state as StoryLoaded).currentStoryIndex, 0);
    });

    testWidgets('Story progress indicator updates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Ensure that the StoriesScreen is loaded
      await tester.pumpAndSettle();

      // Verify that the StoriesScreen is displayed
      expect(find.byType(StoriesScreen), findsOneWidget);

      // Tap on the first story to open StoryDetailScreen
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Wait for some time to let the progress indicator update
      await tester.runAsync(() async {
        await Future.delayed(const Duration(seconds: 3));
      });
      await tester.pumpAndSettle();

      // Verify that the progress indicator updates correctly
      final progressIndicator = tester.widget<StoryProgressIndicator>(
          find.byType(StoryProgressIndicator).first);
      expect(progressIndicator.progress > 0, true);
      expect(progressIndicator.progress < 1, true);
    });

    testWidgets('StoryDetailScreen pops after the last story', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Ensure that the StoriesScreen is loaded
      await tester.pumpAndSettle();

      // Verify that the StoriesScreen is displayed
      expect(find.byType(StoriesScreen), findsOneWidget);

      // Tap on the first story to open StoryDetailScreen
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Wait for the auto-advance to trigger until the last story
      await tester.runAsync(() async {
        await Future.delayed(const Duration(seconds: 10)); // Adjust if you have more stories
      });
      await tester.pumpAndSettle();

      // Verify that the StoryDetailScreen is popped and we are back to the StoriesScreen
      expect(find.byType(StoriesScreen), findsOneWidget);
    });
});
}


- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
