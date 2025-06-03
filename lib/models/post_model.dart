import 'package:equatable/equatable.dart';

class PostResponse extends Equatable {
  final List<Post> posts;
  final int total;
  final int skip;
  final int limit;

  const PostResponse({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      posts: (json['posts'] as List).map((post) => Post.fromJson(post)).toList(),
      total: json['total'] ?? 0,
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [posts, total, skip, limit];
}

class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;
  final PostReactions reactions;
  final bool? isLocal; // Flag to identify locally created posts

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    required this.tags,
    required this.reactions,
    this.isLocal,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      userId: json['userId'] ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : <String>[],
      reactions: json['reactions'] != null 
          ? PostReactions.fromJson(json['reactions']) 
          : const PostReactions(likes: 0, dislikes: 0),
      isLocal: json['isLocal'],
    );
  }

  // Factory method to create a local post
  factory Post.local({
    required String title,
    required String body,
    required int userId,
  }) {
    // Use negative ID for local posts to avoid conflicts with API posts
    return Post(
      id: -DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      userId: userId,
      tags: const [],
      reactions: const PostReactions(likes: 0, dislikes: 0),
      isLocal: true,
    );
  }

  @override
  List<Object?> get props => [id, title, body, userId, tags, reactions, isLocal];
}

class PostReactions extends Equatable {
  final int likes;
  final int dislikes;

  const PostReactions({
    required this.likes,
    required this.dislikes,
  });

  factory PostReactions.fromJson(Map<String, dynamic> json) {
    return PostReactions(
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [likes, dislikes];
}
