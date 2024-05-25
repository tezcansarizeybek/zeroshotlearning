import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeroshotmobile/data/network/api/zsl_repository.dart';
import 'package:zeroshotmobile/model/request_model.dart';

class MainController extends GetxController {
  Rx<File?> image = File("").obs;
  var textList = <Map<String, dynamic>>[].obs;

  final picker = ImagePicker();

  pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  addClass(TextEditingController controller) {
    if (textList.where((e) => e["class"] == controller.text).isEmpty) {
      textList.add({"class": controller.text});
      controller.text = "";
    }
  }

  deleteClasses([String? cls]) {
    if (cls == null) {
      textList.assignAll([]);
    } else {
      textList.removeWhere((e) => e["class"] == cls);
    }
  }

  predict(textController) async {
    if (image.value == null) {
      return;
    }

    final bytes = image.value!.readAsBytesSync();
    final base64Image = base64Encode(bytes);

    ZSLRepository zslRepository = ZSLRepository();

    var list = <String>[];

    for (var element in textList) {
      list.add(element["class"]);
    }

    RequestModel requestModel = RequestModel(image: base64Image, text: list);

    final response = await zslRepository.getZSLPrompt(requestModel.toRawJson());
    if (response.statusCode == 200) {
      final responseData = response.data;
      if (responseData.length > 0) {
        for (var i = 0; i < responseData[0].length; i++) {
          var element = textList.elementAt(i);
          element["pred"] = double.tryParse(
                  (double.tryParse(responseData[0][i].toString()) ?? 0)
                      .toStringAsFixed(2)) ??
              0;
          textList.replaceRange(i, i + 1, [element]);
        }
      }
    } else {
      throw Exception('Failed to load prediction');
    }
  }
}
