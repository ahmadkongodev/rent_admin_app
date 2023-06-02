class Location {
  String? id;
  String? date_debut;
  String? date_fin;
  String? id_client;
  String? id_produit;
  int? quantite_louer;
  String? etat;

  Location(
      {this.id,
      this.date_debut,
      this.date_fin,
      this.id_client,
      this.id_produit,
      this.quantite_louer, 
      this.etat});
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['_id'],
      date_debut: json['date_debut'],
      date_fin: json['date_fin'],
      id_client: json['id_client'],
      id_produit: json['id_produit'],
      quantite_louer: json['quantite_louer'],
      etat: json['etat'],
    );
  }
}
