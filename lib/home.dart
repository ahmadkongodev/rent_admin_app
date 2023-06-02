import 'package:flutter/material.dart';
import 'package:test_api_node/login.dart';

import 'screens/clientsScreen.dart';
import 'screens/locationScreen.dart';

import 'package:test_api_node/screens/productsScreen.dart';

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Admin APP"),
            IconButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            },
            icon: Icon(Icons.logout)),
          ],
        ),
        centerTitle: true,
        
      ),
      body: currentIndex == 0
          ? ProductsScreen()
          : currentIndex == 1
              ? LocationScreen()
              : ClientsScreen(),
      bottomNavigationBar: BottomAppBar(
        child: BottomNavigationBar(
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'products'),
            BottomNavigationBarItem(
                icon: Icon(Icons.money), label: 'locations'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded), label: 'clients'),
          ],
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        ),
      ),
    );
  }
}
