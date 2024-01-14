import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/common/loading_page.dart';
import '../../../../utils/theme/pallete.dart';
import '../controller/explore_controller.dart';
import '../widgets/search_tile.dart';

class ExploreView extends GetView<ExploreController> {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
        color: Pallete.searchBarColor,
      ),
    );
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 30,
          child: TextField(
            controller: controller.searchController,
            onSubmitted: (value) async{
              controller.isShowUsers.value = true;

              // controller.  userlist.value.clear() ;

             await controller.searchUser(controller.searchController.text);

            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10).copyWith(
                left: 20,
              ),
              fillColor: Pallete.searchBarColor,
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
              hintText: 'Search Twitter',
            ),
          ),
        ),
      ),
      body:
           controller.userlist.value.isNotEmpty
          ? ListView.builder(
        itemCount: controller.userlist.value.length,
        itemBuilder: (BuildContext context, int index) {
          final user = controller.userlist.value[index];
          return SearchTile(userModel: user);
        },
      )
          : controller.isLoading.value ? const Loader() : SizedBox()

    ));
  }
}
