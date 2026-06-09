class ClothingModel {
  const ClothingModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.category,
    required this.color,
    required this.season,
    this.subCategory,
    this.imageUrl,
    required this.wearCount,
    this.isFavorite = false,
    this.lastWorn,
    required this.createdAt,
  });

  final int id;
  final int userId;
  final String name;
  final String category;
  final String color;
  final String season;
  final String? subCategory;
  final String? imageUrl;
  final int wearCount;

  List<String> get seasonsList => season.split(',').where((s) => s.isNotEmpty).toList();
  final bool isFavorite;
  final DateTime? lastWorn;
  final DateTime createdAt;

  factory ClothingModel.fromJson(Map<String, dynamic> json) {
    return ClothingModel(
      id:         json['id']         as int,
      userId:     json['user_id']    as int,
      name:       json['name']       as String,
      category:   json['category']   as String,
      color:      json['color']      as String,
      season:     json['season']     as String,
      subCategory:json['sub_category'] as String?,
      imageUrl:   json['image_url']  as String?,
      wearCount:  json['wear_count'] as int?  ?? 0,
      isFavorite: json['is_favorite'] as bool? ?? false,
      lastWorn:   json['last_worn'] != null
          ? DateTime.parse(json['last_worn'] as String)
          : null,
      createdAt:  DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name':     name,
      'category': category,
      'sub_category': subCategory,
      'color':    color,
      'season':   season,
    };
  }

  ClothingModel copyWith({
    String? name,
    String? category,
    String? color,
    String? season,
    String? subCategory,
    String? imageUrl,
    int? wearCount,
    bool? isFavorite,
    DateTime? lastWorn,
  }) {
    return ClothingModel(
      id:         id,
      userId:     userId,
      name:       name       ?? this.name,
      category:   category   ?? this.category,
      color:      color      ?? this.color,
      season:     season     ?? this.season,
      subCategory:subCategory?? this.subCategory,
      imageUrl:   imageUrl   ?? this.imageUrl,
      wearCount:  wearCount  ?? this.wearCount,
      isFavorite: isFavorite ?? this.isFavorite,
      lastWorn:   lastWorn   ?? this.lastWorn,
      createdAt:  createdAt,
    );
  }
}
