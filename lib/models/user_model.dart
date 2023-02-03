import 'package:twitter_clone/core/utils.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePicture;
  final String coverPicture;
  final String bio;
  final bool isVerified;
  final List<String> followers;
  final List<String> followings;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.coverPicture,
    required this.bio,
    required this.isVerified,
    required this.followers,
    required this.followings,
  });

  factory UserModel.empty({required String email, required String id,}) {
    return UserModel(
      id: id,
      name: AppUtils.getNameFromEmail(email),
      email: email,
      profilePicture: "https://www.pngfind.com/pngs/m/676-6764065_default-profile-picture-transparent-hd-png-download.png",
      coverPicture: "",
      bio: "",
      isVerified: false,
      followers: [],
      followings: [],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          profilePicture == other.profilePicture &&
          coverPicture == other.coverPicture &&
          bio == other.bio &&
          isVerified == other.isVerified &&
          followers == other.followers &&
          followings == other.followings);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      profilePicture.hashCode ^
      coverPicture.hashCode ^
      bio.hashCode ^
      isVerified.hashCode ^
      followers.hashCode ^
      followings.hashCode;

  @override
  String toString() {
    return 'UserModel{ id: $id, name: $name, email: $email, profilePicture: $profilePicture, coverPicture: $coverPicture, bio: $bio, isVerified: $isVerified, followers: $followers, followings: $followings,}';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePicture,
    String? coverPicture,
    String? bio,
    bool? isVerified,
    List<String>? followers,
    List<String>? followings,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      coverPicture: coverPicture ?? this.coverPicture,
      bio: bio ?? this.bio,
      isVerified: isVerified ?? this.isVerified,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'coverPicture': coverPicture,
      'bio': bio,
      'isVerified': isVerified,
      'followers': followers,
      'followings': followings,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profilePicture: map['profilePicture'] as String,
      coverPicture: map['coverPicture'] as String,
      bio: map['bio'] as String,
      isVerified: map['isVerified'] as bool,
      followers:List<String>.from(map['followers']),
      followings:List<String>.from(map['followings']),
    );
  }
}
