class OutfitModel {
  const OutfitModel({
    required this.id,
    required this.userId,
    this.name,
    this.eventType,
    this.aiNote,
    required this.isFavorite,
    required this.items,
    required this.createdAt,
  });

  final int id;
  final int userId;
  final String? name;
  final String? eventType;
  final String? aiNote;
  final bool isFavorite;
  final List<int> items;
  final DateTime createdAt;

  factory OutfitModel.fromJson(Map<String, dynamic> json) {
    return OutfitModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String?,
      eventType: json['event_type'] as String?,
      aiNote: json['ai_note'] as String?,
      isFavorite: json['is_favorite'] as bool? ?? false,
      items: (json['items'] as List).cast<int>(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  OutfitModel copyWith({bool? isFavorite}) {
    return OutfitModel(
      id: id,
      userId: userId,
      name: name,
      eventType: eventType,
      aiNote: aiNote,
      isFavorite: isFavorite ?? this.isFavorite,
      items: items,
      createdAt: createdAt,
    );
  }
}
