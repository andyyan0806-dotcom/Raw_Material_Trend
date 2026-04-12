import '../models/material_item.dart';

const List<MaterialItem> kMaterials = [
  MaterialItem(
    id: 'copper',
    name: 'Copper',
    aliases: ['cu', 'copper cathode', 'comex copper'],
    unit: 'USD / metric ton',
    unitShort: '/t',
    category: MaterialCategory.metals,
    emoji: '🔶',
    description: 'Industrial metal essential for electrical wiring, construction, and electronics.',
  ),
  MaterialItem(
    id: 'lithium',
    name: 'Lithium',
    aliases: ['li', 'lithium carbonate', 'lithium hydroxide', 'spodumene'],
    unit: 'USD / metric ton',
    unitShort: '/t',
    category: MaterialCategory.metals,
    emoji: '⚡',
    description: 'Critical battery material powering EVs and grid-scale energy storage.',
  ),
  MaterialItem(
    id: 'natural_gas',
    name: 'Natural Gas',
    aliases: ['natgas', 'nat gas', 'lng', 'henry hub'],
    unit: 'USD / MMBtu',
    unitShort: '/MMBtu',
    category: MaterialCategory.energy,
    emoji: '🔥',
    description: 'Primary fuel for power generation, heating, and industrial processes.',
  ),
  MaterialItem(
    id: 'palm_oil',
    name: 'Palm Oil',
    aliases: ['crude palm oil', 'cpo', 'rbd palm olein'],
    unit: 'USD / metric ton',
    unitShort: '/t',
    category: MaterialCategory.agriculture,
    emoji: '🌴',
    description: 'Versatile vegetable oil used in food, cosmetics, and biofuels.',
  ),
  MaterialItem(
    id: 'cotton',
    name: 'Cotton',
    aliases: ['cotton fiber', 'ice cotton', 'cotlook'],
    unit: 'USD cents / pound',
    unitShort: '¢/lb',
    category: MaterialCategory.agriculture,
    emoji: '☁️',
    description: 'Staple textile fiber traded globally for apparel and industrial use.',
  ),
  MaterialItem(
    id: 'aluminum',
    name: 'Aluminum',
    aliases: ['aluminium', 'al', 'lme aluminum'],
    unit: 'USD / metric ton',
    unitShort: '/t',
    category: MaterialCategory.metals,
    emoji: '🔘',
    description: 'Lightweight metal used in aerospace, automotive, and packaging.',
  ),
  MaterialItem(
    id: 'nickel',
    name: 'Nickel',
    aliases: ['ni', 'lme nickel'],
    unit: 'USD / metric ton',
    unitShort: '/t',
    category: MaterialCategory.metals,
    emoji: '🔩',
    description: 'Alloying metal used in stainless steel, batteries, and superalloys.',
  ),
  MaterialItem(
    id: 'wheat',
    name: 'Wheat',
    aliases: ['cbot wheat', 'soft wheat', 'hard wheat', 'grain'],
    unit: 'USD cents / bushel',
    unitShort: '¢/bu',
    category: MaterialCategory.agriculture,
    emoji: '🌾',
    description: 'Global food staple driving food security and geopolitical tensions.',
  ),
  MaterialItem(
    id: 'cobalt',
    name: 'Cobalt',
    aliases: ['co', 'cobalt metal'],
    unit: 'USD / metric ton',
    unitShort: '/t',
    category: MaterialCategory.metals,
    emoji: '🔵',
    description: 'Battery and superalloy metal with concentrated supply in the DRC.',
  ),
  MaterialItem(
    id: 'crude_oil',
    name: 'Crude Oil',
    aliases: ['wti', 'brent', 'oil', 'petroleum', 'brent crude', 'wti crude'],
    unit: 'USD / barrel',
    unitShort: '/bbl',
    category: MaterialCategory.energy,
    emoji: '🛢️',
    description: 'Benchmark energy commodity influencing global inflation and trade.',
  ),
  MaterialItem(
    id: 'steel',
    name: 'Steel',
    aliases: ['hot rolled coil', 'hrc', 'rebar', 'iron ore'],
    unit: 'USD / metric ton',
    unitShort: '/t',
    category: MaterialCategory.metals,
    emoji: '🏗️',
    description: 'Foundational construction and manufacturing metal tied to China demand.',
  ),
  MaterialItem(
    id: 'coffee',
    name: 'Coffee',
    aliases: ['arabica', 'robusta', 'ice coffee'],
    unit: 'USD cents / pound',
    unitShort: '¢/lb',
    category: MaterialCategory.agriculture,
    emoji: '☕',
    description: 'Global beverage commodity sensitive to Brazilian and Vietnamese harvests.',
  ),
];

List<MaterialItem> searchMaterials(String query) {
  if (query.length < 2) return [];
  final q = query.toLowerCase();
  final matchedIds = <String>{};
  final results = <MaterialItem>[];

  for (final mat in kMaterials) {
    if (matchedIds.contains(mat.id)) continue;
    final terms = [mat.name.toLowerCase(), ...mat.aliases.map((a) => a.toLowerCase())];
    if (terms.any((t) => t.contains(q))) {
      matchedIds.add(mat.id);
      results.add(mat);
    }
    if (results.length >= 6) break;
  }
  return results;
}

MaterialItem? getMaterialById(String id) {
  try {
    return kMaterials.firstWhere((m) => m.id == id);
  } catch (_) {
    return null;
  }
}
