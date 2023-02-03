abstract class AppWriteConstants {
  static const String databaseId = "63d2bbbf1e77321e7b7d";
  static const String projectId = "63d2aef074a16f7feb38";
  static const String endPoint = "http://10.0.2.2:80/v1";

  static const String usersCollectionId = "63d3ca8759838f98f7b8";
  static const String tweetsCollectionId = "63d42092caf9ea4130b9";
  static const String notificationsCollectionId = "63d79c00d75941a4eca2";

  static const String imagesBucketId = "63d42d4e378310d6efd0";

  static String imageUrl({required String imageId}) {
    return "$endPoint/storage/buckets/$imagesBucketId/files/$imageId/view?project=$projectId&mode=admin";
  }
}
