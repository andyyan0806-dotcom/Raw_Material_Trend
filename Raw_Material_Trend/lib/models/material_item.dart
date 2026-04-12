enum MaterialCategory { metals, energy, agriculture, chemicals }

class MaterialItem {
  final String id;
  final String name;
  final List<String> aliases;
  final String unit;
  final String unitShort;
  final MaterialCategory category;
  final String emoji;
  final String description;

  const MaterialItem({
    required this.id,
    required this.name,
    required this.aliases,
    required this.unit,
    required this.unitShort,
    required this.category,
    required this.emoji,
    required this.description,
  });

  String get categoryLabel {
    switch (category) {
      case MaterialCategory.metals:
        return 'Metals';
      case MaterialCategory.energy:
        return 'Energy';
      case MaterialCategory.agriculture:
        return 'Agriculture';
      case MaterialCategory.chemicals:
        return 'Chemicals';
    }
  }
}
