part of 'home_view.dart';

List<HomeCategoryData> buildCategories(ClothingProvider clothing) => [
  HomeCategoryData(
    label: LocaleKeys.wardrobeFilterTops.tr(),
    emoji: '👚',
    color: const Color(0xFFF5C5C5),
    filter: 'tops',
    imageUrl: clothing.firstImageForCategory('tops'),
  ),
  HomeCategoryData(
    label: LocaleKeys.wardrobeFilterBottoms.tr(),
    emoji: '👖',
    color: const Color(0xFFBDD8C0),
    filter: 'bottoms',
    imageUrl: clothing.firstImageForCategory('bottoms'),
  ),
  HomeCategoryData(
    label: LocaleKeys.wardrobeFilterDresses.tr(),
    emoji: '👗',
    color: const Color(0xFFB8CEDD),
    filter: 'dress',
    imageUrl: clothing.firstImageForCategory('dress'),

  ),
  HomeCategoryData(
    label: LocaleKeys.wardrobeFilterOuterwear.tr(),
    emoji: '🧥',
    color: const Color(0xFFF5E8C8),
    filter: 'outerwear',
    imageUrl: clothing.firstImageForCategory('outerwear'),
  ),
];
