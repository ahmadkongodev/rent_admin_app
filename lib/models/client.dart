class Client {
  String? id;
  String? nom;
  String? prenom;
  String? username;
  String? password;
  String? numero;
  String? address;

  Client(
      {this.id,
      this.nom,
      this.prenom,
      this.username,
      this.password,
      this.numero,
      this.address});
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['_id'],
      nom: json['nom'],
      prenom: json['prenom'],
      username: json['username'],
      password: json['password'],
      numero: json['numero'],
      address: json['address'],
    );
  }
}
