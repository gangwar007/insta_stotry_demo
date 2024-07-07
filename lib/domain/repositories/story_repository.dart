import '../entities/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories();
}