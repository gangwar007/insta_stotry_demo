import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'story_event.dart';
import 'story_state.dart';
import '../../domain/usecases/get_stories.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final GetStories getStories;

  StoryBloc({required this.getStories}) : super(StoryInitial()) {
    on<FetchStories>(_onFetchStories);
    on<NextStory>(_onNextStory);
    on<PreviousStory>(_onPreviousStory);
    on<SetCurrentStory>(_onSetCurrentStory);
  }

  void _onFetchStories(FetchStories event, Emitter<StoryState> emit) async {
    emit(StoryLoading());

    try {
      final stories = await getStories();
      emit(StoryLoaded(stories: stories, currentStoryIndex: 0));
    } catch (e) {
      emit(StoryError(message: e.toString()));
    }
  }

  void _onNextStory(NextStory event, Emitter<StoryState> emit) {
    final currentState = state;
    if (currentState is StoryLoaded && currentState.currentStoryIndex < currentState.stories.length - 1) {
      emit(StoryLoaded(
          stories: currentState.stories, currentStoryIndex: currentState.currentStoryIndex + 1));
    }
  }

  void _onPreviousStory(PreviousStory event, Emitter<StoryState> emit) {
    final currentState = state;
    if (currentState is StoryLoaded && currentState.currentStoryIndex > 0) {
      emit(StoryLoaded(
          stories: currentState.stories, currentStoryIndex: currentState.currentStoryIndex - 1));
    }
  }

  void _onSetCurrentStory(SetCurrentStory event, Emitter<StoryState> emit) {
    final currentState = state;
    if (currentState is StoryLoaded) {
      emit(StoryLoaded(stories: currentState.stories, currentStoryIndex: event.index));
    }
  }
}