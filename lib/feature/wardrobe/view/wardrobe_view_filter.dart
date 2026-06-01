part of 'wardrobe_view.dart';

List<WardrobeFilterItem> get wardrobeFilters => [
      WardrobeFilterItem(label: LocaleKeys.wardrobeFilterAll.tr(), value: 'all'),
      WardrobeFilterItem(label: LocaleKeys.wardrobeFilterTops.tr(), value: 'tops'),
      WardrobeFilterItem(label: LocaleKeys.wardrobeFilterBottoms.tr(), value: 'bottoms'),
      WardrobeFilterItem(label: LocaleKeys.wardrobeFilterDresses.tr(), value: 'dress'),
      WardrobeFilterItem(label: LocaleKeys.wardrobeFilterOuterwear.tr(), value: 'outerwear'),
      WardrobeFilterItem(label: LocaleKeys.wardrobeFilterShoes.tr(), value: 'shoes'),
      WardrobeFilterItem(label: LocaleKeys.wardrobeFilterBags.tr(), value: 'bags'),
    ];
