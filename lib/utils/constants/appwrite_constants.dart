class AppwriteConstants {
  static const String databaseId = '';
  static const String projectId = '';
  static const String endPoint = '';
  static const String usersCollection = '';
  static const String tweetsCollection = '';
  static const String notificationsCollection = '';

  static const String imagesBucket = '';
  static const String images = 'https://images.unsplash.com/photo-1704168370831-b7f450dadeb0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHx8';


  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
