import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:insta_stotry_demo/main.dart';
import 'package:insta_stotry_demo/presentation/bloc/story_bloc.dart';

import 'package:insta_stotry_demo/presentation/bloc/story_state.dart';
import 'package:insta_stotry_demo/presentation/pages/stories_screen.dart';
import 'package:insta_stotry_demo/presentation/pages/story_detail_screen.dart';
import 'package:insta_stotry_demo/presentation/pages/story_progress_indicator.dart';
import 'package:integration_test/integration_test.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  group('Story Detail Screen Integration Tests', () {
    testWidgets('Initial story is displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      // Ensure that the StoriesScreen is loaded
      await tester.pumpAndSettle();

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
      await tester.pump(const Duration(seconds: 5));
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

      // Tap on the first story to open StoryDetailScreen
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Tap on the right side to go to the next story
      final size = tester.getSize(find.byType(GestureDetector).first);
      await tester.tapAt(Offset(size.width * 0.75, size.height / 2));
      await tester.pumpAndSettle();

      // Verify that the second story is displayed
      final storyBloc = BlocProvider.of<StoryBloc>(tester.element(find.byType(StoryDetailScreen)));
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

      // Tap on the first story to open StoryDetailScreen
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Wait for some time to let the progress indicator update
      await tester.pumpAndSettle(const Duration(seconds: 3));

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

      // Tap on the first story to open StoryDetailScreen
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Wait for the auto-advance to trigger until the last story
      await tester.pumpAndSettle(const Duration(seconds: 5)); // Adjust if you have more stories

      // Verify that the StoryDetailScreen is popped and we are back to the StoriesScreen
      expect(find.byType(StoriesScreen), findsOneWidget);
    });
  });
}