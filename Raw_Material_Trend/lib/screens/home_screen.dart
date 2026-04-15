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

  static const _featured = [
    'copper', 'lithium', 'crude_oil', 'natural_gas',
    'wheat', 'coffee', 'aluminum', 'cobalt',
  ];

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

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            _focusNode.unfocus();
            if (_searchController.text.isEmpty) {
              setState(() => _showResults = false);
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo / heading
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.show_chart_rounded,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'MaterialTrend',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: textColor,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'Raw material price intelligence',
                                style: TextStyle(fontSize: 12, color: muted),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Search any raw material',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: -0.8,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'See the trend, the reasons, and what comes next.',
                        style: TextStyle(fontSize: 15, color: secondary, height: 1.4),
                      ),
                      const SizedBox(height: 20),

                      // Search bar
                      Container(
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _showResults ? primary : border,
                            width: _showResults ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? AppColors.cardShadowDark
                                  : AppColors.cardShadowLight,
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          style: TextStyle(fontSize: 16, color: textColor),
                          decoration: InputDecoration(
                            hintText: 'e.g. copper, lithium, palm oil…',
                            hintStyle: TextStyle(color: muted, fontSize: 15),
                            prefixIcon: Icon(Icons.search_rounded,
                                color: _showResults ? primary : muted),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.close_rounded, color: muted),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _showResults = false);
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),

                      // Autocomplete results
                      if (_showResults && _results.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: border),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? AppColors.cardShadowDark
                                    : AppColors.cardShadowLight,
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Column(
                              children: _results.asMap().entries.map((entry) {
                                final i = entry.key;
                                final mat = entry.value;
                                return InkWell(
                                  onTap: () => _openMaterial(mat.id),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: i < _results.length - 1
                                          ? Border(
                                              bottom:
                                                  BorderSide(color: border))
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(mat.emoji,
                                            style:
                                                const TextStyle(fontSize: 22)),
                                        const SizedBox(width: 12),
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
                                        const SizedBox(width: 8),
                                        Icon(Icons.chevron_right_rounded,
                                            color: muted, size: 18),
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
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: border),
                          ),
                          child: Center(
                            child: Text(
                              'No materials found. Try copper, lithium, wheat…',
                              style: TextStyle(color: secondary, fontSize: 14),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Featured section
                      Text(
                        'FEATURED MATERIALS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: muted,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
              ),

              // Featured grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final id = _featured[index];
                      final mat = getMaterialById(id);
                      if (mat == null) return const SizedBox();
                      return _FeaturedCard(
                        material: mat,
                        isDark: isDark,
                        onTap: () => _openMaterial(id),
                      );
                    },
                    childCount: _featured.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final MaterialItem material;
  final bool isDark;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.material,
    required this.isDark,
    required this.onTap,
  });

  Color get _categoryColor {
    switch (material.category) {
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
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textColor = isDark ? AppColors.textDark : AppColors.textLight;
    final secondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.cardShadowDark : AppColors.cardShadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(material.emoji, style: const TextStyle(fontSize: 22)),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _categoryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              material.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              material.unitShort,
              style: TextStyle(fontSize: 10, color: secondary),
            ),
          ],
        ),
      ),
    );
  }
}

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
