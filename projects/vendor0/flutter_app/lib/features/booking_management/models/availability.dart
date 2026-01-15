class AvailabilityRule {
  final String id;
  final String description;

  AvailabilityRule({required this.id, required this.description});

  Map<String, dynamic> toJson() => {'id': id, 'description': description};

  static AvailabilityRule fromJson(Map<String, dynamic> json) => AvailabilityRule(
        id: json['id'] as String,
        description: json['description'] as String,
      );
}
