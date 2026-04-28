part of 'home_view.dart';

/// HomeView'ın bir parçası.
/// Kategori listesi burada tanımlı — view dosyasını şişirmez.
/// homeCategories, HomeView'ın scope'unda doğrudan erişilebilir.
final List<HomeCategoryData> homeCategories = [
  HomeCategoryData(
    label: LocaleKeys.wardrobeFilterTops.tr(),
    emoji: '👚',
    color: const Color(0xFFF5C5C5),
    filter: 'tops',
  ),
  HomeCategoryData(
    label: LocaleKeys.wardrobeFilterBottoms.tr(),
    emoji: '👖',
    color: const Color(0xFFBDD8C0),
    filter: 'bottoms',
  ),
  HomeCategoryData(
    label: LocaleKeys.wardrobeFilterDresses.tr(),
    emoji: '👗',
    color: const Color(0xFFB8CEDD),
    filter: 'dress',
  ),
  HomeCategoryData(
    label: LocaleKeys.wardrobeFilterOuterwear.tr(),
    emoji: '🧥',
    color: const Color(0xFFF5E8C8),
    filter: 'outerwear',
  ),
];
