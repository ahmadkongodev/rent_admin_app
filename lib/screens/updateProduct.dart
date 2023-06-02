import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_api_node/main.dart';
import 'package:test_api_node/services/products_service.dart';

import '../constants.dart';
import '../home.dart';
import '../models/api_response.dart';
import '../models/product.dart';

class UpdateProduct extends StatefulWidget {
  UpdateProduct({super.key, required this.id});
  String id;
  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productQuantityController =
      TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  
  static const List<String> listProduits = <String>[
    'Bache',
    'Chaise',
    'Table',
    'Podium'
  ];
  String imageURL = '';
  String dropdownValue = 'Bache';
  Product? product;
  //show customer
  Future<void> show() async {
    ApiResponse response = await showProduct(widget.id);
    if (response.error == null) {
      setState(() {
        product = response.data as Product;
        imageURL = product!.image.toString();
        dropdownValue = product!.nom.toString();
        productDescriptionController.text = product!.description.toString();
        productQuantityController.text = product!.quantite.toString();
        productPriceController.text = product!.prix.toString();
      });
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
    show();
    super.initState();
  }
  

  void _updateProduct() async {
    ApiResponse response = await updateProduct(
        widget.id,
        imageURL,
        productNameController.text,
        productDescriptionController.text,
        int.parse(productQuantityController.text),
        int.parse(productPriceController.text));

    if (response.error == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('product updated successfully'),
        ),
      );
    }
    // else if (response.error == "unauthorized") {
    //   logout().then((value) => {
    //         Navigator.of(context).pushAndRemoveUntil(
    //             MaterialPageRoute(builder: (context) => const Login()),
    //             (route) => false),
    //       });
    //
    // }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            child: imageURL == ''
                ? null
                : Image.network(
                    '$imageURL',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
          ),
          Center(
            child: IconButton(
              onPressed: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                print('le path: ${file?.path}');
                if (file != null) {
                  ScaffoldMessenger.of(context).showSnackBar( 
                    SnackBar(
                      content: Text('the image is uploading.'),
                    ),
                  );

                  Reference referenceImageToUpload =
                      FirebaseStorage.instance.refFromURL(imageURL);
                  try {
                    await referenceImageToUpload.putFile(File(file.path));
                    imageURL = await referenceImageToUpload.getDownloadURL();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('finish to upload the image.'),
                      ),
                    );
                    setState(() {
                      imageURL = imageURL;
                    });
                  } catch (e) {
                    print('mon erreur :$e');
                  }
                } else {
                  print('fichier non piquer');
                }
              },
              icon: const Icon(
                Icons.image,
                size: 50,
                color: Colors.black38,
              ),
            ),
          ),
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Select the Product Name"),
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: listProduits
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // TextFormField(
                  //   validator: (value) =>
                  //       value!.isEmpty ? 'the product name is required' : null,
                  //   decoration: kInputDecoration('Product name'),
                  //   controller: productNameController,
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: (value) => value!.isEmpty
                        ? 'the Product description is required'
                        : null,
                    decoration: kInputDecoration('Product description'),
                    controller: productDescriptionController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty
                        ? 'the product quantity is required'
                        : null,
                    decoration: kInputDecoration('Product quantity'),
                    controller: productQuantityController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'the Product price is required' : null,
                    decoration: kInputDecoration('Good unit price'),
                    controller: productPriceController,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: kTextButton("update", () {
              // if (imageURL == '') {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text(
              //           'Please select an Image, if you already select one, wait for the complete upload.'),
              //     ),
              //   );
              // } else {
              if (_formkey.currentState!.validate()) {
                _updateProduct();
              }
              // }
            }),
          ),
        ],
      ),
    );
  }
}
