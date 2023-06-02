class Product {
  String? id;
  String? image;
 String? nom;
 String? description;
  int? quantite;
   int?prix;
  
  Product({ this.id, this.image, this.nom, this.description, this.quantite, this.prix});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      image: json['image'],
      nom: json['nom'],
      description: json['description'],
      quantite: json['quantite'],
      prix: json['prix'],
    );
  }
}
