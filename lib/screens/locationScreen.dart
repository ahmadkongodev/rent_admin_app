import 'package:flutter/material.dart';
import 'package:test_api_node/services/clients_service.dart';
import 'package:test_api_node/services/locations_service.dart';

import '../models/api_response.dart';
import '../models/client.dart';
import '../models/location.dart';
import '../models/product.dart';
import '../services/products_service.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<dynamic> locationsList = [];
  String? productName;

  String? clientName;
  Product? produit;
  Client? client;
  Future<void> _updateLocationState(String? locationId, String? etat) async {
    ApiResponse response = await updateLocationState(locationId!, etat!);
    if (response.error == null) {
      setState(() {
        locationsList = response.data as List<dynamic>;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  Future<void> _showClient(String? clientId) async {
    ApiResponse response = await getClientById(clientId!);
    if (response.error == null) {
      setState(() {
        client = response.data as Client;
        clientName = "${client!.nom} ${client!.prenom}";
      });
    }
  }

  Future<void> _showProduit(String? productId) async {
    ApiResponse response = await showProduct(productId!);
    if (response.error == null) {
      setState(() {
        produit = response.data as Product;
        productName = "${produit!.nom}";
      });
    }
  }

  Future<void> _locations() async {
    ApiResponse response = await getLocations();
    if (response.error == null) {
      setState(() {
        locationsList = response.data as List<dynamic>;
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
    _locations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: locationsList.isEmpty
          ? const Center(
              child: Text("pas de LOCATIONS"),
            )
          : ListView.builder(
              itemCount: locationsList.length,
              itemBuilder: (BuildContext context, int index) {
                Location location = locationsList[index];
                _showClient(location.id_client);
                _showProduit(location.id_produit);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.7,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(255, 7, 201, 255),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(
                            "Date de location : ${location.date_debut} ",
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Date de remise prevue : ${location.date_fin}",
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "quantite louer : ${location.quantite_louer}",
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "produit louer : $productName",
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "client : $clientName",
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Etat : ${location.etat}",
                            style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              location.etat == "non remis"
                                  ? _updateLocationState(location.id, "remis")
                                  : _updateLocationState(
                                      location.id, "non remis");
                              _locations();
                            },
                            child: location.etat == "non remis"
                                ? const Text("Remis")
                                : const Text("non Remis"),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.1,
                    )
                  ],
                );
              },
            ),
    );
  }
}
