import 'package:flutter/material.dart';
import '../data/materials_data.dart';
import '../models/material_item.dart';
import '../theme/app_colors.dart';
import 'analysis_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  List<MaterialItem> _results = [];
  bool _showResults = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchController.text;
    if (q.length < 2) {
      setState(() {
        _results = [];
        _showResults = false;
      });
      return;
    }
    setState(() {
      _results = searchMaterials(q);
      _showResults = true;
    });
  }

  void _openMaterial(String id) {
    _focusNode.unfocus();
    _searchController.clear();
    setState(() => _showResults = false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AnalysisScreen(materialId: id)),
    );
  }

  void _showCategorySheet(MaterialCategory category) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final materials = kMaterials.where((m) => m.category == category).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final color = _categoryColorFor(category);
    final label = materials.first.categoryLabel;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CategorySheet(
        label: label,
        color: color,
        materials: materials,
        isDark: isDark,
        onTap: (id) {
          Navigator.pop(context);
          _openMaterial(id);
        },
      ),
    );
  }

  Color _categoryColorFor(MaterialCategory cat) {
    switch (cat) {
      case MaterialCategory.metals:      return AppColors.metals;
      case MaterialCategory.energy:      return AppColors.energy;
      case MaterialCategory.agriculture: return AppColors.agriculture;
      case MaterialCategory.chemicals:   return AppColors.chemicals;
      case MaterialCategory.minerals:    return AppColors.minerals;
      case MaterialCategory.forestry:    return AppColors.forestry;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bg,
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
          if (_searchController.text.isEmpty) {
            setState(() => _showResults = false);
          }
        },
        child: Stack(
          children: [
            // ── Decorative background orbs ──────────────────────────────
            Positioned(
              top: -80,
              right: -60,
              child: _Orb(
                size: 280,
                color: primary.withAlpha(isDark ? 18 : 12),
              ),
            ),
            Positioned(
              top: 120,
              right: 40,
              child: _Orb(
                size: 120,
                color: AppColors.agriculture.withAlpha(isDark ? 22 : 14),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.25,
              left: -80,
              child: _Orb(
                size: 220,
                color: AppColors.energy.withAlpha(isDark ? 16 : 10),
              ),
            ),

            // ── Main content ─────────────────────────────────────────────
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.54,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Brand row ───────────────────────────────────
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primary,
                                      primary.withAlpha(180),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primary.withAlpha(isDark ? 60 : 50),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.show_chart_rounded,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'MaterialTrend',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: textColor,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // ── Headline ────────────────────────────────────
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                                letterSpacing: -1.2,
                                height: 1.12,
                              ),
                              children: [
                                const TextSpan(text: "What's moving\n"),
                                TextSpan(
                                  text: 'raw material',
                                  style: TextStyle(color: primary),
                                ),
                                const TextSpan(text: ' prices?'),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            'Prices, drivers, forecasts and scenario\nanalysis — across 99 commodities.',
                            style: TextStyle(
                              fontSize: 15,
                              color: secondary,
                              height: 1.55,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // ── Stat pills ──────────────────────────────────
                          Row(
                            children: [
                              _StatPill(
                                label: '99 materials',
                                icon: Icons.grain_rounded,
                                primary: primary,
                                isDark: isDark,
                              ),
                              const SizedBox(width: 8),
                              _StatPill(
                                label: '6 categories',
                                icon: Icons.category_rounded,
                                primary: primary,
                                isDark: isDark,
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // ── Search bar ──────────────────────────────────
                          Container(
                            decoration: BoxDecoration(
                              color: surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: _showResults
                                    ? primary
                                    : border,
                                width: _showResults ? 1.5 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _showResults
                                      ? primary.withAlpha(isDark ? 50 : 30)
                                      : (isDark
                                          ? AppColors.cardShadowDark
                                          : const Color(0x18000000)),
                                  blurRadius: _showResults ? 24 : 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              style: TextStyle(
                                fontSize: 17,
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search any commodity…',
                                hintStyle: TextStyle(
                                  color: muted,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: _showResults ? primary : muted,
                                    size: 24,
                                  ),
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.close_rounded,
                                            color: muted, size: 20),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() => _showResults = false);
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Autocomplete results ──────────────────────────────
                    if (_showResults && _results.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: border),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? AppColors.cardShadowDark
                                  : const Color(0x12000000),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Column(
                            children: _results.asMap().entries.map((entry) {
                              final i = entry.key;
                              final mat = entry.value;
                              return InkWell(
                                onTap: () => _openMaterial(mat.id),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 14),
                                  decoration: BoxDecoration(
                                    border: i < _results.length - 1
                                        ? Border(
                                            bottom: BorderSide(color: border))
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 42,
                                        height: 42,
                                        decoration: BoxDecoration(
                                          color: _categoryColor(mat.category)
                                              .withAlpha(isDark ? 35 : 20),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(mat.emoji,
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              mat.name,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                              ),
                                            ),
                                            Text(
                                              mat.unit,
                                              style: TextStyle(
                                                  fontSize: 11, color: muted),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _CategoryChip(
                                          label: mat.categoryLabel,
                                          category: mat.category,
                                          isDark: isDark),
                                      const SizedBox(width: 6),
                                      Icon(Icons.arrow_forward_ios_rounded,
                                          color: muted, size: 13),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ] else if (_showResults && _results.isEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: border),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.search_off_rounded,
                                  color: muted, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                'No results found',
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try copper, lithium, wheat…',
                                style:
                                    TextStyle(color: secondary, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // ── Category legend ─────────────────────────────────
                      const SizedBox(height: 8),
                      _CategoryLegend(
                        isDark: isDark,
                        muted: muted,
                        onCategoryTap: _showCategorySheet,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(MaterialCategory cat) {
    switch (cat) {
      case MaterialCategory.metals:
        return AppColors.metals;
      case MaterialCategory.energy:
        return AppColors.energy;
      case MaterialCategory.agriculture:
        return AppColors.agriculture;
      case MaterialCategory.chemicals:
        return AppColors.chemicals;
      case MaterialCategory.minerals:
        return AppColors.minerals;
      case MaterialCategory.forestry:
        return AppColors.forestry;
    }
  }
}

// ── Decorative orb ────────────────────────────────────────────────────────────
class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withAlpha(0)],
        ),
      ),
    );
  }
}

// ── Stat pill ─────────────────────────────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color primary;
  final bool isDark;
  const _StatPill(
      {required this.label,
      required this.icon,
      required this.primary,
      required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: primary.withAlpha(isDark ? 28 : 16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: primary),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category bottom sheet ─────────────────────────────────────────────────────
class _CategorySheet extends StatelessWidget {
  final String label;
  final Color color;
  final List<MaterialItem> materials;
  final bool isDark;
  final void Function(String id) onTap;

  const _CategorySheet({
    required this.label,
    required this.color,
    required this.materials,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final muted = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.93,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black38 : Colors.black12,
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withAlpha(isDark ? 40 : 22),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${materials.length} materials',
                    style: TextStyle(fontSize: 13, color: muted),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: muted, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Divider(color: border, height: 1),

            // Material list
            Expanded(
              child: ListView.separated(
                controller: controller,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: materials.length,
                separatorBuilder: (_, __) =>
                    Divider(color: border, height: 1, indent: 70),
                itemBuilder: (_, i) {
                  final mat = materials[i];
                  return InkWell(
                    onTap: () => onTap(mat.id),
                    child: Container(
                      color: surface,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: color.withAlpha(isDark ? 35 : 18),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(mat.emoji,
                                  style: const TextStyle(fontSize: 22)),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mat.name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  mat.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12, color: secondary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: muted, size: 13),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Category legend ───────────────────────────────────────────────────────────
class _CategoryLegend extends StatelessWidget {
  final bool isDark;
  final Color muted;
  final void Function(MaterialCategory) onCategoryTap;

  const _CategoryLegend({
    required this.isDark,
    required this.muted,
    required this.onCategoryTap,
  });

  static const _categories = [
    ('Metals', AppColors.metals, Icons.bolt_rounded, MaterialCategory.metals),
    ('Energy', AppColors.energy, Icons.local_fire_department_rounded, MaterialCategory.energy),
    ('Agriculture', AppColors.agriculture, Icons.grass_rounded, MaterialCategory.agriculture),
    ('Chemicals', AppColors.chemicals, Icons.science_rounded, MaterialCategory.chemicals),
    ('Minerals', AppColors.minerals, Icons.layers_rounded, MaterialCategory.minerals),
    ('Forestry', AppColors.forestry, Icons.park_rounded, MaterialCategory.forestry),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 36),
        Text(
          'BROWSE BY CATEGORY',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: muted,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.55,
          children: _categories.map((c) {
            final color = c.$2;
            return GestureDetector(
              onTap: () => onCategoryTap(c.$4),
              child: Container(
                decoration: BoxDecoration(
                  color: color.withAlpha(isDark ? 28 : 16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: color.withAlpha(isDark ? 50 : 35), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(c.$3, color: color, size: 22),
                    const SizedBox(height: 6),
                    Text(
                      c.$1,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Category chip ─────────────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final String label;
  final MaterialCategory category;
  final bool isDark;

  const _CategoryChip({
    required this.label,
    required this.category,
    required this.isDark,
  });

  Color get _color {
    switch (category) {
      case MaterialCategory.metals:
        return AppColors.metals;
      case MaterialCategory.energy:
        return AppColors.energy;
      case MaterialCategory.agriculture:
        return AppColors.agriculture;
      case MaterialCategory.chemicals:
        return AppColors.chemicals;
      case MaterialCategory.minerals:
        return AppColors.minerals;
      case MaterialCategory.forestry:
        return AppColors.forestry;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withAlpha(isDark ? 40 : 25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}

