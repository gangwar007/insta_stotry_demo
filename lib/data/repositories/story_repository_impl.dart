import '../../domain/entities/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../data_sources/story_remote_data_source.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remoteDataSource;

  StoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Story>> getStories() async {
    return await remoteDataSource.fetchStories();
  }
}