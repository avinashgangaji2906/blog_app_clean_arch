part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

class BlogUploadEvent extends BlogEvent {
  final String posterId;
  final String title;
  final File imageUrl;
  final String content;
  final List<String> topics;

  BlogUploadEvent(
      {required this.posterId,
      required this.title,
      required this.imageUrl,
      required this.content,
      required this.topics});
}
