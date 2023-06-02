import 'package:http/http.dart' as http;
import 'package:test_api_node/models/client.dart';
import 'dart:convert';

import '../constants.dart';
import '../models/api_response.dart';

Future<ApiResponse> getClients() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse(clientURL));
    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            jsonDecode(response.body).map((e) => Client.fromJson(e)).toList();
        break;
      case 401:
        apiResponse.error = "unauthorized";
        break;
      default:
        apiResponse.error = "somethingWentWrong";
        break;
    }
  } catch (e) {
    print('erreur: $e');
    apiResponse.error = "serverError";
  }
  return apiResponse;
}

Future<ApiResponse> getClientById(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse('$clientURL/$id'));
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Client.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = "unauthorized";
        break;
      default:
        apiResponse.error = "somethingWentWrong";
        break;
    }
  } catch (e) {
    print('erreur: get with id $e');
    apiResponse.error = "serverError";
  }
  return apiResponse;
}
