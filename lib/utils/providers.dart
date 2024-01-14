import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';

import 'constants/appwrite_constants.dart';


class GlobalController extends GetxController {
  late Client appwriteClient;
  late Account appwriteAccount;
  late Databases appwriteDatabase;
  late Storage appwriteStorage;
  late Realtime appwriteRealtime;

  @override
  void onInit() {
    super.onInit();
    appwriteClient = Client()
        .setEndpoint(AppwriteConstants.endPoint)
        .setProject(AppwriteConstants.projectId)
        .setSelfSigned(status: true);
    appwriteAccount = Account(appwriteClient);
    appwriteDatabase = Databases(appwriteClient);
    appwriteStorage = Storage(appwriteClient);
    appwriteRealtime = Realtime(appwriteClient);
  }
}
