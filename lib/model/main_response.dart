class MainResponce {
  String name;

  MainResponce({required this.name});

  factory MainResponce.fromJson(Map<String, dynamic> json) {
    return MainResponce(name: json['name']);
  }
}
