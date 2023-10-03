class UserModel {
  final String id;
  final String email;
  final String name;
  final String id_location;
  final String role;
  final String section;
  final String section_name;
  final String establishment;
  final String establishment_name;

  UserModel(
      {required this.id,
      required this.email,
      required this.name,
      required this.id_location,
      required this.role,
      required this.section,
      required this.section_name,
      required this.establishment,
      required this.establishment_name});

  Map<String, dynamic> toJson() => {
        // 'id': id,
        'id': id,
        'email': email,
        'name': name,
        'id_location': id_location,
        'role': role,
        'section': section,
        'section_name': section_name,
        'establishment': establishment,
        'establishment_name': establishment_name
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
      // id: json['id'],
      id: json['id'],
      email: json['email'],
      name: json['name'],
      id_location: json['id_location'],
      role: json['role'],
      section: json['section'],
      section_name: json['section_name'],
      establishment: json['establishment'],
      establishment_name: json['establishment_name']);
}
