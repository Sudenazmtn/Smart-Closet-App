part of 'add_clothing_view.dart';

typedef _ChipOption = ({String value, String localeKey});
typedef _ColorOption = ({String value, String localeKey, Color swatch});

const List<_ChipOption> _kCategories = [
  (value: 'tops', localeKey: LocaleKeys.wardrobeFilterTops),
  (value: 'bottoms', localeKey: LocaleKeys.wardrobeFilterBottoms),
  (value: 'dress', localeKey: LocaleKeys.wardrobeFilterDresses),
  (value: 'outerwear', localeKey: LocaleKeys.wardrobeFilterOuterwear),
  (value: 'shoes', localeKey: LocaleKeys.wardrobeFilterShoes),
  (value: 'bags', localeKey: LocaleKeys.wardrobeFilterBags),
];

const List<_ChipOption> _kSeasons = [
  (value: 'spring', localeKey: LocaleKeys.seasonSpring),
  (value: 'summer', localeKey: LocaleKeys.seasonSummer),
  (value: 'fall', localeKey: LocaleKeys.seasonFall),
  (value: 'winter', localeKey: LocaleKeys.seasonWinter),
  (value: 'all', localeKey: LocaleKeys.seasonAll),
];

const List<_ColorOption> _kColors = [
  (value: 'beige', localeKey: LocaleKeys.colorBeige, swatch: Color(0xFFD4B483)),
  (value: 'black', localeKey: LocaleKeys.colorBlack, swatch: Color(0xFF1C1917)),
  (value: 'white', localeKey: LocaleKeys.colorWhite, swatch: Color(0xFFF5F5F4)),
  (value: 'navy', localeKey: LocaleKeys.colorNavy, swatch: Color(0xFF1B2A4A)),
  (value: 'red', localeKey: LocaleKeys.colorRed, swatch: Color(0xFFA32D2D)),
];
