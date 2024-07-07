import '../entities/story.dart';
import '../repositories/story_repository.dart';

class GetStories {
  final StoryRepository repository;

  GetStories(this.repository);

  Future<List<Story>> call() async {
    return await repository.getStories();
  }
}