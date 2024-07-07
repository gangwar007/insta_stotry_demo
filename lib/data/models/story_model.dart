import '../../domain/entities/story.dart';

class StoryModel extends Story {
  StoryModel({required String id, required String imageUrl, required String title})
      : super(id: id, imageUrl: imageUrl, title: title);

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'],
      imageUrl: json['imageUrl'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
    };
  }
}