import '../core/enums/tweet_type.dart';

class TweetModel {
  final String id;
  final String userId;
  final String text;
  final String link;
  final List<String> hashtags;
  final List<String> images;
  final int tweetedAt;
  final TweetType type;
  final List<String> likes;
  final List<String> commentIds;
  final int retweetCount;
  final String retweetedBy;
  final String replayedToTweetId;

  const TweetModel({
    required this.id,
    required this.userId,
    required this.text,
    required this.link,
    required this.hashtags,
    required this.images,
    required this.tweetedAt,
    required this.type,
    required this.likes,
    required this.commentIds,
    required this.retweetCount,
    required this.retweetedBy,
    required this.replayedToTweetId,
  });

  factory TweetModel.newText({
    required String userId,
    required String text,
    required String link,
    required List<String> hashtags,
    required String replayedToTweetId,
  }) {
    return TweetModel(
      id: "",
      userId: userId,
      text: text,
      link: link,
      hashtags: hashtags,
      images: [],
      tweetedAt: DateTime.now().millisecondsSinceEpoch,
      type: TweetType.text,
      likes: [],
      commentIds: [],
      retweetCount: 0,
      retweetedBy: "",
      replayedToTweetId: replayedToTweetId,
    );
  }

  factory TweetModel.newImage({
    required String userId,
    required String text,
    required String link,
    required List<String> hashtags,
    required List<String> images,
    required String replayedToTweetId,
  }) {
    return TweetModel(
      id: "",
      userId: userId,
      text: text,
      link: link,
      hashtags: hashtags,
      images: images,
      tweetedAt: DateTime.now().millisecondsSinceEpoch,
      type: TweetType.image,
      likes: [],
      commentIds: [],
      retweetCount: 0,
      retweetedBy: "",
      replayedToTweetId: replayedToTweetId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TweetModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          text == other.text &&
          link == other.link &&
          hashtags == other.hashtags &&
          images == other.images &&
          tweetedAt == other.tweetedAt &&
          type == other.type &&
          likes == other.likes &&
          commentIds == other.commentIds &&
          retweetCount == other.retweetCount &&
          retweetedBy == other.retweetedBy&&
          replayedToTweetId == other.replayedToTweetId);

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      text.hashCode ^
      link.hashCode ^
      hashtags.hashCode ^
      images.hashCode ^
      tweetedAt.hashCode ^
      type.hashCode ^
      likes.hashCode ^
      commentIds.hashCode ^
      retweetCount.hashCode^
      retweetedBy.hashCode^
      replayedToTweetId.hashCode;

  @override
  String toString() {
    return 'TweetModel{ id: $id, userId: $userId, text: $text, link: $link, hashtags: $hashtags, images: $images, tweetedAt: $tweetedAt, type: $type, likes: $likes, commentIds: $commentIds, retweetCount: $retweetCount,, retweetedBy: $retweetedBy}';
  }

  TweetModel copyWith({
    String? id,
    String? userId,
    String? text,
    String? link,
    List<String>? hashtags,
    List<String>? images,
    int? tweetedAt,
    TweetType? type,
    List<String>? likes,
    List<String>? commentIds,
    int? retweetCount,
    String? retweetedBy,
    String? replayedToTweetId,
  }) {
    return TweetModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      link: link ?? this.link,
      hashtags: hashtags ?? this.hashtags,
      images: images ?? this.images,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      type: type ?? this.type,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      retweetCount: retweetCount ?? this.retweetCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
      replayedToTweetId: replayedToTweetId ?? this.replayedToTweetId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'link': link,
      'hashtags': hashtags,
      'images': images,
      'tweetedAt': tweetedAt,
      'type': type.type,
      'likes': likes,
      'commentIds': commentIds,
      'retweetCount': retweetCount,
      'retweetedBy': retweetedBy,
      'replayedToTweetId': replayedToTweetId,
    };
  }

  factory TweetModel.fromMap(Map<String, dynamic> map) {
    return TweetModel(
      id: map['\$id'] as String,
      userId: map['userId'] as String,
      text: map['text'] as String,
      link: map['link'] as String,
      hashtags: List<String>.from(map['hashtags']),
      images: List<String>.from(map['images']),
      tweetedAt: map['tweetedAt'] as int,
      type: (map['type'] as String).toTweetTypeEnum(),
      likes: List<String>.from(map['likes']),
      commentIds: List<String>.from(map['commentIds']),
      retweetCount: map['retweetCount'] as int,
      retweetedBy: map['retweetedBy'] as String,
      replayedToTweetId: map['replayedToTweetId'] as String,
    );
  }
}
