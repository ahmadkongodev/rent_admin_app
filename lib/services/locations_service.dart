import 'package:http/http.dart' as http;
import 'package:test_api_node/models/location.dart';
import 'dart:convert';

import '../constants.dart';
import '../models/api_response.dart';

Future<ApiResponse> getLocations() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse(locationURL));
    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            jsonDecode(response.body).map((e) => Location.fromJson(e)).toList();
        break;
      default:
        apiResponse.error = "somethingWentWrong";
        break;
    }
  } catch (e) {
    print('erreur:  fetching locayion $e');
    apiResponse.error = "serverError";
  }
  return apiResponse;
}

Future<ApiResponse> updateLocationState(String id, String etat) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // String token = await getToken();

    final response = await http.patch(Uri.parse('$locationURL/$id'),
        /* headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },*/
        body: {'etat': etat});
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 404:
        apiResponse.error = jsonDecode(response.body)['error']['message'];
        break;

      default:
        apiResponse.error = "somethingWentWrong";
        break;
    }
  } catch (e) {
    print("erreur $e");
    apiResponse.error = "serverError";
  }
  return apiResponse;
}

Future<ApiResponse> deleteLocationByProductId(String idProduit) async {
  ApiResponse apiResponse = ApiResponse();
  try {

    final response = await http.delete(Uri.parse('$locationURL/produit/$idProduit')
        );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      default:
        apiResponse.error = "somethingWentWrong";
        break;
    }
  } catch (e) {
    print("erreur $e");

    apiResponse.error = "serverError";
  }
  return apiResponse;
}
