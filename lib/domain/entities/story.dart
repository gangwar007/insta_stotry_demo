import 'package:equatable/equatable.dart';

class Story extends Equatable {
  final String id;
  final String imageUrl;
  final String title;

  Story({required this.id, required this.imageUrl, required this.title});

  @override
  List<Object> get props => [id, imageUrl, title];
}