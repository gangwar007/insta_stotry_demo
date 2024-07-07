import 'package:equatable/equatable.dart';

abstract class StoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchStories extends StoryEvent {}

class NextStory extends StoryEvent {}

class PreviousStory extends StoryEvent {}

class SetCurrentStory extends StoryEvent {
  final int index;

  SetCurrentStory(this.index);

  @override
  List<Object> get props => [index];
}