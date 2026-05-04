class Vendor {
  final String id;
  final String name;
  final String? slug;

  Vendor({required this.id, required this.name, this.slug});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'slug': slug};

  static Vendor fromJson(Map<String, dynamic> json) => Vendor(
        id: json['id'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String?,
      );
}
