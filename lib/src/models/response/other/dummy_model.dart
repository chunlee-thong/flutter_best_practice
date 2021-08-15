class DummyModel {
  DummyModel({
    required this.name,
    required this.username,
    required this.email,
    required this.btcAddress,
    required this.address,
    required this.quote,
    required this.description,
  });

  final String? name;
  final String? username;
  final String? email;
  final String? btcAddress;
  final String? address;
  final String? quote;
  final String? description;

  factory DummyModel.fromJson(Map<String, dynamic> json) {
    return DummyModel(
      name: json["name"] == null ? null : json["name"],
      username: json["username"] == null ? null : json["username"],
      email: json["email"] == null ? null : json["email"],
      btcAddress: json["btcAddress"] == null ? null : json["btcAddress"],
      address: json["address"] == null ? null : json["address"],
      quote: json["quote"] == null ? null : json["quote"],
      description: json["description"] == null ? null : json["description"],
    );
  }
}
