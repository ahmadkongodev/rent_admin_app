import 'package:flutter/material.dart';

const baseURL = 'http://192.168.134.117:3000';
const productURL = '$baseURL/products';
const clientURL = '$baseURL/clients';
const locationURL = '$baseURL/locations';

InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: const EdgeInsets.all(10),
    border: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.black),
    ),
  );
}

TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    onPressed: () => onPressed(),
    style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 10)),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
