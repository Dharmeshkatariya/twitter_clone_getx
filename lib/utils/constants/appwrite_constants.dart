class AppwriteConstants {
  static const String databaseId = '659a1d20bfd1121ec5e8';
  static const String projectId = '65991b72ab830554fda4';
  static const String endPoint = 'https://cloud.appwrite.io/v1';
  static const String usersCollection = '659a1d35ba220fe07921';
  static const String tweetsCollection = '659a1d51da6d9674009f';
  static const String notificationsCollection = '659a1d6334a2ca2a6452';

  static const String imagesBucket = '659a6bf4accc0bd0eb5b';
  static const String images = 'https://images.unsplash.com/photo-1704168370831-b7f450dadeb0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHx8';


  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
