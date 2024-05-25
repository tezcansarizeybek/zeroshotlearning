import 'dart:developer';

import 'package:zeroshotmobile/data/service/api_service.dart';

class ZSLRepository {
  final ApiService _apiService = ApiService();

  /// Gets prompt from api with given [data]
  getZSLPrompt(dynamic data) async {
    try {
      final response =
          await _apiService.post("${_apiService.baseUrl}/predict", data: data);
      return response;
    } catch (e) {
      log("Error: $e");
      rethrow;
    }
  }
}
