import 'package:equatable/equatable.dart';
import '../../domain/entities/story.dart';

abstract class StoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryLoaded extends StoryState {
  final List<Story> stories;
  final int currentStoryIndex;

  StoryLoaded({required this.stories, required this.currentStoryIndex});

  @override
  List<Object> get props => [stories, currentStoryIndex];
}

class StoryError extends StoryState {
  final String message;

  StoryError({required this.message});

  @override
  List<Object> get props => [message];
}