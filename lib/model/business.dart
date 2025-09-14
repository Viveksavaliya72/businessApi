
class Business{
  final String id;
  final String name;
  final String location;
  final String contact;

  Business({
    required this.id,
    required this.name,
    required this.location,
    required this.contact,
  });

  factory Business.fromJson(Map<String, dynamic> json, {String? id}) {
    final name = (json['biz_name'] ?? json['name'] ?? '').toString().trim();
    final location = (json['bss_location'] ?? json['location'] ?? '').toString().trim();
    final contact = (json['contct_no'] ?? json['phone'] ?? '').toString().trim();

    if (name.isEmpty) throw FormatException('Missing business name');
    if (contact.isEmpty) throw FormatException('Missing contact');

    return Business(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      location: location,
      contact: contact,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'contact': contact,
  };

  static List<Business> listFromJson(List<dynamic> arr) {
    return arr.map((e) => Business.fromJson(Map<String, dynamic>.from(e))).toList();
  }

}