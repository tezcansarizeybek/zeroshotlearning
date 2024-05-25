import 'dart:convert';

class RequestModel {
  String image;
  List<String> text;

  RequestModel({
    required this.image,
    required this.text,
  });

  factory RequestModel.fromRawJson(String str) =>
      RequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        image: json["image"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "text": text,
      };
}
