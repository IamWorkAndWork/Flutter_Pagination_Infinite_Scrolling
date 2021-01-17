class GithubModel {
  final int id;
  final String name;
  final String description;

  GithubModel({this.id, this.name, this.description});

  factory GithubModel.fromJson(Map<String, dynamic> json) {
    return GithubModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
    );
  }
}
