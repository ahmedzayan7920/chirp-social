import 'package:twitter_clone/core/enums/notification_type.dart';

class NotificationModel{
  final String id;
  final String text;
  final String tweetId;
  final String receiverId;
  final NotificationType type;

  const NotificationModel({
    required this.id,
    required this.text,
    required this.tweetId,
    required this.receiverId,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          tweetId == other.tweetId &&
          receiverId == other.receiverId &&
          type == other.type);

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ tweetId.hashCode ^ receiverId.hashCode ^ type.hashCode;

  @override
  String toString() {
    return 'NotificationModel{ id: $id, text: $text, tweetId: $tweetId, receiverId: $receiverId, type: $type,}';
  }

  NotificationModel copyWith({
    String? id,
    String? text,
    String? tweetId,
    String? receiverId,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      text: text ?? this.text,
      tweetId: tweetId ?? this.tweetId,
      receiverId: receiverId ?? this.receiverId,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'tweetId': tweetId,
      'receiverId': receiverId,
      'type': type.type,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['\$id'] as String,
      text: map['text'] as String,
      tweetId: map['tweetId'] as String,
      receiverId: map['receiverId'] as String,
      type: (map['type'] as String).toNotificationTypeEnum(),
    );
  }

}