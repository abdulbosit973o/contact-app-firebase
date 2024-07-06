class ContactData {
  final String id;
  final String name;
  final String phone;
  final String email;

  ContactData({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory ContactData.fromMap(Map<String, dynamic> data) {
    return ContactData(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}
