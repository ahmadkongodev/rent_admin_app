import 'package:flutter/material.dart';
import 'package:test_api_node/services/clients_service.dart';

import '../models/api_response.dart';
import '../models/client.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  List<dynamic> clientsList = [];

  Future<void> clients() async {
    ApiResponse response = await getClients();
    if (response.error == null) {
      setState(() {
        clientsList = response.data as List<dynamic>;
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
    clients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: clientsList.isEmpty
          ? const Center(
              child: Text("pas de clients"),
            )
          : ListView.builder(
              itemCount: clientsList.length,
              itemBuilder: (BuildContext context, int index) {
                Client client = clientsList[index];
                return ListTile(
                  leading: const Icon(Icons.supervised_user_circle),
                  title: Text('${client.nom} ${client.prenom} '),
                  subtitle: Text('${client.address} ${client.numero}'),
                );
              },
            ),
    );
  }
}
