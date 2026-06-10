import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';

typedef ClothingChipOption = ({String value, String localeKey});
typedef ClothingColorOption = ({String value, String localeKey, Color swatch});

const List<ClothingChipOption> kClothingCategories = [
  (value: 'tops', localeKey: LocaleKeys.wardrobeFilterTops),
  (value: 'bottoms', localeKey: LocaleKeys.wardrobeFilterBottoms),
  (value: 'dress', localeKey: LocaleKeys.wardrobeFilterDresses),
  (value: 'outerwear', localeKey: LocaleKeys.wardrobeFilterOuterwear),
  (value: 'shoes', localeKey: LocaleKeys.wardrobeFilterShoes),
  (value: 'bags', localeKey: LocaleKeys.wardrobeFilterBags),
];

const Map<String, List<ClothingChipOption>> kClothingSubCategories = {
  'tops': [
    (value: 't-shirt', localeKey: LocaleKeys.subcategoryTshirt),
    (value: 'shirt', localeKey: LocaleKeys.subcategoryShirt),
    (value: 'blouse', localeKey: LocaleKeys.subcategoryBlouse),
    (value: 'sweater', localeKey: LocaleKeys.subcategorySweater),
    (value: 'hoodie', localeKey: LocaleKeys.subcategoryHoodie),
    (value: 'cardigan', localeKey: LocaleKeys.subcategoryCardigan),
    (value: 'tank-top', localeKey: LocaleKeys.subcategoryTankTop),
    (value: 'polo', localeKey: LocaleKeys.subcategoryPolo),
  ],
  'bottoms': [
    (value: 'jeans', localeKey: LocaleKeys.subcategoryJeans),
    (value: 'trousers', localeKey: LocaleKeys.subcategoryTrousers),
    (value: 'shorts', localeKey: LocaleKeys.subcategoryShorts),
    (value: 'skirt', localeKey: LocaleKeys.subcategorySkirt),
    (value: 'leggings', localeKey: LocaleKeys.subcategoryLeggings),
    (value: 'sweatpants', localeKey: LocaleKeys.subcategorySweatpants),
  ],
  'outerwear': [
    (value: 'blazer', localeKey: LocaleKeys.subcategoryBlazer),
    (value: 'jacket', localeKey: LocaleKeys.subcategoryJacket),
    (value: 'coat', localeKey: LocaleKeys.subcategoryCoat),
    (value: 'trench_coat', localeKey: LocaleKeys.subcategoryTrenchCoat),
    (value: 'vest', localeKey: LocaleKeys.subcategoryVest),
  ],
  'shoes': [
    (value: 'sneakers', localeKey: LocaleKeys.subcategorySneakers),
    (value: 'heels', localeKey: LocaleKeys.subcategoryHeels),
    (value: 'boots', localeKey: LocaleKeys.subcategoryBoots),
    (value: 'loafers', localeKey: LocaleKeys.subcategoryLoafers),
    (value: 'sandals', localeKey: LocaleKeys.subcategorySandals),
    (value: 'oxfords', localeKey: LocaleKeys.subcategoryOxfords),
  ],
};

const List<ClothingChipOption> kClothingSeasons = [
  (value: 'spring', localeKey: LocaleKeys.seasonSpring),
  (value: 'summer', localeKey: LocaleKeys.seasonSummer),
  (value: 'fall', localeKey: LocaleKeys.seasonFall),
  (value: 'winter', localeKey: LocaleKeys.seasonWinter),
  (value: 'all', localeKey: LocaleKeys.seasonAll),
];

const List<ClothingColorOption> kClothingColors = [
  (value: 'beige', localeKey: LocaleKeys.colorBeige, swatch: Color(0xFFD4B483)),
  (value: 'black', localeKey: LocaleKeys.colorBlack, swatch: Color(0xFF1C1917)),
  (value: 'white', localeKey: LocaleKeys.colorWhite, swatch: Color(0xFFF5F5F4)),
  (value: 'gray', localeKey: LocaleKeys.colorGray, swatch: Color(0xFF9CA3AF)),
  (value: 'brown', localeKey: LocaleKeys.colorBrown, swatch: Color(0xFF78350F)),
  (value: 'navy', localeKey: LocaleKeys.colorNavy, swatch: Color(0xFF1B2A4A)),
  (value: 'blue', localeKey: LocaleKeys.colorBlue, swatch: Color(0xFF3B82F6)),
  (value: 'green', localeKey: LocaleKeys.colorGreen, swatch: Color(0xFF22C55E)),
  (value: 'yellow', localeKey: LocaleKeys.colorYellow, swatch: Color(0xFFEAB308)),
  (value: 'orange', localeKey: LocaleKeys.colorOrange, swatch: Color(0xFFF97316)),
  (value: 'red', localeKey: LocaleKeys.colorRed, swatch: Color(0xFFA32D2D)),
  (value: 'pink', localeKey: LocaleKeys.colorPink, swatch: Color(0xFFEC4899)),
  (value: 'purple', localeKey: LocaleKeys.colorPurple, swatch: Color(0xFFA855F7)),
];
