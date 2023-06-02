import 'dart:convert';

import 'package:test_api_node/services/locations_service.dart';

import '../constants.dart';
import '../models/api_response.dart';
import '../models/product.dart';

import 'package:http/http.dart' as http;

Future<ApiResponse> getProducts() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(Uri.parse(productURL));
    switch (response.statusCode) {
      case 200:
        apiResponse.data =
            jsonDecode(response.body).map((e) => Product.fromJson(e)).toList();
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

//insert a good

Future<ApiResponse> insertProduct(String image, String productName,
    String productDescription, int productQuantity, int productPrice) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // String token = await getToken();

    final response = await http.post(Uri.parse(productURL),
        /* headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },*/
        body: {
          'image': image,
          'nom': productName,
          'description': productDescription,
          'quantite': productQuantity.toString(),
          'prix': productPrice.toString()
        });
    switch (response.statusCode) {
      case 200:

        // final responseString = await response.stream.bytesToString();
        // final jsonResponse = json.decode(responseString);
        apiResponse.data = jsonDecode(response.body);
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

//update Good
Future<ApiResponse> updateProduct(String id, String image, String nom,
    String description, int quantite, int prix) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // String token = await getToken();

    final response = await http.patch(Uri.parse('$productURL/$id'),
        /* headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },*/
        body: {
          'image': image,
          'nom': nom,
          'description': description,
          'quantite': quantite.toString(),
          'prix': prix.toString()
        });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 404:
        apiResponse.error = jsonDecode(response.body)['error']['message'];
        break;
      case 401:
        apiResponse.error = "unauthorized";
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

//delete Good
Future<ApiResponse> deleteProduct(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // suppression de la location concerner
    deleteLocationByProductId(id);
    final response = await http.delete(Uri.parse('$productURL/$id'));
    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = "unauthorized";
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

//show customer
Future<ApiResponse> showProduct(String id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    //String token = await getToken();

    final response = await http.get(
      Uri.parse(
          '$productURL/$id'), /* headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }*/
    );
    switch (response.statusCode) {
      case 200:
        apiResponse.data = Product.fromJson(jsonDecode(response.body));
        //we got a list of customers so we need to map each  item to customer model
        break;
      case 401:
        apiResponse.error = "unauthorized";
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
