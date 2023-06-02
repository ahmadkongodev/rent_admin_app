import 'package:flutter/material.dart';
import 'package:test_api_node/screens/addProduct.dart';
import 'package:test_api_node/services/locations_service.dart';
import '../home.dart';
import '../models/api_response.dart';

import '../models/product.dart';
import '../services/products_service.dart';
import 'updateProduct.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<dynamic> productsList = [];

  Future<void> products() async {
    ApiResponse response = await getProducts();
    if (response.error == null) {
      setState(() {
        productsList = response.data as List<dynamic>;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  Future<void> delete(idProduit) async {
    ApiResponse response = await deleteProduct(idProduit);

    if (response.error == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('product deleted successfully, the concerned location has been deleted too'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  void initState() {
    products();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: productsList.isEmpty
          ? Center(
              child: Text("pas de produits"),
            )
          : ListView.builder(
              itemCount: productsList.length,
              itemBuilder: (BuildContext context, int index) {
                Product product = productsList[index];
                return ListTile(
                    leading: product.image!.isEmpty
                      ? null
                      : CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.05,
                          child: Image.network(
                            '${product.image}',
                            fit: BoxFit.fill,
                          ),
                        ),
                  title: Text('${product.nom} '),
                  subtitle: Text('${product.description}'),
                  trailing: SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        InkWell(
                          child: const Icon(Icons.edit),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UpdateProduct(
                                  id: '${product.id}',
                                ),
                              ),
                            );
                          },
                        ),
                        InkWell(
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () {
                            delete(product.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddProduct()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
