import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import '../models/tweet_model.dart';
import '../utils/constants/appwrite_constants.dart';
import '../utils/providers.dart';

class TweetAPIController extends GetxController {
  late final Databases _db;
  late final Realtime _realtime;

  final _tweets = <Document>[].obs;

  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.equal('repliedTo', tweet.id),
      ],
    );
    return document.documents;
  }

  shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      var umap = document.data;
      var twee = Tweet.fromMap(umap);
      return twee;
      // Use RxList to update the observable list
      _tweets.add(document);
    } on AppwriteException catch (e, st) {
      // Handle exceptions
      print(e.toString());
      Get.snackbar('Error', e.message.toString());
    } catch (e, st) {
      print(e.toString());

      Get.snackbar('Error', e.toString());
    }
  }

  // Future<List<Tweet>> getTweets() async {
  //   final documents = await _db.listDocuments(
  //     databaseId: AppwriteConstants.databaseId,
  //     collectionId: AppwriteConstants.tweetsCollection,
  //     queries: [
  //       Query.orderDesc('tweetedAt'),
  //     ],
  //   );
  //
  //   // Use map to convert List<Document> to List<Tweet>
  //   final tweets =
  //       documents.documents.map((doc) => Tweet.fromMap(doc.data)).toList();
  //
  //   return tweets;
  // }
  Future<List<Tweet>> getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      // Remove the Query.orderDesc('tweetedAt') to get all tweets without ordering
    );

    // Use map to convert List<Document> to List<Tweet>
    final tweets = documents.documents.map((doc) => Tweet.fromMap(doc.data)).toList();
    print(tweets.length);
    return tweets;
  }

  Future<List<Tweet>> getTweetsPaginated(int page, int limit) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      // Calculate the offset based on the page and limit
      queries: [
        Query.orderDesc('tweetedAt'),
        Query.limit(limit),
        // Query.offset(page),
        Query.offset(page * limit), // Correctly calculate the offset
      ],
    );

    // Use map to convert List<Document> to List<Tweet>
    final tweets =
    documents.documents.map((doc) => Tweet.fromMap(doc.data)).toList();

    return tweets;
  }

  Stream<Map<String, dynamic>> getLatestTweet() {
    return _realtime
        .subscribe([
          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents'
        ])
        .stream
        .map((RealtimeMessage message) {
          // Convert RealtimeMessage to Map<String, dynamic>
          Map<String, dynamic> eventData =
              json.decode(message.payload.toString());
          return eventData;
        });
  }

  Stream<RealtimeMessage> getLatestTweetRealtime() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents'
    ]).stream;
  }

  likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'likes': tweet.likes,
        },
      );
      var umap = document.data;
      var twee = Tweet.fromMap(umap);
      return twee;
      // // Update the specific tweet in the list
      // final index = _tweets.indexWhere((t) => t.$id == tweet.id);
      // if (index != -1) {
      //   _tweets[index] = document;
      // }
    } on AppwriteException catch (e, st) {
      Get.snackbar('Error', e.message.toString());
    } catch (e, st) {
      Get.snackbar('Error', e.toString());
    }
  }

   updateReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'reshareCount': tweet.reshareCount,
        },
      );
      var umap = document.data;
      var twee = Tweet.fromMap(umap);
      return twee;
      // // Update
    } on AppwriteException catch (e, st) {
      Get.snackbar('Error', e.message.toString());
    } catch (e, st) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
  //   final document = await _db.listDocuments(
  //     databaseId: AppwriteConstants.databaseId,
  //     collectionId: AppwriteConstants.tweetsCollection,
  //     queries: [
  //       Query.equal('repliedTo', tweet.id),
  //     ],
  //   );
  //   var data =  document.documents;
  //   var newmap = data.
  // }
  Future<List<Tweet>> getRepliesToTweetTo(Tweet tweet) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.equal('repliedTo', tweet.id),
      ],
    );

    var data = document.documents;

    // Map each document to a Tweet object
    var tweets = data.map((doc) => Tweet.fromMap(doc.data)).toList();
    print("reply : ${tweets}");
    return tweets;
  }

  Future<Document> getTweetById(String id) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      documentId: id,
    );
  }

  Future<List<Document>> getUserTweets(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documents.documents;
  }

  Future<List<Document>> getTweetsByHashtag(String hashtag) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.search('hashtags', hashtag),
      ],
    );
    return documents.documents;
  }

  final globalController = Get.put(GlobalController());

  @override
  void onInit() {
    _db = globalController.appwriteDatabase;
    _realtime = globalController.appwriteRealtime;
    getTweets();
    // TODO: implement onInit
    super.onInit();
  }
}
