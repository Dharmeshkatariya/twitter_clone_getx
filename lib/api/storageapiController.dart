import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:demo_appwrite_all_query/utils/providers.dart';
import 'package:get/get.dart';

import '../utils/constants/appwrite_constants.dart';


class StorageAPIController extends GetxController{
  late final Storage _storage;


  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile(path: file.path),
      );
      imageLinks.add(
        AppwriteConstants.imageUrl(uploadedImage.$id),
      );
    }
    return imageLinks;
  }

  final globalController  = Get.put(GlobalController()) ;
  @override
  void onInit() {
    _storage  = globalController.appwriteStorage  ;
    // TODO: implement onInit
    super.onInit();
  }
}
