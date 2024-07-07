import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:insta_stotry_demo/presentation/bloc/story_event.dart';
import 'package:provider/provider.dart';
import 'data/data_sources/story_remote_data_source.dart';
import 'data/repositories/story_repository_impl.dart';
import 'domain/repositories/story_repository.dart';
import 'domain/usecases/get_stories.dart';
import 'presentation/bloc/story_bloc.dart';
import 'presentation/pages/stories_screen.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Bloc
  sl.registerFactory(() => StoryBloc(getStories: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetStories(sl()));

  // Repository
  sl.registerLazySingleton<StoryRepository>(() =>
      StoryRepositoryImpl(remoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<StoryRemoteDataSource>(() =>
      StoryRemoteDataSourceImpl());
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => sl<StoryBloc>()),
      ],
      child: BlocProvider(
          create: (context) => sl<StoryBloc>()..add(FetchStories()),
        child: MaterialApp(
          title: 'Instagram Stories',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: StoriesScreen(),
        ),
      ),
    );
  }
}