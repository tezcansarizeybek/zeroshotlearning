import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zeroshotmobile/modules/main/main_controller.dart';
import 'package:zeroshotmobile/shared/constants/index.dart';
import 'package:zeroshotmobile/shared/extensions/paddings.dart';

class MainPage extends StatelessWidget {
  final textController = TextEditingController();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.ZSL),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: <Widget>[
              Obx(() => Get.find<MainController>().image.value == null ||
                      Get.find<MainController>().image.value!.path == ""
                  ? Padding(
                      padding: 8.padAll,
                      child: const Text(AppStrings.NOIMAGE),
                    )
                  : Padding(
                      padding: 16.padAll,
                      child:
                          Image.file(Get.find<MainController>().image.value!),
                    )),
              Padding(
                padding: 8.padHorizontal,
                child: ElevatedButton(
                  onPressed: () => Get.find<MainController>().pickImage(),
                  child: const Text(AppStrings.PICKIMAGE),
                ),
              ),
              Padding(
                padding: 12.padAll,
                child: TextField(
                  controller: textController,
                  decoration:
                      const InputDecoration(labelText: AppStrings.ENTERDESC),
                ),
              ),
              Padding(
                padding: 8.padAll,
                child: ElevatedButton(
                  onPressed: () =>
                      Get.find<MainController>().addClass(textController),
                  child: const Text(AppStrings.ADDCLASS),
                ),
              ),
              Padding(
                padding: 8.padAll,
                child: ElevatedButton(
                  onPressed: () => Get.find<MainController>().deleteClasses(),
                  child: const Text(AppStrings.DELETECLASSES),
                ),
              ),
              Padding(
                padding: 8.padAll,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      Get.dialog(
                          Dialog(
                              child: SizedBox(
                            height: Get.size.width / 3,
                            width: Get.size.width / 3,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          )),
                          barrierDismissible: false);
                      await Get.find<MainController>().predict(textController);
                    } catch (e) {
                    } finally {
                      Get.back();
                    }
                  },
                  child: const Text(AppStrings.PREDICT),
                ),
              ),
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var text =
                          Get.find<MainController>().textList.elementAt(index);
                      return ListTile(
                        title: Text(text["class"]),
                        trailing: Text("${text["pred"] ?? ""}"),
                        tileColor: (text["pred"] ?? 0) > 0.30
                            ? Colors.greenAccent
                            : Colors.red,
                        onTap: () {
                          Get.dialog(AlertDialog(
                            title: Text(
                                "${text["class"]} ${AppStrings.SHOULDREMOVE}"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Get.find<MainController>()
                                        .deleteClasses(text["class"]);
                                    Get.back();
                                  },
                                  child: const Text(AppStrings.YES)),
                              ElevatedButton(
                                  onPressed: () => Get.back(),
                                  child: const Text(AppStrings.NO))
                            ],
                          ));
                        },
                      );
                    },
                    itemCount: Get.find<MainController>().textList.length,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
