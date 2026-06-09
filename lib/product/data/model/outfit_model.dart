import 'package:easy_localization/easy_localization.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'clothing_model.dart';

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
    this.itemsData,
  });

  final int id;
  final int userId;
  final String? name;
  final String? eventType;
  final String? aiNote;
  final bool isFavorite;
  final List<int> items;
  final DateTime createdAt;
  /// Full clothing item details — present when fetched with include_items=true
  final List<ClothingModel>? itemsData;

  factory OutfitModel.fromJson(Map<String, dynamic> json) {
    return OutfitModel(
      id:         json['id']          as int,
      userId:     json['user_id']     as int,
      name:       json['name']        as String?,
      eventType:  json['event_type']  as String?,
      aiNote:     json['ai_note']     as String?,
      isFavorite: json['is_favorite'] as bool?   ?? false,
      items:      (json['items'] as List).cast<int>(),
      createdAt:  DateTime.parse(json['created_at'] as String),
      itemsData:  (json['items_data'] as List?)
          ?.map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  OutfitModel copyWith({bool? isFavorite}) {
    return OutfitModel(
      id:        id,
      userId:    userId,
      name:      name,
      eventType: eventType,
      aiNote:    aiNote,
      isFavorite: isFavorite ?? this.isFavorite,
      items:     items,
      createdAt: createdAt,
      itemsData: itemsData,
    );
  }
}

/// Shared helpers used across UI widgets.
extension OutfitModelExt on OutfitModel {
  String get localizedEventLabel {
    const map = {
      'casual':   LocaleKeys.statsEventCasual,
      'formal':   LocaleKeys.statsEventFormal,
      'date':     LocaleKeys.statsEventDate,
      'business': LocaleKeys.statsEventBusiness,
      'sport':    LocaleKeys.statsEventSport,
      'party':    LocaleKeys.statsEventParty,
    };
    final key = map[eventType];
    if (key != null) return key.tr();
    return eventType != null && eventType!.isNotEmpty
        ? eventType!
        : LocaleKeys.statsEventUnknown.tr();
  }

  String get eventEmoji {
    const map = {
      'casual':   '👚',
      'formal':   '👔',
      'date':     '💝',
      'business': '💼',
      'sport':    '🏃',
      'party':    '🎉',
    };
    return map[eventType] ?? '👗';
  }

  String get formattedDate {
    final dt = createdAt;
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
  }
}
