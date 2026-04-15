import 'dart:math';
import '../models/material_analysis.dart';

// ── Price series generator ──────────────────────────────────────────────────

List<PricePoint> _buildSeries(
  double start,
  List<Map<String, double>> inflections,
  double volatility,
) {
  final months = [
    "Apr '25", "Apr '25", "Apr '25", "Apr '25",
    "May '25", "May '25", "May '25", "May '25",
    "Jun '25", "Jun '25", "Jun '25", "Jun '25",
    "Jul '25", "Jul '25", "Jul '25", "Jul '25",
    "Aug '25", "Aug '25", "Aug '25", "Aug '25",
    "Sep '25", "Sep '25", "Sep '25", "Sep '25",
    "Oct '25", "Oct '25", "Oct '25", "Oct '25",
    "Nov '25", "Nov '25", "Nov '25", "Nov '25",
    "Dec '25", "Dec '25", "Dec '25", "Dec '25",
    "Jan '26", "Jan '26", "Jan '26", "Jan '26",
    "Feb '26", "Feb '26", "Feb '26", "Feb '26",
    "Mar '26", "Mar '26", "Mar '26", "Mar '26",
    "Apr '26", "Apr '26", "Apr '26", "Apr '26",
  ];

  final points = <PricePoint>[];
  double current = start;

  for (int i = 0; i < 52; i++) {
    // Interpolate toward inflection targets
    for (int j = 0; j < inflections.length; j++) {
      final inf = inflections[j];
      final infWeek = inf['week']!.toInt();
      if (i == infWeek) {
        current = inf['value']!;
        break;
      } else if (i < infWeek) {
        int prevWeek = 0;
        double prevValue = start;
        if (j > 0) {
          prevWeek = inflections[j - 1]['week']!.toInt();
          prevValue = inflections[j - 1]['value']!;
        }
        if (i > prevWeek) {
          final t = (i - prevWeek) / (infWeek - prevWeek);
          current = prevValue + t * (inf['value']! - prevValue);
        }
        break;
      }
    }

    // Deterministic noise (no Random — reproducible for same data)
    final noise = sin(i * 1.7) * 0.4 + cos(i * 2.3) * 0.3 + sin(i * 0.9) * 0.3;
    current = current * (1 + noise * volatility);

    final label = i < months.length ? months[i] : "Apr '26";
    points.add(PricePoint(label: label, value: double.parse(current.toStringAsFixed(2))));
  }
  return points;
}

// ── Pre-built series ────────────────────────────────────────────────────────

final _copperSeries = _buildSeries(8500, [
  {'week': 0, 'value': 8500},
  {'week': 10, 'value': 10200},
  {'week': 20, 'value': 8800},
  {'week': 35, 'value': 9600},
  {'week': 51, 'value': 9250},
], 0.018);

final _lithiumSeries = _buildSeries(15000, [
  {'week': 0, 'value': 15000},
  {'week': 8, 'value': 11000},
  {'week': 18, 'value': 9200},
  {'week': 30, 'value': 10800},
  {'week': 51, 'value': 12400},
], 0.022);

final _gasSeries = _buildSeries(2.8, [
  {'week': 0, 'value': 2.8},
  {'week': 12, 'value': 4.2},
  {'week': 22, 'value': 2.9},
  {'week': 36, 'value': 3.8},
  {'week': 51, 'value': 3.5},
], 0.028);

final _palmOilSeries = _buildSeries(850, [
  {'week': 0, 'value': 850},
  {'week': 14, 'value': 1050},
  {'week': 28, 'value': 920},
  {'week': 42, 'value': 980},
  {'week': 51, 'value': 960},
], 0.016);

final _cottonSeries = _buildSeries(78, [
  {'week': 0, 'value': 78},
  {'week': 10, 'value': 90},
  {'week': 25, 'value': 72},
  {'week': 40, 'value': 83},
  {'week': 51, 'value': 85},
], 0.019);

final _aluminumSeries = _buildSeries(2180, [
  {'week': 0, 'value': 2180},
  {'week': 15, 'value': 2550},
  {'week': 28, 'value': 2250},
  {'week': 42, 'value': 2400},
  {'week': 51, 'value': 2380},
], 0.015);

final _nickelSeries = _buildSeries(16500, [
  {'week': 0, 'value': 16500},
  {'week': 8, 'value': 14200},
  {'week': 22, 'value': 15800},
  {'week': 38, 'value': 17200},
  {'week': 51, 'value': 16900},
], 0.021);

final _wheatSeries = _buildSeries(590, [
  {'week': 0, 'value': 590},
  {'week': 12, 'value': 680},
  {'week': 20, 'value': 540},
  {'week': 34, 'value': 610},
  {'week': 51, 'value': 575},
], 0.017);

final _cobaltSeries = _buildSeries(28000, [
  {'week': 0, 'value': 28000},
  {'week': 10, 'value': 22000},
  {'week': 24, 'value': 24500},
  {'week': 38, 'value': 31000},
  {'week': 51, 'value': 29500},
], 0.020);

final _oilSeries = _buildSeries(82, [
  {'week': 0, 'value': 82},
  {'week': 8, 'value': 90},
  {'week': 20, 'value': 75},
  {'week': 35, 'value': 88},
  {'week': 51, 'value': 79},
], 0.022);

final _steelSeries = _buildSeries(680, [
  {'week': 0, 'value': 680},
  {'week': 12, 'value': 760},
  {'week': 26, 'value': 620},
  {'week': 40, 'value': 700},
  {'week': 51, 'value': 690},
], 0.014);

// ── New price series ────────────────────────────────────────────────────────

final _chromiumSeries = _buildSeries(1350, [
  {'week': 0, 'value': 1350}, {'week': 12, 'value': 1580}, {'week': 24, 'value': 1260},
  {'week': 38, 'value': 1420}, {'week': 51, 'value': 1390},
], 0.014);

final _ironSeries = _buildSeries(118, [
  {'week': 0, 'value': 118}, {'week': 10, 'value': 140}, {'week': 22, 'value': 98},
  {'week': 36, 'value': 112}, {'week': 51, 'value': 105},
], 0.020);

final _magnesiumSeries = _buildSeries(2900, [
  {'week': 0, 'value': 2900}, {'week': 14, 'value': 3400}, {'week': 26, 'value': 2650},
  {'week': 40, 'value': 3100}, {'week': 51, 'value': 2980},
], 0.018);

final _manganeseSeries = _buildSeries(320, [
  {'week': 0, 'value': 320}, {'week': 12, 'value': 380}, {'week': 24, 'value': 290},
  {'week': 38, 'value': 350}, {'week': 51, 'value': 335},
], 0.016);

final _metalAlloysSeries = _buildSeries(1450, [
  {'week': 0, 'value': 1450}, {'week': 14, 'value': 1720}, {'week': 28, 'value': 1350},
  {'week': 42, 'value': 1580}, {'week': 51, 'value': 1520},
], 0.017);

final _molybdenumSeries = _buildSeries(21.0, [
  {'week': 0, 'value': 21.0}, {'week': 10, 'value': 25.5}, {'week': 22, 'value': 18.5},
  {'week': 36, 'value': 23.0}, {'week': 51, 'value': 21.5},
], 0.020);

final _palladiumSeries = _buildSeries(1050, [
  {'week': 0, 'value': 1050}, {'week': 10, 'value': 1200}, {'week': 22, 'value': 880},
  {'week': 36, 'value': 1020}, {'week': 51, 'value': 960},
], 0.022);

final _platinumSeries = _buildSeries(920, [
  {'week': 0, 'value': 920}, {'week': 12, 'value': 1080}, {'week': 24, 'value': 870},
  {'week': 38, 'value': 1010}, {'week': 51, 'value': 970},
], 0.018);

final _rareEarthsSeries = _buildSeries(75, [
  {'week': 0, 'value': 75}, {'week': 8, 'value': 92}, {'week': 20, 'value': 62},
  {'week': 34, 'value': 80}, {'week': 51, 'value': 68},
], 0.025);

final _siliconSeries = _buildSeries(1420, [
  {'week': 0, 'value': 1420}, {'week': 12, 'value': 1680}, {'week': 24, 'value': 1280},
  {'week': 38, 'value': 1520}, {'week': 51, 'value': 1380},
], 0.019);

final _stainlessSteelSeries = _buildSeries(1820, [
  {'week': 0, 'value': 1820}, {'week': 14, 'value': 2050}, {'week': 26, 'value': 1720},
  {'week': 40, 'value': 1900}, {'week': 51, 'value': 1850},
], 0.013);

final _tinSeries = _buildSeries(27000, [
  {'week': 0, 'value': 27000}, {'week': 10, 'value': 31000}, {'week': 22, 'value': 24500},
  {'week': 36, 'value': 29000}, {'week': 51, 'value': 27500},
], 0.020);

final _titaniumSeries = _buildSeries(6200, [
  {'week': 0, 'value': 6200}, {'week': 12, 'value': 7100}, {'week': 24, 'value': 5800},
  {'week': 38, 'value': 6600}, {'week': 51, 'value': 6400},
], 0.015);

final _peatSeries = _buildSeries(38, [
  {'week': 0, 'value': 38}, {'week': 16, 'value': 44}, {'week': 30, 'value': 35},
  {'week': 44, 'value': 40}, {'week': 51, 'value': 39},
], 0.010);

final _almondsSeries = _buildSeries(450, [
  {'week': 0, 'value': 450}, {'week': 10, 'value': 510}, {'week': 22, 'value': 400},
  {'week': 36, 'value': 470}, {'week': 51, 'value': 460},
], 0.018);

final _beansSeries = _buildSeries(430, [
  {'week': 0, 'value': 430}, {'week': 12, 'value': 490}, {'week': 24, 'value': 390},
  {'week': 38, 'value': 450}, {'week': 51, 'value': 440},
], 0.015);

final _butterSeries = _buildSeries(215, [
  {'week': 0, 'value': 215}, {'week': 10, 'value': 255}, {'week': 22, 'value': 195},
  {'week': 36, 'value': 235}, {'week': 51, 'value': 220},
], 0.018);

final _cocoaSeries = _buildSeries(6200, [
  {'week': 0, 'value': 6200}, {'week': 8, 'value': 8500}, {'week': 20, 'value': 6800},
  {'week': 34, 'value': 7400}, {'week': 51, 'value': 6800},
], 0.030);

final _fishSeries = _buildSeries(1520, [
  {'week': 0, 'value': 1520}, {'week': 14, 'value': 1780}, {'week': 26, 'value': 1420},
  {'week': 40, 'value': 1650}, {'week': 51, 'value': 1580},
], 0.016);

final _fruitJuicesSeries = _buildSeries(395, [
  {'week': 0, 'value': 395}, {'week': 10, 'value': 460}, {'week': 22, 'value': 360},
  {'week': 36, 'value': 430}, {'week': 51, 'value': 410},
], 0.022);

final _fruitsSeries = _buildSeries(820, [
  {'week': 0, 'value': 820}, {'week': 12, 'value': 940}, {'week': 24, 'value': 760},
  {'week': 38, 'value': 870}, {'week': 51, 'value': 840},
], 0.015);

final _honeySeries = _buildSeries(168, [
  {'week': 0, 'value': 168}, {'week': 12, 'value': 195}, {'week': 24, 'value': 152},
  {'week': 38, 'value': 178}, {'week': 51, 'value': 172},
], 0.014);

final _meatSeries = _buildSeries(84, [
  {'week': 0, 'value': 84}, {'week': 10, 'value': 98}, {'week': 22, 'value': 76},
  {'week': 36, 'value': 92}, {'week': 51, 'value': 88},
], 0.020);

final _milkSeries = _buildSeries(18.5, [
  {'week': 0, 'value': 18.5}, {'week': 12, 'value': 22.0}, {'week': 24, 'value': 17.0},
  {'week': 38, 'value': 20.5}, {'week': 51, 'value': 19.2},
], 0.016);

final _milletSeries = _buildSeries(220, [
  {'week': 0, 'value': 220}, {'week': 14, 'value': 260}, {'week': 28, 'value': 200},
  {'week': 42, 'value': 235}, {'week': 51, 'value': 225},
], 0.015);

final _molassesSeries = _buildSeries(138, [
  {'week': 0, 'value': 138}, {'week': 12, 'value': 160}, {'week': 24, 'value': 125},
  {'week': 38, 'value': 148}, {'week': 51, 'value': 142},
], 0.014);

final _naturalRubberSeries = _buildSeries(1620, [
  {'week': 0, 'value': 1620}, {'week': 10, 'value': 1900}, {'week': 22, 'value': 1480},
  {'week': 36, 'value': 1780}, {'week': 51, 'value': 1720},
], 0.020);

final _nutsSeries = _buildSeries(2350, [
  {'week': 0, 'value': 2350}, {'week': 12, 'value': 2700}, {'week': 24, 'value': 2150},
  {'week': 38, 'value': 2500}, {'week': 51, 'value': 2420},
], 0.016);

final _oatsSeries = _buildSeries(380, [
  {'week': 0, 'value': 380}, {'week': 10, 'value': 430}, {'week': 22, 'value': 350},
  {'week': 36, 'value': 400}, {'week': 51, 'value': 385},
], 0.015);

final _peanutsSeries = _buildSeries(520, [
  {'week': 0, 'value': 520}, {'week': 12, 'value': 590}, {'week': 24, 'value': 475},
  {'week': 38, 'value': 545}, {'week': 51, 'value': 530},
], 0.015);

final _riceSeries = _buildSeries(580, [
  {'week': 0, 'value': 580}, {'week': 8, 'value': 680}, {'week': 20, 'value': 520},
  {'week': 34, 'value': 610}, {'week': 51, 'value': 545},
], 0.018);

final _silkSeries = _buildSeries(36, [
  {'week': 0, 'value': 36}, {'week': 12, 'value': 42}, {'week': 24, 'value': 32},
  {'week': 38, 'value': 39}, {'week': 51, 'value': 37},
], 0.016);

final _sorghumSeries = _buildSeries(205, [
  {'week': 0, 'value': 205}, {'week': 10, 'value': 235}, {'week': 22, 'value': 185},
  {'week': 36, 'value': 215}, {'week': 51, 'value': 210},
], 0.015);

final _spicesSeries = _buildSeries(5100, [
  {'week': 0, 'value': 5100}, {'week': 10, 'value': 6200}, {'week': 22, 'value': 4800},
  {'week': 36, 'value': 5600}, {'week': 51, 'value': 5400},
], 0.022);

final _teaSeries = _buildSeries(2.75, [
  {'week': 0, 'value': 2.75}, {'week': 12, 'value': 3.20}, {'week': 24, 'value': 2.50},
  {'week': 38, 'value': 3.00}, {'week': 51, 'value': 2.90},
], 0.016);

final _vegetableJuicesSeries = _buildSeries(480, [
  {'week': 0, 'value': 480}, {'week': 14, 'value': 550}, {'week': 28, 'value': 440},
  {'week': 42, 'value': 510}, {'week': 51, 'value': 490},
], 0.013);

final _vegetableOilsSeries = _buildSeries(870, [
  {'week': 0, 'value': 870}, {'week': 10, 'value': 1020}, {'week': 22, 'value': 790},
  {'week': 36, 'value': 940}, {'week': 51, 'value': 890},
], 0.018);

final _vegetablesSeries = _buildSeries(680, [
  {'week': 0, 'value': 680}, {'week': 12, 'value': 780}, {'week': 24, 'value': 620},
  {'week': 38, 'value': 720}, {'week': 51, 'value': 695},
], 0.016);

final _waterSeries = _buildSeries(820, [
  {'week': 0, 'value': 820}, {'week': 10, 'value': 1050}, {'week': 22, 'value': 720},
  {'week': 36, 'value': 980}, {'week': 51, 'value': 860},
], 0.025);

final _woolSeries = _buildSeries(12.8, [
  {'week': 0, 'value': 12.8}, {'week': 12, 'value': 14.5}, {'week': 24, 'value': 11.8},
  {'week': 38, 'value': 13.6}, {'week': 51, 'value': 13.2},
], 0.015);

final _commodityChemicalsSeries = _buildSeries(830, [
  {'week': 0, 'value': 830}, {'week': 12, 'value': 960}, {'week': 24, 'value': 740},
  {'week': 38, 'value': 890}, {'week': 51, 'value': 850},
], 0.018);

final _dyesSeries = _buildSeries(5600, [
  {'week': 0, 'value': 5600}, {'week': 14, 'value': 6400}, {'week': 28, 'value': 5100},
  {'week': 42, 'value': 5900}, {'week': 51, 'value': 5700},
], 0.014);

final _nitrogenSeries = _buildSeries(290, [
  {'week': 0, 'value': 290}, {'week': 10, 'value': 360}, {'week': 22, 'value': 250},
  {'week': 36, 'value': 310}, {'week': 51, 'value': 285},
], 0.022);

final _phosphateRockSeries = _buildSeries(135, [
  {'week': 0, 'value': 135}, {'week': 12, 'value': 160}, {'week': 24, 'value': 118},
  {'week': 38, 'value': 148}, {'week': 51, 'value': 132},
], 0.015);

final _pigmentsSeries = _buildSeries(2750, [
  {'week': 0, 'value': 2750}, {'week': 14, 'value': 3100}, {'week': 28, 'value': 2550},
  {'week': 42, 'value': 2900}, {'week': 51, 'value': 2800},
], 0.013);

final _plasticsSeries = _buildSeries(1080, [
  {'week': 0, 'value': 1080}, {'week': 12, 'value': 1240}, {'week': 24, 'value': 960},
  {'week': 38, 'value': 1150}, {'week': 51, 'value': 1090},
], 0.016);

final _potashSeries = _buildSeries(268, [
  {'week': 0, 'value': 268}, {'week': 10, 'value': 320}, {'week': 22, 'value': 235},
  {'week': 36, 'value': 285}, {'week': 51, 'value': 260},
], 0.018);

final _saltSeries = _buildSeries(58, [
  {'week': 0, 'value': 58}, {'week': 16, 'value': 66}, {'week': 30, 'value': 54},
  {'week': 44, 'value': 62}, {'week': 51, 'value': 60},
], 0.010);

final _sodaAshSeries = _buildSeries(185, [
  {'week': 0, 'value': 185}, {'week': 12, 'value': 225}, {'week': 24, 'value': 165},
  {'week': 38, 'value': 205}, {'week': 51, 'value': 190},
], 0.018);

final _sulfurSeries = _buildSeries(95, [
  {'week': 0, 'value': 95}, {'week': 10, 'value': 118}, {'week': 22, 'value': 80},
  {'week': 36, 'value': 105}, {'week': 51, 'value': 92},
], 0.020);

final _syntheticFibersSeries = _buildSeries(980, [
  {'week': 0, 'value': 980}, {'week': 12, 'value': 1120}, {'week': 24, 'value': 890},
  {'week': 38, 'value': 1060}, {'week': 51, 'value': 1000},
], 0.015);

final _syntheticRubberSeries = _buildSeries(1560, [
  {'week': 0, 'value': 1560}, {'week': 12, 'value': 1800}, {'week': 24, 'value': 1420},
  {'week': 38, 'value': 1680}, {'week': 51, 'value': 1600},
], 0.017);

final _abrasivesSeries = _buildSeries(940, [
  {'week': 0, 'value': 940}, {'week': 14, 'value': 1080}, {'week': 28, 'value': 870},
  {'week': 42, 'value': 1000}, {'week': 51, 'value': 960},
], 0.013);

final _bauxiteSeries = _buildSeries(50, [
  {'week': 0, 'value': 50}, {'week': 12, 'value': 60}, {'week': 24, 'value': 44},
  {'week': 38, 'value': 55}, {'week': 51, 'value': 52},
], 0.014);

final _cementSeries = _buildSeries(88, [
  {'week': 0, 'value': 88}, {'week': 14, 'value': 102}, {'week': 28, 'value': 80},
  {'week': 42, 'value': 94}, {'week': 51, 'value': 90},
], 0.012);

final _claySeries = _buildSeries(170, [
  {'week': 0, 'value': 170}, {'week': 14, 'value': 196}, {'week': 28, 'value': 158},
  {'week': 42, 'value': 182}, {'week': 51, 'value': 175},
], 0.012);

final _constructionAggregateSeries = _buildSeries(12, [
  {'week': 0, 'value': 12}, {'week': 16, 'value': 14}, {'week': 32, 'value': 11},
  {'week': 44, 'value': 13}, {'week': 51, 'value': 12.5},
], 0.010);

final _diamondSeries = _buildSeries(1.10, [
  {'week': 0, 'value': 1.10}, {'week': 12, 'value': 1.35}, {'week': 24, 'value': 0.95},
  {'week': 38, 'value': 1.20}, {'week': 51, 'value': 1.12},
], 0.018);

final _diatomiteSeries = _buildSeries(288, [
  {'week': 0, 'value': 288}, {'week': 14, 'value': 330}, {'week': 28, 'value': 265},
  {'week': 42, 'value': 308}, {'week': 51, 'value': 295},
], 0.012);

final _feldsparSeries = _buildSeries(82, [
  {'week': 0, 'value': 82}, {'week': 16, 'value': 94}, {'week': 30, 'value': 76},
  {'week': 44, 'value': 88}, {'week': 51, 'value': 84},
], 0.010);

final _gemstonesSeries = _buildSeries(820, [
  {'week': 0, 'value': 820}, {'week': 10, 'value': 980}, {'week': 22, 'value': 720},
  {'week': 36, 'value': 900}, {'week': 51, 'value': 850},
], 0.020);

final _glassSilicaSeries = _buildSeries(36, [
  {'week': 0, 'value': 36}, {'week': 14, 'value': 42}, {'week': 28, 'value': 32},
  {'week': 42, 'value': 39}, {'week': 51, 'value': 37},
], 0.012);

final _graphiteSeries = _buildSeries(860, [
  {'week': 0, 'value': 860}, {'week': 10, 'value': 1040}, {'week': 22, 'value': 760},
  {'week': 36, 'value': 950}, {'week': 51, 'value': 880},
], 0.020);

final _gravelSeries = _buildSeries(10, [
  {'week': 0, 'value': 10}, {'week': 18, 'value': 12}, {'week': 34, 'value': 9.5},
  {'week': 46, 'value': 11}, {'week': 51, 'value': 10.5},
], 0.010);

final _gypsumSeries = _buildSeries(19, [
  {'week': 0, 'value': 19}, {'week': 16, 'value': 22}, {'week': 30, 'value': 17},
  {'week': 44, 'value': 21}, {'week': 51, 'value': 20},
], 0.011);

final _limeSeries = _buildSeries(125, [
  {'week': 0, 'value': 125}, {'week': 14, 'value': 145}, {'week': 28, 'value': 115},
  {'week': 42, 'value': 135}, {'week': 51, 'value': 128},
], 0.012);

final _limestoneSeries = _buildSeries(23, [
  {'week': 0, 'value': 23}, {'week': 18, 'value': 27}, {'week': 34, 'value': 21},
  {'week': 46, 'value': 25}, {'week': 51, 'value': 24},
], 0.010);

final _marbleSeries = _buildSeries(185, [
  {'week': 0, 'value': 185}, {'week': 12, 'value': 215}, {'week': 24, 'value': 170},
  {'week': 38, 'value': 200}, {'week': 51, 'value': 192},
], 0.013);

final _quartzCrystalSeries = _buildSeries(4400, [
  {'week': 0, 'value': 4400}, {'week': 10, 'value': 5200}, {'week': 22, 'value': 4000},
  {'week': 36, 'value': 4800}, {'week': 51, 'value': 4600},
], 0.016);

final _rocksSeries = _buildSeries(48, [
  {'week': 0, 'value': 48}, {'week': 16, 'value': 56}, {'week': 30, 'value': 44},
  {'week': 44, 'value': 52}, {'week': 51, 'value': 50},
], 0.011);

final _sandSeries = _buildSeries(27, [
  {'week': 0, 'value': 27}, {'week': 14, 'value': 32}, {'week': 28, 'value': 24},
  {'week': 42, 'value': 30}, {'week': 51, 'value': 28},
], 0.013);

final _stoneSeries = _buildSeries(24, [
  {'week': 0, 'value': 24}, {'week': 18, 'value': 28}, {'week': 34, 'value': 22},
  {'week': 46, 'value': 26}, {'week': 51, 'value': 25},
], 0.010);

final _talcSeries = _buildSeries(150, [
  {'week': 0, 'value': 150}, {'week': 14, 'value': 172}, {'week': 28, 'value': 138},
  {'week': 42, 'value': 162}, {'week': 51, 'value': 155},
], 0.012);

final _bambooSeries = _buildSeries(278, [
  {'week': 0, 'value': 278}, {'week': 12, 'value': 320}, {'week': 24, 'value': 255},
  {'week': 38, 'value': 300}, {'week': 51, 'value': 285},
], 0.015);

final _lumberSeries = _buildSeries(420, [
  {'week': 0, 'value': 420}, {'week': 8, 'value': 580}, {'week': 18, 'value': 350},
  {'week': 32, 'value': 480}, {'week': 51, 'value': 390},
], 0.030);

final _goldSeries = _buildSeries(2050, [
  {'week': 0, 'value': 2050},
  {'week': 10, 'value': 2380},
  {'week': 22, 'value': 2200},
  {'week': 36, 'value': 2500},
  {'week': 51, 'value': 2640},
], 0.010);

final _silverSeries = _buildSeries(24.0, [
  {'week': 0, 'value': 24.0},
  {'week': 12, 'value': 30.0},
  {'week': 24, 'value': 26.5},
  {'week': 38, 'value': 32.0},
  {'week': 51, 'value': 31.0},
], 0.020);

final _zincSeries = _buildSeries(2400, [
  {'week': 0, 'value': 2400},
  {'week': 14, 'value': 2800},
  {'week': 26, 'value': 2350},
  {'week': 40, 'value': 2600},
  {'week': 51, 'value': 2550},
], 0.016);

final _coalSeries = _buildSeries(130, [
  {'week': 0, 'value': 130},
  {'week': 8, 'value': 155},
  {'week': 20, 'value': 110},
  {'week': 36, 'value': 125},
  {'week': 51, 'value': 118},
], 0.018);

final _uraniumSeries = _buildSeries(92, [
  {'week': 0, 'value': 92},
  {'week': 10, 'value': 106},
  {'week': 22, 'value': 95},
  {'week': 34, 'value': 115},
  {'week': 51, 'value': 108},
], 0.012);

final _cornSeries = _buildSeries(485, [
  {'week': 0, 'value': 485},
  {'week': 10, 'value': 520},
  {'week': 22, 'value': 440},
  {'week': 36, 'value': 475},
  {'week': 51, 'value': 460},
], 0.015);

final _soybeanSeries = _buildSeries(1180, [
  {'week': 0, 'value': 1180},
  {'week': 12, 'value': 1320},
  {'week': 24, 'value': 1080},
  {'week': 38, 'value': 1200},
  {'week': 51, 'value': 1160},
], 0.016);

final _sugarSeries = _buildSeries(22.5, [
  {'week': 0, 'value': 22.5},
  {'week': 8, 'value': 26.0},
  {'week': 18, 'value': 19.5},
  {'week': 32, 'value': 23.0},
  {'week': 51, 'value': 21.0},
], 0.022);

final _coffeeSeries = _buildSeries(185, [
  {'week': 0, 'value': 185},
  {'week': 8, 'value': 220},
  {'week': 18, 'value': 260},
  {'week': 30, 'value': 310},
  {'week': 51, 'value': 295},
], 0.025);

// ── Full analysis map ───────────────────────────────────────────────────────

final Map<String, MaterialAnalysis> kMockAnalysis = {
  'chromium': MaterialAnalysis(
    materialId: 'chromium',
    currentPrice: 1390,
    priceChange1W: -0.6,
    priceChange1M: -2.8,
    priceData1Y: _chromiumSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'South African Power Crisis', detail: 'Load-shedding at South African smelters curtailed ferrochrome output by an estimated 15%, tightening the market sharply.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Chinese Stainless Output Cut', detail: 'Major Chinese stainless mills reduced production amid weak domestic demand, reducing chromium ore draw and weighing on prices.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Stainless Steel Production', explanation: 'About 90% of chromium goes into stainless steel. Chinese stainless output — the largest in the world — is the dominant demand driver, making Chinese property and manufacturing cycles decisive for chromium prices.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'South African Supply Concentration', explanation: 'South Africa holds over 70% of global chromite reserves. Power shortages, labour disputes, and infrastructure bottlenecks create persistent supply-side uncertainty.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Battery & Chemical Demand', explanation: 'Chromium chemicals and chromium-based battery technologies represent a small but growing secondary demand source independent of the stainless cycle.', direction: PriceDirection.up, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 6, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -7, mid: 3, high: 12, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -10, mid: 5, high: 18, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If South African smelters face new outages', trigger: 'Extended load-shedding or labour strikes at major SA ferrochrome producers.', action: 'Stainless and specialty steel buyers may find current ferrochrome pricing attractive for 6-month forward contracts.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese stainless demand weakens', trigger: 'Chinese stainless output falls below 28 million tonnes annualised.', action: 'Spot purchasing may outperform forward contracts; reduce forward coverage ratios until demand signals improve.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current balanced conditions', trigger: 'Stainless output stable and SA supply relatively uninterrupted.', action: 'Prices appear fairly valued. A mix of spot and short-dated forwards suits most buyers.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'iron': MaterialAnalysis(
    materialId: 'iron',
    currentPrice: 105,
    priceChange1W: -1.8,
    priceChange1M: -6.5,
    priceData1Y: _ironSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'China Stimulus Package', detail: 'Beijing announced infrastructure spending worth CNY 500B, sparking a short-lived rally in iron ore as traders priced in higher steel demand.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'Vale Production Record', detail: 'Brazilian miner Vale reported quarterly iron ore output at a five-year high, adding significant seaborne supply and reversing the stimulus-driven rally.', impact: PriceDirection.down),
      PriceEvent(weekIndex: 36, title: 'Chinese Blast Furnace Restarts', detail: 'A seasonal uptick in Chinese steel production ahead of the construction season lifted iron ore demand expectations and supported prices.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Chinese Steel Production', explanation: 'China produces over 50% of global steel and consumes roughly 70% of seaborne iron ore. Any shift in Chinese blast furnace utilisation rates drives immediate price responses in the iron ore market.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Australian & Brazilian Supply', explanation: 'Rio Tinto, BHP, and Vale collectively supply over 60% of seaborne iron ore. Their quarterly production guidance and shipping data are closely watched leading indicators.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Steel Decarbonisation Shift', explanation: 'The gradual transition from blast furnace to electric arc furnace steelmaking reduces iron ore intensity per tonne of steel, representing a long-term structural demand headwind.', direction: PriceDirection.down, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -7, mid: -1, high: 5, confidence: 0.69),
      ForecastHorizon(label: '3 Months', low: -10, mid: 2, high: 12, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -14, mid: 4, high: 18, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Chinese construction activity rebounds', trigger: 'Monthly Chinese crude steel output exceeds 95 million tonnes for two consecutive months.', action: 'Steel mills with spot iron ore exposure may consider extending forward cover before a demand-driven rally develops.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese property sector stays weak', trigger: 'New home starts remain more than 15% below prior year for another quarter.', action: 'Spot market purchases likely remain more economical than long-dated contracts; delay forward commitments.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under modest stimulus support', trigger: 'Chinese stimulus provides partial construction support without a full demand recovery.', action: 'Iron ore is likely range-bound between \$95 and \$120. Monthly procurement tranches limit timing risk.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'magnesium': MaterialAnalysis(
    materialId: 'magnesium',
    currentPrice: 2980,
    priceChange1W: 1.2,
    priceChange1M: 3.4,
    priceData1Y: _magnesiumSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Chinese Energy Rationing', detail: 'Power rationing in Shaanxi province — China\'s primary magnesium-producing region — cut output by an estimated 30%, shocking global supply chains that source over 85% of magnesium from China.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 26, title: 'Automotive Lightweighting Orders', detail: 'Major European OEMs announced expanded use of magnesium die castings in EV platforms, boosting demand forecasts and supporting a price recovery.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Chinese Production Dominance', explanation: 'China produces over 85% of global magnesium metal. This extreme concentration means Chinese energy policy, environmental regulations, and export controls have an outsized impact on global availability and pricing.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Automotive Lightweighting Demand', explanation: 'Magnesium is the lightest structural metal. Its adoption in EV battery casings, steering wheels, and seat frames is growing as automakers chase range improvements through weight reduction.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Aluminium Alloying Demand', explanation: 'Roughly 40% of magnesium consumption goes into aluminium alloys for automotive sheet and beverage cans. Aluminium production growth provides a steady demand base.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 2, high: 8, confidence: 0.65),
      ForecastHorizon(label: '3 Months', low: -5, mid: 5, high: 15, confidence: 0.49),
      ForecastHorizon(label: '6 Months', low: -8, mid: 9, high: 24, confidence: 0.35),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Chinese energy rationing recurs', trigger: 'Further power restrictions or environmental shutdowns in Shaanxi or Ningxia provinces.', action: 'Automotive and aluminium alloy buyers should maintain safety stock above normal levels given the speed with which Chinese supply shocks can move prices.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese production normalises', trigger: 'Chinese energy supply stabilises and output returns to full capacity for a sustained period.', action: 'Spot purchasing may offer better value as inventory rebuilds. Long-dated contracts at current levels carry downside risk.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current tight supply', trigger: 'Chinese output constrained but not in acute crisis; automotive demand growing steadily.', action: 'Magnesium is structurally vulnerable to supply shocks. Holding 60–90 days of inventory is prudent risk management for critical users.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'manganese': MaterialAnalysis(
    materialId: 'manganese',
    currentPrice: 335,
    priceChange1W: -0.9,
    priceChange1M: -2.4,
    priceData1Y: _manganeseSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Gabon Political Disruption', detail: 'Political instability following a change of government in Gabon — one of the top three manganese ore producers — temporarily disrupted mine output and exports, tightening the market.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Chinese Ferromanganese Oversupply', detail: 'Chinese ferromanganese producers, running at high utilisation rates, flooded export markets and drove alloy prices sharply lower, weighing on upstream ore demand.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Steel Industry Demand', explanation: 'Approximately 90% of manganese is consumed in steelmaking as a deoxidiser and alloying agent. The health of global steel output — particularly in China — is the primary demand variable.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Battery Grade Manganese Growth', explanation: 'High-purity manganese sulphate for lithium-manganese-iron-phosphate (LMFP) batteries is an emerging demand source that commands a premium over standard ore and is growing rapidly.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'South Africa & Gabon Supply', explanation: 'South Africa and Gabon together supply over 60% of global manganese ore. Political risk, logistics bottlenecks, and infrastructure investment drive supply-side variability.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 6, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -7, mid: 3, high: 11, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -10, mid: 5, high: 17, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If LMFP battery demand accelerates', trigger: 'Major Chinese battery makers announce LMFP capacity expansions requiring high-purity manganese sulphate.', action: 'Battery-grade manganese supply is thin. Buyers requiring high-purity material should consider locking in supply agreements early.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese steel output falls', trigger: 'Chinese crude steel production drops below 85 million tonnes per month.', action: 'Ferromanganese and ore prices could soften materially. Spot purchasing is preferable to forward contracts in that scenario.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current conditions', trigger: 'Stable steel output and gradual battery demand growth.', action: 'Manganese appears fairly valued. Staged procurement manages both steel cycle risk and the emerging battery premium dynamic.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'metal_alloys': MaterialAnalysis(
    materialId: 'metal_alloys',
    currentPrice: 1520,
    priceChange1W: 0.5,
    priceChange1M: -1.8,
    priceData1Y: _metalAlloysSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Aerospace Order Surge', detail: 'A record backlog at major aircraft manufacturers drove a sharp increase in nickel superalloy and titanium aluminide procurement, lifting specialty alloy prices broadly.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 28, title: 'Defence Budget Cuts in Europe', detail: 'Several European governments revised defence spending plans downward, reducing near-term demand for armour steel and specialist alloys used in military platforms.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Aerospace & Defence Demand', explanation: 'High-performance alloys — nickel superalloys, titanium alloys, maraging steels — are irreplaceable in jet engine turbines, airframe structures, and military equipment. Aerospace cycle recovery is the primary demand driver.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Constituent Metal Prices', explanation: 'Specialty alloy prices are directly tied to the cost of constituent metals (nickel, chromium, cobalt, molybdenum). Moves in any of these base materials flow through to alloy pricing with a short lag.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Energy Sector Demand', explanation: 'Oil and gas equipment, power turbines, and nuclear reactor components all require corrosion- and heat-resistant alloys. Energy sector capex cycles drive a secondary demand stream independent of aerospace.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 6, confidence: 0.65),
      ForecastHorizon(label: '3 Months', low: -5, mid: 3, high: 11, confidence: 0.49),
      ForecastHorizon(label: '6 Months', low: -8, mid: 6, high: 18, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If aerospace demand accelerates', trigger: 'Boeing or Airbus further increase production rate targets, pulling forward alloy procurement schedules.', action: 'Specialty alloy lead times can extend to 12–18 months. Early engagement with qualified suppliers is more effective than price hedging alone.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If constituent metal prices fall', trigger: 'Nickel and cobalt prices fall more than 15% on oversupply.', action: 'Wait for alloy spot pricing to reflect lower input costs before committing to large forward positions.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current aerospace recovery', trigger: 'Commercial aircraft production ramps gradually; defence demand stable.', action: 'Alloy availability rather than price is the primary risk. Qualifying multiple approved suppliers provides more resilience than price hedging.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'molybdenum': MaterialAnalysis(
    materialId: 'molybdenum',
    currentPrice: 21.5,
    priceChange1W: 0.9,
    priceChange1M: 2.3,
    priceData1Y: _molybdenumSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'Freeport Copper Mine Output Rise', detail: 'Molybdenum is primarily a byproduct of copper mining. Record copper output at Freeport\'s Grasberg mine added significant molybdenum supply, capping price upside.', impact: PriceDirection.down),
      PriceEvent(weekIndex: 22, title: 'Oil & Gas Tubular Demand Spike', detail: 'Rising oil prices spurred a capex recovery in deepwater drilling, boosting demand for high-strength low-alloy (HSLA) steel tubing requiring molybdenum additions.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Byproduct of Copper Mining', explanation: 'Approximately 50% of molybdenum supply comes as a byproduct of porphyry copper mines. When copper mines increase output, molybdenum supply rises regardless of molybdenum demand — creating periodic price depressions.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'High-Strength Steel & Energy Demand', explanation: 'Molybdenum is a critical alloying agent for pipeline steel, pressure vessels, and drill strings used in oil and gas. Energy sector capex is the dominant demand driver.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Chemical Catalysis', explanation: 'Molybdenum catalysts are used in petroleum refining hydrodesulfurisation units. Refinery throughput and catalyst replacement cycles provide a steady secondary demand stream.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: 1, high: 8, confidence: 0.64),
      ForecastHorizon(label: '3 Months', low: -8, mid: 3, high: 14, confidence: 0.48),
      ForecastHorizon(label: '6 Months', low: -12, mid: 6, high: 22, confidence: 0.34),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If oil capex surges', trigger: 'Oil prices sustain above \$90/bbl, prompting large deepwater project final investment decisions.', action: 'Specialty steel producers supplying OCTG pipe may find current molybdenum prices attractive for forward purchasing before an energy-driven demand rally.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If copper mine expansions flood supply', trigger: 'New copper mines with high molybdenum byproduct ratios begin commercial production.', action: 'Spot purchases may remain advantageous. Forward contracting above current spot levels risks locking in elevated prices into an oversupplied market.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under balanced energy sector demand', trigger: 'Steady oil capex and stable copper byproduct supply.', action: 'Molybdenum is likely to trade in a \$18–25/lb range. A mix of spot and short-term contracts manages the byproduct supply volatility.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'palladium': MaterialAnalysis(
    materialId: 'palladium',
    currentPrice: 960,
    priceChange1W: -1.4,
    priceChange1M: -5.8,
    priceData1Y: _palladiumSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'Norilsk Output Guidance', detail: 'Nornickel, supplying ~40% of global palladium, guided toward higher 2025 production following mine rehabilitation, adding supply and weighing on prices.', impact: PriceDirection.down),
      PriceEvent(weekIndex: 22, title: 'Gasoline Vehicle Sales Recovery', detail: 'Stronger-than-expected gasoline car sales in the US and Europe lifted autocatalyst palladium demand forecasts for the year.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Gasoline Autocatalyst Substitution Risk', explanation: 'Palladium is used almost exclusively in gasoline catalytic converters. The long-term shift to battery EVs represents an existential structural demand threat, though near-term internal combustion engine sales remain robust.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Russian Supply Concentration', explanation: 'Russia (primarily Nornickel) supplies roughly 40% of global palladium. Sanctions, export restrictions, or operational disruptions create severe supply-side risks that markets price as a premium.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Platinum Substitution', explanation: 'At sufficient price differentials, automakers can substitute platinum for palladium in gasoline catalysts. This substitution acts as a ceiling on palladium prices and a floor on platinum.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -6, mid: -1, high: 5, confidence: 0.64),
      ForecastHorizon(label: '3 Months', low: -10, mid: -2, high: 10, confidence: 0.48),
      ForecastHorizon(label: '6 Months', low: -14, mid: 0, high: 16, confidence: 0.34),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Russian supply is disrupted', trigger: 'New sanctions on Russian PGMs or Nornickel operational issues reduce exports.', action: 'Automotive manufacturers with just-in-time palladium purchasing are most exposed. Safety stock or longer-dated supply agreements provide resilience.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If EV penetration accelerates beyond forecasts', trigger: 'Global EV share of new car sales exceeds 30% in 2026.', action: 'Palladium demand could fall faster than supply adjusts. Minimising forward commitments and maximising spot exposure is appropriate.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current transition dynamics', trigger: 'Gradual EV growth and stable Russian supply.', action: 'Palladium faces structural headwinds from electrification but is supported by supply concentration risk. Short-dated procurement strategies are prudent given directional uncertainty.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'platinum': MaterialAnalysis(
    materialId: 'platinum',
    currentPrice: 970,
    priceChange1W: 1.0,
    priceChange1M: 3.2,
    priceData1Y: _platinumSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'South African Mine Strike', detail: 'A six-week strike at Impala Platinum\'s Rustenburg operations removed approximately 80,000 oz from the market and pushed platinum to a six-month high.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Hydrogen Electrolyser Orders', detail: 'A major European green hydrogen tender specified platinum-group metal electrolysers, boosting long-term platinum demand forecasts and lifting spot sentiment.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Green Hydrogen Opportunity', explanation: 'Proton exchange membrane (PEM) electrolysers use platinum as a catalyst. The emerging green hydrogen economy — if it scales as governments project — represents a significant new demand stream that did not exist a decade ago.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Diesel Autocatalyst Demand', explanation: 'Platinum is the primary PGM in diesel catalytic converters. Diesel\'s share of new vehicle sales has declined in Europe, but heavy transport (trucks, buses) continues to provide a durable demand base.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'South African Supply Risk', explanation: 'South Africa produces roughly 75% of global platinum. Electricity shortages, ageing mines, and labour relations in the Bushveld Complex create recurring supply-side risks.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 2, high: 8, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -6, mid: 5, high: 15, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -9, mid: 9, high: 24, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If green hydrogen projects scale faster', trigger: 'More than 5 GW of PEM electrolyser capacity is commissioned globally in 2026.', action: 'Industrial users of platinum for catalysis and jewellery should consider extending forward coverage before electrolyser demand absorbs a material share of available supply.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If South African output recovers strongly', trigger: 'Load-shedding eases and SA platinum output returns to 4.5+ million oz annually.', action: 'Spot purchases may provide better value as supply pressure eases. Current forward prices may embed a supply-risk premium that unwinds.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current gradual recovery', trigger: 'Hydrogen demand grows but slowly; SA supply constrained but not in crisis.', action: 'Platinum is one of few commodities with credible new demand drivers. A modest strategic position in forward contracts may be warranted for industrial buyers with long planning horizons.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'rare_earths': MaterialAnalysis(
    materialId: 'rare_earths',
    currentPrice: 68,
    priceChange1W: -2.1,
    priceChange1M: -7.4,
    priceData1Y: _rareEarthsSeries,
    events: const [
      PriceEvent(weekIndex: 8, title: 'China Export Quota Cuts', detail: 'China\'s Ministry of Industry cut rare earth production and export quotas for H2 2025, triggering a sharp price spike across the rare earth complex as ex-China supply chains scrambled.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 20, title: 'MP Materials Expansion Online', detail: 'MP Materials\' Mountain Pass separation facility reached full capacity, adding the first significant non-Chinese rare earth processing capacity in a decade and partially relieving supply pressure.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Chinese Processing Monopoly', explanation: 'China controls approximately 85% of global rare earth processing capacity. Even ore mined elsewhere must often be processed in China. This structural dependency makes Chinese export and production policy the single most important variable for global prices.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'EV Motor & Wind Turbine Demand', explanation: 'Neodymium-praseodymium (NdPr) magnets are critical for the permanent magnet motors in EVs and direct-drive wind turbines. Accelerating energy transition is creating structural demand growth at a rate that non-Chinese supply cannot yet match.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Ex-China Supply Development', explanation: 'Lynas (Australia), MP Materials (US), and several African projects are developing processing capacity outside China. Progress is slow but represents a medium-term supply diversification that caps long-run price upside.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -6, mid: -1, high: 7, confidence: 0.62),
      ForecastHorizon(label: '3 Months', low: -10, mid: 3, high: 18, confidence: 0.46),
      ForecastHorizon(label: '6 Months', low: -12, mid: 8, high: 30, confidence: 0.32),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If China tightens export controls further', trigger: 'China announces new technology-specific rare earth export restrictions targeting EV or defence applications.', action: 'EV motor and wind turbine manufacturers should prioritise long-term supply agreements with non-Chinese qualified sources regardless of current spot prices.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If ex-China processing scales rapidly', trigger: 'Lynas or MP Materials doubles processing capacity within 12 months.', action: 'Prices could correct 15–25% as supply diversification reduces the China premium. Spot purchasing may outperform forward contracts in this scenario.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current constrained supply', trigger: 'Chinese quotas stable and ex-China processing grows gradually.', action: 'Rare earths carry a geopolitical risk premium that is unlikely to fully unwind. Supply security should take priority over price optimisation for critical users.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'silicon': MaterialAnalysis(
    materialId: 'silicon',
    currentPrice: 1380,
    priceChange1W: -1.0,
    priceChange1M: -4.2,
    priceData1Y: _siliconSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Chinese Polysilicon Overcapacity', detail: 'A wave of new Chinese polysilicon capacity came online simultaneously, crashing solar-grade silicon prices by 40% and dragging metallurgical silicon lower in sympathy.', impact: PriceDirection.down),
      PriceEvent(weekIndex: 24, title: 'EU Carbon Border Adjustment', detail: 'The EU\'s Carbon Border Adjustment Mechanism applied to silicon imports, increasing costs for Asian exporters and partially supporting European spot prices above global benchmarks.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Solar Energy Buildout', explanation: 'Photovoltaic cells are the fastest-growing end market for silicon. Global solar installations are at record levels, but the concurrent boom in Chinese polysilicon capacity has resulted in significant price deflation rather than price appreciation.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Semiconductor Demand', explanation: 'Electronic-grade silicon wafers for chips represent a high-value market where quality and supply chain certification matter far more than commodity price. Semiconductor cycle recovery is a positive demand driver.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Aluminium Industry Demand', explanation: 'Metallurgical-grade silicon is alloyed into aluminium for automotive and aerospace use. Stable aluminium production volumes provide a demand floor that limits downside in commodity silicon.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: -1, high: 5, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -8, mid: 2, high: 12, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -10, mid: 5, high: 18, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Chinese polysilicon capacity is curtailed', trigger: 'Chinese government enforces production discipline or environmental shutdowns in Xinjiang polysilicon facilities.', action: 'Solar manufacturers with spot silicon exposure would benefit from forward purchasing to protect against a supply shock recovery.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If polysilicon oversupply deepens', trigger: 'Chinese polysilicon inventory builds above 200,000 tonnes and further capacity additions come online.', action: 'Spot purchasing is likely to remain the most economical approach for metallurgical and solar-grade silicon through mid-2026.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current oversupply conditions', trigger: 'Gradual demand growth absorbs excess Chinese capacity over 12–18 months.', action: 'Silicon prices are depressed but likely near a floor. Spot purchasing with modest forward cover for 3–6 months balances the oversupply risk against any sudden policy-driven recovery.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'stainless_steel': MaterialAnalysis(
    materialId: 'stainless_steel',
    currentPrice: 1850,
    priceChange1W: 0.3,
    priceChange1M: -1.1,
    priceData1Y: _stainlessSteelSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Nickel Price Correction', detail: 'A sustained fall in LME nickel prices — stainless steel\'s most costly input — reduced raw material costs for mills and allowed price softening without margin compression.', impact: PriceDirection.down),
      PriceEvent(weekIndex: 26, title: 'EU Food Processing Investment', detail: 'A wave of EU food and beverage facility upgrades specified 316L stainless grades, boosting flat product demand in Europe above seasonal norms.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Nickel & Chromium Input Costs', explanation: 'Stainless steel pricing is directly linked to alloy surcharges based on LME nickel and ferrochrome prices. Moves in these inputs flow through to stainless list prices within weeks, making input cost tracking essential for procurement planning.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Chinese Production & Exports', explanation: 'China has become the dominant global stainless producer and exporter. Chinese export volumes regularly undercut European and Asian domestic producers, creating price pressure in importing markets.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Food, Chemical & Medical Demand', explanation: 'Stainless steel\'s corrosion resistance makes it irreplaceable in food processing, pharmaceutical, and medical applications. These sectors provide steady non-cyclical demand that limits downside.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 5, confidence: 0.70),
      ForecastHorizon(label: '3 Months', low: -5, mid: 2, high: 9, confidence: 0.54),
      ForecastHorizon(label: '6 Months', low: -8, mid: 4, high: 14, confidence: 0.40),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If nickel prices recover sharply', trigger: 'LME nickel rises above \$20,000/t on Indonesian supply restrictions or battery demand surge.', action: 'Stainless buyers running low inventory should consider restocking ahead of alloy surcharge increases that will follow within 4–6 weeks.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese export volumes increase', trigger: 'Chinese stainless exports exceed 500,000 tonnes per month for a second consecutive quarter.', action: 'Buyers in import-exposed markets may benefit from spot purchasing as Chinese-origin material undercuts domestic pricing.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current stable input costs', trigger: 'Nickel and chromium prices relatively stable; Chinese export volumes at current levels.', action: 'Stainless appears fairly priced. Monthly procurement tranches aligned with mill price validity windows minimise timing risk.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'tin': MaterialAnalysis(
    materialId: 'tin',
    currentPrice: 27500,
    priceChange1W: 1.1,
    priceChange1M: 4.2,
    priceData1Y: _tinSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'Myanmar Export Ban', detail: 'Myanmar\'s military government halted tin ore exports pending a resource tax review, removing roughly 15% of global mine supply and triggering the largest weekly price move in two years.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'Global Electronics Inventory Correction', detail: 'A broad consumer electronics inventory correction reduced solder demand from PCB manufacturers, the largest tin end-use, pulling prices off their highs.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Electronics Solder Demand', explanation: 'About 50% of tin consumption is in solder for printed circuit boards. Tin is essentially irreplaceable in this application — no comparable metal offers the same melting point, wetting properties, and non-toxicity. Electronics production cycles drive the dominant demand signal.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Indonesian & Myanmar Supply', explanation: 'Indonesia and Myanmar together supply over 50% of global tin. Indonesian export licensing and Myanmar political risk create recurring supply-side volatility in what is one of the smallest major metal markets by volume.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'AI & Data Centre PCB Demand', explanation: 'The explosion in AI server and data centre construction is driving above-trend demand for high-density PCBs requiring premium tin-silver solders, adding a new structural demand source.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 2, high: 8, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -7, mid: 4, high: 14, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -10, mid: 7, high: 22, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Myanmar export disruption extends', trigger: 'Myanmar export ban continues beyond 90 days or Indonesian export quotas are tightened simultaneously.', action: 'Electronics manufacturers and solder producers should consider building strategic inventory given tin\'s limited substitutability in PCB applications.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If electronics demand remains weak', trigger: 'Global smartphone shipments decline for a third consecutive quarter.', action: 'Tin prices could soften toward \$24,000–25,000. Spot purchasing is preferable to forward contracts during a demand correction.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current tight supply', trigger: 'Myanmar disruption partially resolved; electronics demand recovering gradually.', action: 'Tin is structurally undersupplied relative to long-term demand. Forward purchasing for 3–6 months provides sensible cost certainty given supply concentration risks.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'titanium': MaterialAnalysis(
    materialId: 'titanium',
    currentPrice: 6400,
    priceChange1W: 0.6,
    priceChange1M: 2.1,
    priceData1Y: _titaniumSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Boeing Production Rate Increase', detail: 'Boeing announced a 737 MAX and 787 production rate increase, significantly expanding titanium sponge requirements from its aerospace supply chain.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Russian Sponge Supply Disruption', detail: 'Western aerospace OEMs completed their transition away from Russian VSMPO-AVISMA titanium sponge, initially causing supply tension before new sources from Japan and Kazakhstan filled the gap.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Aerospace Production Ramp', explanation: 'Commercial aerospace consumes roughly 50% of titanium sponge. With Boeing and Airbus both ramping production rates to clear record backlogs, titanium demand is growing faster than qualified smelting capacity can expand.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Russian Supply Diversification', explanation: 'VSMPO-AVISMA previously supplied 30% of global titanium sponge. Western OEMs have largely diverted sourcing to Japan (TOHO, Osaka), Kazakhstan (UKTMP), and the US — a transition that created near-term supply tightness.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Medical & Industrial Demand', explanation: 'Titanium\'s biocompatibility drives demand for orthopaedic implants and surgical instruments. Medical applications provide a non-cyclical demand base that has grown consistently regardless of aerospace cycles.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 2, high: 7, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -5, mid: 4, high: 13, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -7, mid: 7, high: 20, confidence: 0.39),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If aerospace production rates accelerate', trigger: 'Boeing or Airbus announce further monthly rate increases beyond current targets.', action: 'Aerospace Tier 1 suppliers face the longest lead times — engaging with approved sponge and mill product suppliers 18–24 months ahead is more critical than spot price hedging.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If new sponge capacity comes online', trigger: 'New capacity in Kazakhstan or India reaches commercial output ahead of schedule.', action: 'A gradual supply easing could moderate prices toward \$5,800–6,000. Buyers with flexibility should monitor new capacity timelines before committing to long-dated contracts.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current aerospace ramp', trigger: 'Steady production rate increases and gradual supply chain expansion.', action: 'Titanium appears structurally tight for the next 2–3 years. Securing qualified supply through long-term agreements is a higher priority than price optimisation.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'peat': MaterialAnalysis(
    materialId: 'peat',
    currentPrice: 39,
    priceChange1W: 0.4,
    priceChange1M: 1.2,
    priceData1Y: _peatSeries,
    events: const [
      PriceEvent(weekIndex: 16, title: 'Ireland Peat Phase-Out Accelerated', detail: 'Ireland announced an accelerated timeline for ending commercial peat harvesting for energy use, reducing European peat fuel supply and lifting spot prices in Baltic markets.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 30, title: 'Horticultural Peat Demand Softens', detail: 'European regulatory pressure to phase out peat in gardening compost prompted UK and German retailers to accelerate adoption of peat-free alternatives, reducing horticultural demand.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Energy Transition Phase-Out', explanation: 'Peat-fired power generation is being phased out across Finland, Ireland, and the Baltic states under EU climate commitments. This structural demand destruction is the dominant long-term price headwind.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Horticultural & Growing Media', explanation: 'Peat moss remains the benchmark growing medium for professional horticulture and nurseries due to its water retention and pH properties. Regulatory pressure to switch is increasing but transition is slow in commercial applications.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Carbon Credit Competition', explanation: 'Rewetting degraded peatlands generates carbon credits, creating an opportunity cost for continued extraction. As carbon prices rise, the economic incentive to leave peat in the ground grows.', direction: PriceDirection.down, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 4, confidence: 0.72),
      ForecastHorizon(label: '3 Months', low: -5, mid: 0, high: 7, confidence: 0.57),
      ForecastHorizon(label: '6 Months', low: -8, mid: -1, high: 8, confidence: 0.43),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If cold winters increase energy demand', trigger: 'Severe winter across Finland and the Baltic states drives short-term heating fuel demand above available gas and biomass capacity.', action: 'Peat fuel users with storage capacity may find building seasonal inventory before winter an effective cost management strategy.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If EU phase-out accelerates', trigger: 'EU mandates accelerated peat phase-out timelines across member states.', action: 'Horticultural buyers should accelerate transition planning to peat-free alternatives to avoid supply availability risk as well as price risk.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current gradual transition', trigger: 'Regulatory phase-outs proceed on current timelines.', action: 'Peat is a declining commodity in most use cases. Procurement strategies should include transition planning for substitutes rather than focusing solely on price optimisation.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'almonds': MaterialAnalysis(
    materialId: 'almonds',
    currentPrice: 460,
    priceChange1W: -1.2,
    priceChange1M: -3.8,
    priceData1Y: _almondsSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'California Drought Restrictions', detail: 'New water allocation cuts in California\'s San Joaquin Valley forced almond growers to fallow acreage, reducing the projected 2025 crop by an estimated 8%.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'India Import Duty Reduction', detail: 'India reduced its almond import tariff from 100% to 60%, opening a large new demand channel and boosting US export volumes significantly.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 36, title: 'Record California Harvest', detail: 'Favourable spring conditions and above-average bee colony health produced a record California almond crop, reversing the earlier supply concern.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'California Water Availability', explanation: 'California produces roughly 80% of global almonds, and almond orchards require consistent irrigation over a 25-year tree lifespan. Water allocation policy and drought conditions are the single most critical production variable.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Asian Snack & Health Demand', explanation: 'India, China, and Southeast Asian markets are the fastest-growing almond consumers, driven by rising middle-class incomes and health-conscious snacking trends. Demand growth has been structurally higher than supply growth for a decade.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Pollination & Bee Colony Health', explanation: 'Almond trees require bee pollination, making colony health a critical annual production risk. Varroa mite infestations and pesticide exposure create recurring uncertainty in yield forecasts.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 7, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -7, mid: 3, high: 12, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -10, mid: 5, high: 18, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If California drought intensifies', trigger: 'State Water Resources Control Board issues Tier 2 or higher curtailment notices in major almond-growing counties.', action: 'Food manufacturers with almond-intensive products should consider locking in 6-month forward purchases before any supply shock rally.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If record harvest pressures prices', trigger: 'USDA final crop estimate exceeds 1.4 billion pounds.', action: 'Spot purchasing in October–November after harvest pressure peaks may offer the best annual buying opportunity.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current balanced conditions', trigger: 'Average crop and steady Asian demand growth.', action: 'Almonds appear fairly valued near current levels. Procurement in quarterly tranches manages seasonal harvest timing risk.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'beans': MaterialAnalysis(
    materialId: 'beans',
    currentPrice: 440,
    priceChange1W: -0.5,
    priceChange1M: -1.8,
    priceData1Y: _beansSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'East African Drought', detail: 'Prolonged dry conditions in Kenya, Ethiopia, and Tanzania — key small-scale bean producers — cut regional output and tightened African export availability.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'US Crop Above Expectations', detail: 'USDA\'s June acreage report showed US dry bean plantings 6% above prior year, as farmers responded to elevated prices with expanded cultivation.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Food Security & Protein Demand', explanation: 'Dry beans are a primary protein source for over 400 million people in Latin America, Africa, and South Asia. Rising populations and strained meat supply chains are strengthening structural demand for plant protein.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd2', headline: 'Weather Across Multiple Origins', explanation: 'Major producers — Argentina, Brazil, US, Myanmar, and East Africa — each have distinct growing seasons. Multi-origin weather risk means supply variability is persistent, not concentrated in a single seasonal event.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Freight & Logistics Costs', explanation: 'Dry beans are a relatively low-value-per-tonne commodity where ocean freight costs represent a significant share of landed price. Shipping rate volatility directly impacts trade economics.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 5, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -6, mid: 2, high: 9, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -9, mid: 3, high: 14, confidence: 0.39),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If La Niña disrupts South American crop', trigger: 'Argentine or Brazilian bean-growing regions face moisture deficits during pod-fill stage.', action: 'Food processors with bean-intensive products should consider pre-season sourcing agreements to lock in supply before any weather-driven rally.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If major origins report bumper harvests', trigger: 'USDA projects global dry bean ending stocks above 5-year average.', action: 'Spot purchasing after harvest is likely to offer the best price levels; delay large forward commitments until post-harvest availability is confirmed.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current balanced supply', trigger: 'Average crop across major origins and steady food demand.', action: 'Dry beans show limited price volatility compared to major grains. Quarterly procurement with modest safety stock is appropriate for most buyers.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'butter': MaterialAnalysis(
    materialId: 'butter',
    currentPrice: 220,
    priceChange1W: 1.4,
    priceChange1M: 3.8,
    priceData1Y: _butterSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'EU Milk Production Decline', detail: 'Lower EU farm milk deliveries driven by high feed costs and herd reduction led to reduced butter and cream availability, driving a sharp price recovery from 2024 lows.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'New Zealand Season Disappoints', detail: 'A drier-than-normal New Zealand summer reduced Fonterra\'s milk collection, lowering Southern Hemisphere butter export availability and amplifying the EU supply tightness.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'EU & New Zealand Production Cycles', explanation: 'European and Oceanian dairy farmers drive the majority of globally traded butter. EU farm profitability, milk quotas (where applicable), and New Zealand seasonal conditions are the primary supply variables.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Asian Import Demand', explanation: 'China, the Middle East, and Southeast Asia are the fastest-growing butter import markets, driven by expanding bakery and confectionery industries and rising dairy consumption per capita.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Fat-Sugar Competition in Food Formulation', explanation: 'When butter prices rise sharply, food manufacturers reformulate using palm oil, vegetable fat blends, or margarine. This substitution effect creates a price ceiling in industrial applications.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 2, high: 7, confidence: 0.69),
      ForecastHorizon(label: '3 Months', low: -5, mid: 4, high: 12, confidence: 0.53),
      ForecastHorizon(label: '6 Months', low: -8, mid: 6, high: 18, confidence: 0.39),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If EU milk production falls further', trigger: 'EU dairy herd contraction continues and Q3 farm gate prices remain below break-even for a second year.', action: 'Bakery and confectionery buyers with butter-intensive products should consider 6-month forward purchasing before the traditional pre-Christmas demand peak.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If New Zealand season recovers strongly', trigger: 'Fonterra raises its milk collection forecast above prior season volume.', action: 'Spot prices typically weaken in Q1 as Southern Hemisphere supply peaks. Timing large purchases for Q1 may offer cost advantages.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current constrained supply', trigger: 'EU production stable at lower levels; steady Asian import demand.', action: 'Butter remains in a structurally tighter supply environment than 2023–24. A mix of forward and spot purchasing balances cost certainty against further upside risk.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'cocoa': MaterialAnalysis(
    materialId: 'cocoa',
    currentPrice: 6800,
    priceChange1W: -2.4,
    priceChange1M: -8.2,
    priceData1Y: _cocoaSeries,
    events: const [
      PriceEvent(weekIndex: 8, title: 'West Africa Black Pod Crisis', detail: 'Exceptionally wet conditions in Ivory Coast and Ghana enabled a widespread black pod fungal outbreak, destroying an estimated 15–20% of the mid-crop and driving cocoa to all-time highs above \$8,500/t.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 20, title: 'Demand Destruction Signals', detail: 'Global chocolate manufacturers reported the first year-on-year volume decline in 15 years as consumer price resistance to record cocoa costs materialised in retail scanner data.', impact: PriceDirection.down),
      PriceEvent(weekIndex: 34, title: 'Ivory Coast Main Crop Improvement', detail: 'Better weather conditions supported an improved main crop outlook in Ivory Coast for 2025/26, offering the first credible supply recovery signal in 18 months.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'West African Production Crisis', explanation: 'Ivory Coast and Ghana supply 65% of global cocoa. A multi-year sequence of El Niño-driven drought, disease pressure, and ageing tree stock has created a structural production deficit not seen since the 1970s. Recovery requires replanting cycles of 3–5 years.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Demand Destruction at Extreme Prices', explanation: 'Cocoa prices above \$6,000/t are triggering measurable demand destruction — smaller chocolate bars, reformulation toward cocoa extenders, and consumer trade-down to non-chocolate confectionery.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Farmer Ageing & Tree Replanting', explanation: 'The average Ivorian cocoa farmer is over 50 years old and farming trees that are 25–30 years past peak productivity. Structural replanting investment is insufficient to prevent long-term yield decline without significant policy intervention.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -8, mid: -2, high: 6, confidence: 0.61),
      ForecastHorizon(label: '3 Months', low: -14, mid: -4, high: 10, confidence: 0.45),
      ForecastHorizon(label: '6 Months', low: -18, mid: 0, high: 20, confidence: 0.31),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If West African crop fails again', trigger: 'ICCO mid-crop estimate for Ivory Coast comes in below 400,000 tonnes.', action: 'Chocolate manufacturers should review their unhedged cocoa positions urgently. At current prices, even short-term exposure represents significant P&L risk.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If demand destruction deepens', trigger: 'Global chocolate volume sales decline more than 5% year-on-year.', action: 'Prices could correct toward \$5,000–5,500 as demand contraction outpaces supply recovery. Buyers with significant forward cover above current spot should review positions.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under gradual supply recovery', trigger: 'Improved main crop weather in West Africa and steady demand erosion at high prices.', action: 'Cocoa is likely to remain structurally elevated for 2–3 years until replanted trees mature. Procurement strategies must account for a persistently high cost environment rather than a return to pre-2023 price levels.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'fish': MaterialAnalysis(
    materialId: 'fish',
    currentPrice: 1580,
    priceChange1W: 0.8,
    priceChange1M: 2.5,
    priceData1Y: _fishSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Peru First Season Quota Cut', detail: 'IMARPE (Peru\'s marine research institute) recommended a 30% reduction in the first anchovy season quota citing below-average biomass surveys, sharply tightening fishmeal supply.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 26, title: 'El Niño Warm Water Impact', detail: 'Warm El Niño waters displaced anchovy shoals southward, making them inaccessible to the Peruvian fleet and further reducing effective fishing capacity.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Peruvian Anchovy Biomass', explanation: 'Peru produces roughly 35% of global fishmeal and fish oil from anchovy. IMARPE biomass surveys and resulting fishing quotas are the single most watched variable in the fishmeal market.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Aquaculture Feed Demand', explanation: 'The global aquaculture industry — particularly salmon, shrimp, and tilapia farming — is the dominant fishmeal consumer. Aquaculture production growth is structural and relatively price-inelastic, providing a firm demand floor.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Plant Protein Substitution', explanation: 'Soybean meal and other plant proteins are increasingly substituted for fishmeal in aquaculture diets as feed conversion technology improves. This substitution caps the price premium fishmeal can sustain over alternative proteins.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 2, high: 7, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -5, mid: 4, high: 13, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -8, mid: 7, high: 20, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Peru quotas are cut further', trigger: 'IMARPE recommends second season quota below 1 million tonnes.', action: 'Salmon and shrimp feed manufacturers should consider building 60–90 day fishmeal inventory as price spikes in restricted quota years can be swift and large.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If El Niño conditions ease', trigger: 'La Niña returns and Peru reports above-average anchovy biomass in mid-year surveys.', action: 'Spot purchasing becomes more attractive in bumper quota years. Limit forward commitments until the season quota is confirmed.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current quota-constrained market', trigger: 'Restricted quotas and steady aquaculture demand.', action: 'Fishmeal markets are structurally tight. Aquaculture producers should maintain relationships with multiple certified supply sources given Peru\'s quota unpredictability.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'fruit_juices': MaterialAnalysis(
    materialId: 'fruit_juices',
    currentPrice: 410,
    priceChange1W: -1.8,
    priceChange1M: -5.2,
    priceData1Y: _fruitJuicesSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'Florida Citrus Greening Impact', detail: 'USDA confirmed Florida orange production fell to a 90-year low due to citrus greening disease, reducing US FCOJ output by 35% and pushing futures to record highs.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'Brazil Record Orange Crop', detail: 'Brazil\'s São Paulo state reported a record 2025/26 orange crop, partially offsetting Florida shortfalls and capping the FCOJ rally.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Florida Citrus Greening Disease', explanation: 'Huanglongbing (citrus greening) has reduced Florida\'s orange production by over 90% from its peak. Florida was once the world\'s leading FCOJ producer; its near-elimination as a supply source is a structural market transformation.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Brazilian Production Dominance', explanation: 'Brazil now accounts for over 70% of globally traded FCOJ. São Paulo state orange crop conditions, harvesting weather, and Brazilian export logistics are the primary market variables.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Retail Demand Trends', explanation: 'Orange juice consumption has been in long-term structural decline in Western markets as consumers shift to fresh fruit and alternative beverages. This creates a demand headwind that partially offsets supply tightness.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -6, mid: -1, high: 6, confidence: 0.64),
      ForecastHorizon(label: '3 Months', low: -10, mid: 0, high: 12, confidence: 0.48),
      ForecastHorizon(label: '6 Months', low: -14, mid: 2, high: 20, confidence: 0.34),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Brazilian crop disappoints', trigger: 'FUNDECITRUS lowers São Paulo orange crop estimate by more than 8%.', action: 'Beverage manufacturers should consider extending FCOJ forward coverage as Brazilian supply shocks can produce rapid and large price moves in the thin FCOJ market.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Brazilian volumes exceed forecasts', trigger: 'Brazilian processing data shows weekly run rates above 5-year seasonal averages.', action: 'FCOJ prices could soften toward 350¢. Spot purchasing or reducing forward cover ratios may be preferable during periods of Brazilian supply abundance.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current tight supply', trigger: 'Florida remains impaired; Brazil provides adequate but not surplus supply.', action: 'FCOJ is structurally elevated due to Florida\'s permanent impairment. Pricing in a persistently higher cost environment is more appropriate than planning for a return to pre-2022 prices.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'fruits': MaterialAnalysis(
    materialId: 'fruits',
    currentPrice: 840,
    priceChange1W: 0.6,
    priceChange1M: 1.9,
    priceData1Y: _fruitsSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'European Spring Frost', detail: 'Late spring frost events across France, Spain, and Italy damaged stone fruit and apple orchards during critical flowering stages, reducing EU fruit export availability.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Chilean Season Opens', detail: 'Chile\'s record summer fruit season — covering grapes, cherries, blueberries, and citrus — opened with strong volumes, providing Northern Hemisphere retailers with competitive pricing.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Seasonal Production Cycles', explanation: 'Fresh fruit markets are inherently seasonal with supply rotating between Northern and Southern Hemisphere origins across the calendar year. Weather events at critical growth stages in key regions drive large short-term price volatility.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Asian Premium Market Demand', explanation: 'China and other Asian markets have become the most important destination for premium fresh fruit — particularly Chilean cherries, Australian mangoes, and US Honeycrisp apples. Demand growth has consistently outpaced production growth.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Cold Chain & Logistics Costs', explanation: 'Fresh fruit requires temperature-controlled logistics throughout the supply chain. Energy costs and refrigerated container availability are a significant and often underappreciated component of delivered fruit prices.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 7, confidence: 0.65),
      ForecastHorizon(label: '3 Months', low: -7, mid: 3, high: 12, confidence: 0.49),
      ForecastHorizon(label: '6 Months', low: -10, mid: 5, high: 18, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If weather damages key growing regions', trigger: 'Spring frost or drought warnings issued for EU, Chile, or California during critical growth periods.', action: 'Retailers and food processors with fruit-intensive product lines should monitor growing season conditions closely and pre-book logistics capacity early.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If bumper Southern Hemisphere seasons coincide', trigger: 'Chile, South Africa, and Australia all report above-average export volumes simultaneously.', action: 'Spot purchasing during peak Southern Hemisphere export windows (December–March) often provides the most competitive pricing of the year.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under normal seasonal conditions', trigger: 'Average weather across major origins; stable Asian demand.', action: 'Fruit procurement is inherently seasonal. Building annual supplier relationships with clear volume commitments provides more supply security than price hedging alone.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'honey': MaterialAnalysis(
    materialId: 'honey',
    currentPrice: 172,
    priceChange1W: 0.3,
    priceChange1M: 1.1,
    priceData1Y: _honeySeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Chinese Export Volume Increase', detail: 'China, the world\'s largest honey exporter, increased export volumes following record domestic production, weighing on global benchmark prices.', impact: PriceDirection.down),
      PriceEvent(weekIndex: 24, title: 'EU Honey Adulteration Scandal', detail: 'EU food authorities detected sugar syrup adulteration in a significant share of imported honey, triggering stricter quality testing that effectively restricted lower-grade import flows and supported legitimate origin premiums.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Bee Colony Health', explanation: 'Global bee colony populations are under pressure from varroa mite infestations, pesticide exposure, and habitat loss. Colony health directly affects honey yields and — critically — agricultural pollination services, linking honey prices to broader food system stability.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd2', headline: 'Chinese Supply Dominance', explanation: 'China produces roughly 25% of global honey and is the largest exporter by volume. Chinese production conditions and export pricing decisions have an outsized influence on global commodity honey benchmarks.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Premium & Specialty Demand', explanation: 'Manuka, raw, and origin-specific honeys command significant premiums over commodity grades and are growing faster than the commodity market. This premiumisation trend supports higher average price levels.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 5, confidence: 0.69),
      ForecastHorizon(label: '3 Months', low: -5, mid: 2, high: 8, confidence: 0.53),
      ForecastHorizon(label: '6 Months', low: -7, mid: 3, high: 12, confidence: 0.40),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If bee colony losses accelerate', trigger: 'USDA winter bee loss surveys report colony mortality above 40% for a second consecutive year.', action: 'Food manufacturers should review supply chain concentration risk given honey\'s limited substitutability in certain applications and the long lead time for colony recovery.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese export volumes surge', trigger: 'China reports a record domestic harvest and increases export allocation significantly.', action: 'Commodity honey prices could soften 10–15%. Spot purchasing may offer better value than multi-quarter forward contracts during periods of Chinese export abundance.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current stable conditions', trigger: 'Average colony health and steady Chinese export volumes.', action: 'Honey shows moderate price stability relative to other agricultural commodities. Annual supply agreements with certified suppliers balance cost and quality assurance needs.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'meat': MaterialAnalysis(
    materialId: 'meat',
    currentPrice: 88,
    priceChange1W: 1.2,
    priceChange1M: 3.5,
    priceData1Y: _meatSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'African Swine Fever Outbreak', detail: 'A new ASF outbreak in Eastern Europe caused precautionary culls in affected regions, tightening pork supply across European markets and pushing lean hog futures sharply higher.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'US Summer Grilling Demand', detail: 'Stronger-than-expected US retail beef demand during the summer grilling season reduced cutout inventories and supported cattle futures above seasonal norms.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 36, title: 'Feed Grain Price Collapse', detail: 'A record US corn and soybean harvest sharply reduced feed costs, improving producer margins and encouraging herd expansion — a bearish signal for meat prices 6–12 months forward.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Feed Cost Economics', explanation: 'Feed grains (corn, soybean meal) represent 60–70% of livestock production costs. Low grain prices improve producer margins and encourage herd expansion, creating a future supply overhang. High grain prices do the reverse, creating tightening supply after a 6–18 month lag.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Disease Risk', explanation: 'African swine fever, avian influenza, and foot-and-mouth disease can remove large volumes of supply instantly. Disease risk is an ever-present upside price risk that cannot be hedged through normal forward contract channels.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Consumer Protein Preferences', explanation: 'Rising protein demand in emerging markets — particularly China, Southeast Asia, and Africa — supports structural demand growth. In developed markets, plant-based alternatives are gaining share but from a small base.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 7, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -7, mid: 2, high: 12, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -10, mid: 3, high: 18, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If disease outbreak expands', trigger: 'ASF or avian influenza spread to new EU or US regions triggers regulatory culls.', action: 'Food service and retail meat buyers should maintain diversified supplier networks across multiple species and origins to manage disease-driven supply disruptions.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If record feed crop drives herd expansion', trigger: 'USDA confirms herd liquidation ends and cow-calf sector begins herd building.', action: 'Beef prices typically soften 12–18 months after herd rebuilding begins. Locking in large forward positions at current levels may prove costly.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current cyclical conditions', trigger: 'Stable feed costs and no new major disease outbreaks.', action: 'Meat markets follow predictable cyclical patterns. Aligning procurement timing with the cattle and hog cycles reduces average cost over a multi-year horizon.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'milk': MaterialAnalysis(
    materialId: 'milk',
    currentPrice: 19.2,
    priceChange1W: 0.8,
    priceChange1M: 2.1,
    priceData1Y: _milkSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'EU Farm Gate Price Recovery', detail: 'Rising EU farm gate milk prices driven by higher feed, energy, and labour costs incentivised modest production recovery after a period of herd contraction.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'New Zealand GDT Auction Drop', detail: 'A Global Dairy Trade auction in June showed whole milk powder prices falling 4.8% on the day, signalling near-term softness from New Zealand export flows.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'EU & New Zealand Production', explanation: 'These two regions supply the majority of globally traded dairy products. EU production is constrained by farm profitability and environmental regulations; New Zealand production is highly weather-sensitive and follows a sharp spring seasonal peak.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Chinese Dairy Import Demand', explanation: 'China is the largest single importer of whole milk powder and infant formula ingredients. Chinese dairy import volumes — influenced by domestic production levels and infant formula regulation — create significant demand volatility.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Feed Cost Pass-Through', explanation: 'Dairy farm profitability is highly sensitive to grain and roughage costs. When feed prices rise, farm margins compress, leading to supply contraction 6–12 months later. The lag between input cost moves and milk supply responses creates cyclical price swings.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 6, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -6, mid: 3, high: 11, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -9, mid: 5, high: 16, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Chinese imports accelerate', trigger: 'China reports a domestic dairy production shortfall or announces formula regulatory changes that boost imports.', action: 'Dairy ingredient buyers competing with Chinese importers for New Zealand and EU volumes should consider securing supply earlier in the production season.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If New Zealand season delivers strong volumes', trigger: 'Fonterra raises milk collection forecast above 1,550 million kgMS.', action: 'Q1 after Southern Hemisphere peak production is historically the best buying window for milk powder. Delay large commitments until early Q1 if possible.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current moderate recovery', trigger: 'EU herd stable; New Zealand season average; China importing at current pace.', action: 'Dairy markets appear in gradual recovery. Procurement aligned with GDT auction calendar and seasonal NZ supply peaks optimises cost over the year.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'millet': MaterialAnalysis(
    materialId: 'millet',
    currentPrice: 225,
    priceChange1W: -0.4,
    priceChange1M: -1.2,
    priceData1Y: _milletSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Sahel Drought Impact', detail: 'Below-average rainfall across Niger, Mali, and Burkina Faso during the critical July–August growing period reduced West African millet output, raising food security concerns.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 28, title: 'India Coarse Grain Policy Push', detail: 'India\'s government promoted millet consumption under its "International Year of Millets" initiative, boosting domestic demand and supporting export prices.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Sub-Saharan African Food Security', explanation: 'Millet is the primary staple for over 500 million people in the Sahel and sub-Saharan Africa. Population growth in these regions is providing structural demand growth even without income-driven consumption increases.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Sahel Rainfall Variability', explanation: 'Most millet is grown under rainfed conditions in semi-arid regions with highly variable annual rainfall. El Niño and the West African monsoon are the primary climate drivers of production outcomes.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Health Food & Gluten-Free Demand', explanation: 'In developed markets, millet is gaining traction as a gluten-free grain alternative and health food ingredient. While still a small share of global consumption, this premium market is growing rapidly.', direction: PriceDirection.up, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 5, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -5, mid: 2, high: 9, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -7, mid: 3, high: 13, confidence: 0.39),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Sahel rainfall fails again', trigger: 'NOAA forecasts below-average July–August rainfall across the West African Sahel for a second consecutive year.', action: 'Food aid organisations and regional grain traders should monitor monsoon forecasts closely and pre-position inventory ahead of potential harvest shortfalls.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If India releases strategic reserves', trigger: 'Indian government releases coarse grain buffer stocks to stabilise domestic prices.', action: 'Export prices may soften as Indian supply enters the market. Spot purchasing during periods of Indian export availability may offer cost advantages.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current stable conditions', trigger: 'Average Sahel rainfall and stable Indian policy.', action: 'Millet markets are less liquid than major grains. Procurement should prioritise supply security and relationship-based sourcing over price optimisation.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'molasses': MaterialAnalysis(
    materialId: 'molasses',
    currentPrice: 142,
    priceChange1W: 0.2,
    priceChange1M: 0.8,
    priceData1Y: _molassesSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Brazil Ethanol Demand Surge', detail: 'Higher ethanol blending ratios in Brazil incentivised mills to maximise sugar extraction and reduce molasses byproduct yields, tightening animal feed molasses availability.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Thai Beet Sugar Expansion', detail: 'Thailand\'s sugar production expansion generated additional molasses supply, partially relieving tightness in Asian feed and fermentation markets.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Sugar Market Linkage', explanation: 'Molasses is a byproduct of sugar refining, so its availability and price move inversely with the proportion of cane diverted to ethanol in Brazil and the intensity of extraction by mills globally. Sugar market dynamics are the primary driver.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Animal Feed Demand', explanation: 'Molasses is used as an energy source and palatability enhancer in cattle and dairy feed rations. Livestock production growth in Asia and the Middle East is providing steady demand growth.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Fermentation & Industrial Use', explanation: 'Molasses is a feedstock for ethanol, yeast, and MSG production. Fermentation industry demand provides a price floor that competes with animal feed uses for available volumes.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 4, confidence: 0.70),
      ForecastHorizon(label: '3 Months', low: -5, mid: 2, high: 7, confidence: 0.55),
      ForecastHorizon(label: '6 Months', low: -7, mid: 3, high: 10, confidence: 0.41),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Brazilian ethanol blending rises', trigger: 'Brazil mandates higher ethanol blending ratios, reducing molasses byproduct generation from sugar mills.', action: 'Livestock feed producers dependent on molasses should review supply agreements and consider alternative energy sources as contingency.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If global sugar production surges', trigger: 'Global sugar output exceeds 200 million tonnes and mill extraction rates rise.', action: 'Increased molasses availability may soften prices. Spot purchasing or shorter contract tenors may be preferable during surplus periods.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current stable conditions', trigger: 'Sugar market balanced and steady feed demand.', action: 'Molasses shows low price volatility relative to other agricultural commodities. Annual supply agreements aligned with cane crushing seasons provide the most consistent sourcing.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'natural_rubber': MaterialAnalysis(
    materialId: 'natural_rubber',
    currentPrice: 1720,
    priceChange1W: 1.4,
    priceChange1M: 4.8,
    priceData1Y: _naturalRubberSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'Thailand Flooding Damages Plantations', detail: 'Severe flooding across southern Thailand\'s rubber belt damaged mature Hevea trees and disrupted latex tapping operations, tightening regional supply.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'Synthetic Rubber Price Rally', detail: 'A spike in butadiene (SBR feedstock) prices lifted synthetic rubber costs, making natural rubber more competitive and driving substitution demand.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 36, title: 'China Auto Tyre Demand Softens', detail: 'Weaker Chinese passenger vehicle sales reduced tyre production volumes and natural rubber consumption below seasonal expectations.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Tyre Industry Demand', explanation: 'Approximately 70% of natural rubber goes into tyre manufacturing. Global vehicle production and aftermarket tyre replacement — particularly in China — is the dominant demand driver. Natural rubber is preferred over synthetic in high-performance and truck tyres due to superior heat dissipation.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Thai & Indonesian Production', explanation: 'Thailand, Indonesia, and Malaysia produce over 70% of global natural rubber. Plantation weather, tapping seasons, and government support prices in these three countries drive supply-side variability.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Oil Price & Synthetic Rubber Competition', explanation: 'Natural rubber competes with synthetic rubber (SBR, BR) derived from petroleum. When oil prices are low, synthetic rubber becomes cheaper and substitutes for natural rubber in price-sensitive applications, capping natural rubber\'s upside.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 2, high: 8, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -7, mid: 4, high: 14, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -10, mid: 7, high: 22, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Southeast Asian weather disrupts tapping', trigger: 'Prolonged flooding or drought in Thai or Indonesian rubber belts during peak tapping season (February–April).', action: 'Tyre manufacturers and rubber goods producers should maintain 30–60 day inventory buffers given natural rubber\'s limited short-term substitutability in critical applications.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese auto demand slows sharply', trigger: 'Chinese passenger vehicle sales decline more than 10% year-on-year for two consecutive quarters.', action: 'Spot purchasing may offer better value than forward contracts as demand weakness weighs on prices. Review tyre inventory levels before committing to additional rubber volumes.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current balanced conditions', trigger: 'Steady tyre demand and average Southeast Asian production.', action: 'Natural rubber is fairly valued with balanced supply and demand. Quarterly procurement aligned with seasonal Thai supply patterns (peak Q2, trough Q4) manages cost efficiently.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'nuts': MaterialAnalysis(
    materialId: 'nuts',
    currentPrice: 2420,
    priceChange1W: 0.5,
    priceChange1M: 1.8,
    priceData1Y: _nutsSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Cashew Crop Failure in West Africa', detail: 'Erratic rainfall during the West African cashew flowering period resulted in a 20% production decline across Ivory Coast and Guinea-Bissau, the leading cashew export origins.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Indian Pistachio Import Policy Change', detail: 'India reduced import duties on US pistachios, opening a major new demand channel and lifting overall nut complex sentiment.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Asian Snacking & Health Trends', explanation: 'Premium nut consumption in China, India, and Southeast Asia is growing at 8–12% annually — far above global averages — driven by rising incomes, health awareness, and gifting culture. This structural demand growth underpins a multi-year price tailwind.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Origin-Specific Weather Risk', explanation: 'Different nut varieties have highly concentrated production: California (almonds, walnuts, pistachios), Turkey (hazelnuts), West Africa (cashews), Iran (pistachios). Adverse weather in a single origin can drive large price moves for specific varieties.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Food Industry Ingredient Demand', explanation: 'Nut butters, nut milks, chocolate inclusions, and snack bars are the fastest-growing food categories globally. Industrial ingredient demand adds a less price-sensitive demand layer above retail snacking.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 2, high: 7, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -5, mid: 4, high: 13, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -7, mid: 6, high: 20, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If multiple origins face adverse weather', trigger: 'Both California drought and West African cashew failures coincide in the same crop year.', action: 'Food manufacturers with high nut content in their product lines should consider building strategic inventory or longer-dated supply agreements given the concentrated origin risk.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If record California crops coincide with demand slowdown', trigger: 'USDA estimates California almond and walnut crops both above 5-year records.', action: 'Post-harvest spot pricing (October–December) typically offers the best annual buying opportunity for California-origin nuts.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current steady demand conditions', trigger: 'Average crop years across major origins; steady Asian demand growth.', action: 'Nuts are in a structurally positive price environment. Annual supply agreements with price adjustment mechanisms provide cost certainty without foregoing all market upside.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'oats': MaterialAnalysis(
    materialId: 'oats',
    currentPrice: 385,
    priceChange1W: -0.8,
    priceChange1M: -2.6,
    priceData1Y: _oatsSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'Canadian Prairie Drought', detail: 'Drought conditions across Saskatchewan and Manitoba — which together produce over 60% of globally exported oats — significantly reduced the 2025 Canadian oat crop.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'Oat Milk Demand Growth', detail: 'Oat milk manufacturers reported record sales volumes, drawing additional milling-grade oat demand and supporting prices above traditional feed parity levels.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Canadian Production Dominance', explanation: 'Canada exports over 3 million tonnes of oats annually, accounting for the majority of global oat trade. Prairie drought years create sharp supply shocks, while good crop years rapidly rebuild global stocks.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Oat Milk & Health Food Demand', explanation: 'The oat milk category has grown from negligible to a major dairy alternative in under a decade, adding new milling-grade demand that competes with feed use and supports a premium above historic price levels.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Beta-Glucan Health Claims', explanation: 'Regulatory approval of oat beta-glucan heart health claims in the US, EU, and increasingly Asian markets is driving functional food ingredient demand for certified high-beta-glucan oat varieties.', direction: PriceDirection.up, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 6, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -6, mid: 2, high: 10, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -9, mid: 3, high: 15, confidence: 0.39),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Canadian drought extends', trigger: 'Statistics Canada crop production report estimates oat output more than 20% below 5-year average.', action: 'Oat millers and cereal manufacturers should consider extending forward cover before harvest confirms the shortfall and spot prices spike.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Canadian crop recovers to average', trigger: 'Prairie growing conditions return to normal and StatsCan projects above-average yields.', action: 'Post-harvest Canadian new crop pricing (September–October) typically provides the most competitive annual buying window.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current moderate supply', trigger: 'Below-average but not catastrophic Canadian crop; steady oat milk demand growth.', action: 'Oat markets remain supported by structural food demand growth. A mix of Canadian new crop contracts and spot purchases manages weather timing risk.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'peanuts': MaterialAnalysis(
    materialId: 'peanuts',
    currentPrice: 530,
    priceChange1W: -0.3,
    priceChange1M: -1.0,
    priceData1Y: _peanutsSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'US Southeast Drought', detail: 'Drought conditions in Georgia and Texas during the critical pod-fill stage reduced the US peanut crop estimate by 12%, tightening global peanut butter and oil supply.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Argentine Crop Expansion', detail: 'Argentina significantly expanded peanut acreage in Córdoba province, adding substantial new export supply to global markets and offsetting US shortfalls.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'US & Argentine Production', explanation: 'The US and Argentina together supply the majority of globally exported peanut products. US weather during the August–September pod-fill stage and Argentine expansion decisions are the primary annual supply variables.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Asian Peanut Oil Demand', explanation: 'China and Southeast Asia are large consumers of peanut oil for cooking. Chinese domestic production shortfalls periodically require significant imports, creating demand surges that tighten global markets.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Nut Butter & Snack Demand', explanation: 'Growing health consciousness in North America and Europe is sustaining demand for peanut butter, peanut snacks, and protein bars, providing a steady, relatively price-inelastic demand floor.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 5, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -5, mid: 2, high: 9, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -7, mid: 3, high: 13, confidence: 0.39),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If US drought expands during pod-fill', trigger: 'USDA crop progress report shows US peanut crop rated below 50% good-to-excellent in August.', action: 'Food manufacturers with peanut-intensive products should consider accelerating forward purchasing before harvest reveals the full extent of any shortfall.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Argentine exports surge', trigger: 'Argentine peanut export volumes exceed 900,000 tonnes for a second consecutive season.', action: 'Spot purchasing may remain competitive. Long-dated forward contracts risk locking in prices above the Argentine-origin market floor.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current balanced conditions', trigger: 'Average US crop and steady Argentine export volumes.', action: 'Peanuts exhibit moderate seasonality. Buying US new crop in October–November and Argentine new crop in March–April typically provides the most competitive annual pricing.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'rice': MaterialAnalysis(
    materialId: 'rice',
    currentPrice: 545,
    priceChange1W: -1.3,
    priceChange1M: -5.2,
    priceData1Y: _riceSeries,
    events: const [
      PriceEvent(weekIndex: 8, title: 'India Export Ban Extended', detail: 'India extended its non-basmati white rice export ban for a further six months citing domestic food inflation, removing the world\'s largest rice exporter from global markets and spiking prices.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 20, title: 'Thailand & Vietnam Export Surge', detail: 'Thai and Vietnamese exporters accelerated shipments to fill the India-created supply gap, but could not fully replace Indian volumes, keeping prices elevated though below the initial spike level.', impact: PriceDirection.down),
      PriceEvent(weekIndex: 34, title: 'India Lifts Export Restrictions', detail: 'India partially lifted its rice export restrictions following a domestic price easing, restoring supply to global markets and triggering a significant price correction.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Indian Export Policy', explanation: 'India supplies 40% of globally traded rice. Its export policy — driven by domestic food inflation management — is the single largest variable in global rice markets. India\'s 2023–24 export restrictions demonstrated how rapidly and severely policy changes can move prices.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Asian Monsoon Production', explanation: 'Rice is primarily grown under monsoon-fed irrigation across South and Southeast Asia. The timing, distribution, and intensity of the Asian monsoon season determines production outcomes for most of the world\'s rice supply.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'African Import Demand Growth', explanation: 'Sub-Saharan Africa has become one of the fastest-growing rice import markets as urbanisation shifts diets away from traditional staples. African import volumes add structural demand growth beyond traditional Asian markets.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: -1, high: 5, confidence: 0.69),
      ForecastHorizon(label: '3 Months', low: -8, mid: 1, high: 10, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -10, mid: 3, high: 16, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If India reimposes export restrictions', trigger: 'Indian domestic rice prices rise above government intervention thresholds again.', action: 'Rice-importing countries and food manufacturers should maintain strategic stocks above minimum levels given India\'s demonstrated willingness to restrict exports on short notice.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If India remains open to exports', trigger: 'Indian government confirms open export policy through the current crop year.', action: 'Global rice prices are likely to soften toward pre-2023 levels. Spot purchasing may significantly outperform forward contracts booked during the restriction period.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current policy normalisation', trigger: 'India maintains limited export access; Thailand and Vietnam supply steadily.', action: 'Rice markets appear to be normalising after the 2023–24 crisis. Building 60–90 day strategic reserves remains prudent given India\'s policy unpredictability.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'silk': MaterialAnalysis(
    materialId: 'silk',
    currentPrice: 37,
    priceChange1W: 0.5,
    priceChange1M: 1.6,
    priceData1Y: _silkSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Chinese Silkworm Disease', detail: 'A pebrine disease outbreak in Zhejiang and Jiangsu provinces — China\'s primary silk regions — reduced cocoon yields and quality, tightening raw silk availability.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Luxury Fashion Demand Slowdown', detail: 'A broader slowdown in Chinese luxury consumption reduced demand for premium silk fabrics from European fashion houses, softening sentiment in the raw silk market.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Chinese Production Dominance', explanation: 'China produces over 70% of global raw silk and processes the majority of silk from other origins. Chinese sericulture conditions — particularly mulberry leaf supply and silkworm disease — are the primary production variables.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Luxury Fashion & Textile Demand', explanation: 'Raw silk\'s primary end-use is in premium fashion and home textiles. Luxury consumption trends in China and Western markets, and fashion house procurement cycles, drive demand volatility.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Synthetic Fibre Competition', explanation: 'Polyester and other synthetics can replicate silk\'s appearance at a fraction of the cost. Silk\'s market is defined by applications where authenticity, breathability, and status are valued — a relatively inelastic but narrow market.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 5, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -5, mid: 2, high: 9, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -7, mid: 4, high: 14, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Chinese luxury demand rebounds', trigger: 'Chinese luxury spending returns to 2021 growth rates following any domestic stimulus programme.', action: 'Fashion fabric buyers should consider booking silk supply early in the season before a demand-driven price rally develops.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese production recovers', trigger: 'Disease pressure eases and a strong mulberry leaf harvest supports cocoon output.', action: 'Spot purchasing during peak Chinese new silk season (May–June) typically offers the most competitive annual buying window.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current stable conditions', trigger: 'Average Chinese production and steady luxury demand.', action: 'Silk markets are thin and relationship-driven. Annual supply agreements with qualified Chinese reelers provide more security than spot market purchasing alone.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'sorghum': MaterialAnalysis(
    materialId: 'sorghum',
    currentPrice: 210,
    priceChange1W: -0.5,
    priceChange1M: -1.8,
    priceData1Y: _sorghumSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'China Sorghum Buying Surge', detail: 'Chinese distilleries — major sorghum consumers for baijiu production — accelerated US sorghum purchases amid domestic supply tightness, drawing down available export stocks significantly.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'US Plains Drought Relief', detail: 'Timely rains across the Texas and Kansas sorghum belt improved crop condition ratings from poor to average, reassuring markets about the US export supply outlook.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Chinese Import Demand', explanation: 'China is by far the largest importer of US sorghum, primarily for use in baijiu spirit distilling and animal feed. Chinese buying decisions — influenced by domestic corn prices and government policy — drive the majority of US export market moves.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Drought Tolerance & Climate Resilience', explanation: 'Sorghum\'s drought tolerance makes it increasingly attractive as climate variability intensifies. Growing interest from farmers in drier regions of the US, Africa, and Australia as a corn alternative is supporting acreage expansion.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Corn Price Relationship', explanation: 'Sorghum is a partial substitute for corn in feed rations. When corn prices are high relative to sorghum\'s feed value, demand for sorghum increases. The corn-sorghum price spread is a key driver of short-term demand shifts.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 6, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -6, mid: 2, high: 10, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -9, mid: 3, high: 15, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Chinese buying accelerates', trigger: 'Chinese MOFCOM issues large corn import quotas that spill into sorghum as a feed substitute.', action: 'US feed manufacturers competing with Chinese export demand should monitor USDA weekly export sales reports for signs of accelerating Chinese sorghum purchases.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If US Plains drought eases', trigger: 'USDA crop condition reports show sorghum rated above 60% good-to-excellent by late July.', action: 'Post-harvest spot prices in October typically provide the most competitive annual buying window for US-origin sorghum.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current balanced conditions', trigger: 'Average US crop and steady Chinese import pace.', action: 'Sorghum pricing tracks corn closely. Buyers substituting between species should monitor the corn-sorghum energy equivalence ratio to optimise feed cost across both grains.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'spices': MaterialAnalysis(
    materialId: 'spices',
    currentPrice: 5400,
    priceChange1W: 1.8,
    priceChange1M: 5.1,
    priceData1Y: _spicesSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'Vietnam Black Pepper Crop Failure', detail: 'La Niña-driven excessive rainfall during the Vietnam black pepper flowering season caused widespread crop damage, removing a major origin from global supply for the year.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'Indian Cardamom Record Harvest', detail: 'Ideal monsoon conditions across Kerala produced a record Indian cardamom crop, partially offsetting black pepper tightness in the broader spice complex.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Monsoon Season Outcomes', explanation: 'Most high-value spices are grown in tropical regions (South Asia, Southeast Asia, East Africa) where monsoon timing and intensity determine annual crop outcomes. Multi-year price cycles often trace directly to monsoon variability across key origins.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Asian & Middle Eastern Demand Growth', explanation: 'Rising incomes and restaurant culture growth in China, Southeast Asia, and the Gulf states are expanding spice consumption across markets that previously had lower per-capita usage. Structural demand growth is outpacing production growth in several key varieties.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Food Industry & Health Trend Demand', explanation: 'Functional food and nutraceutical applications for turmeric, black pepper (piperine), and cardamom are adding premium demand layers above traditional food and beverage use, supporting above-commodity price tiers.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 2, high: 8, confidence: 0.65),
      ForecastHorizon(label: '3 Months', low: -7, mid: 4, high: 16, confidence: 0.49),
      ForecastHorizon(label: '6 Months', low: -10, mid: 7, high: 24, confidence: 0.35),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If monsoon fails across multiple origins', trigger: 'Vietnam and India both report poor spice crop conditions due to ENSO weather extremes.', action: 'Food manufacturers should consider pre-season procurement of critical spice varieties before harvest data confirms the shortfall and prices spike.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If bumper crops across major origins coincide', trigger: 'India, Vietnam, and Indonesia all report above-average harvests in the same season.', action: 'Post-harvest spot prices typically offer the best annual buying window. Annual supply agreements with harvest-linked pricing provide downside participation.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current tight supply', trigger: 'Vietnam constrained; other origins average; steady Asian demand.', action: 'Spice markets are highly illiquid compared to grain commodities. Relationship-based sourcing and multi-year supplier agreements provide more supply security than spot market procurement alone.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'tea': MaterialAnalysis(
    materialId: 'tea',
    currentPrice: 2.90,
    priceChange1W: 0.7,
    priceChange1M: 2.2,
    priceData1Y: _teaSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Kenyan Drought Cuts Output', detail: 'A prolonged dry spell in Kenya\'s tea-growing highlands reduced leaf availability, pushing Mombasa auction prices to a three-year high.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Sri Lanka Export Recovery', detail: 'Sri Lanka\'s tea export volumes recovered above 300 million kg after two years of economic crisis-driven disruption, adding supply to global auction markets.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'East African Production Conditions', explanation: 'Kenya is the world\'s largest black tea exporter and the Mombasa auction is a global price benchmark. Rainfall patterns in the Kenyan highlands have an immediate and large impact on global tea prices.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Pakistani & Middle Eastern Import Demand', explanation: 'Pakistan, Egypt, and Gulf states are among the world\'s largest per-capita tea consumers and import markets. Exchange rate movements and economic conditions in these countries drive significant demand variability.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Indian Domestic Consumption Growth', explanation: 'India is both the world\'s largest tea producer and consumer. Rising domestic consumption is absorbing a growing share of Indian production, reducing export availability and supporting global prices.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 6, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -6, mid: 3, high: 11, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -9, mid: 5, high: 16, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If East African drought extends', trigger: 'Kenya Tea Development Agency reports cumulative rainfall more than 30% below average through Q2.', action: 'Tea blenders and packagers should consider buying forward at Mombasa auctions before drought-driven price moves accelerate.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Indian and Sri Lankan exports recover', trigger: 'Both India and Sri Lanka report export volumes above 5-year averages simultaneously.', action: 'Global auction prices may soften. Spot purchasing through the Mombasa and Colombo auctions may outperform committed forward contracts.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current modestly tight market', trigger: 'Kenya supply constrained; Sri Lanka recovering; steady import demand.', action: 'Tea markets are in a gradually tightening structural environment as Indian domestic consumption grows. Annual auction-based procurement with modest forward cover is appropriate for most buyers.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'vegetable_juices': MaterialAnalysis(
    materialId: 'vegetable_juices',
    currentPrice: 490,
    priceChange1W: 0.2,
    priceChange1M: 0.8,
    priceData1Y: _vegetableJuicesSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'California Tomato Harvest Shortfall', detail: 'Water allocation cuts in the Sacramento Valley reduced California processing tomato acreage by 15%, tightening global tomato paste and concentrate supply.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 28, title: 'Chinese Tomato Paste Export Surge', detail: 'Xinjiang province delivered a record tomato processing season, with Chinese exporters offering paste at competitive prices that partially offset California shortfalls.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Processing Tomato Production', explanation: 'California, Italy, and China supply the majority of global tomato paste and concentrate. Water availability in California, weather in Southern Italy, and processing capacity in Xinjiang are the primary supply variables.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Food Industry Ingredient Demand', explanation: 'Tomato paste is a critical ingredient in sauces, soups, and ready meals manufactured globally. Demand is relatively stable and price-inelastic as it represents a small fraction of finished product costs.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Health & Functional Food Trends', explanation: 'Rising consumer awareness of lycopene and other tomato bioactives is supporting demand for high-brix tomato concentrates and functional vegetable juice blends in health-focused food and beverage categories.', direction: PriceDirection.up, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 4, confidence: 0.71),
      ForecastHorizon(label: '3 Months', low: -4, mid: 2, high: 7, confidence: 0.55),
      ForecastHorizon(label: '6 Months', low: -6, mid: 3, high: 10, confidence: 0.42),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If California water cuts deepen', trigger: 'California water authorities impose additional acreage restrictions on processing tomato growers.', action: 'Food manufacturers should pre-book annual requirements early in the contracting season before California shortfalls reduce available forward tonnage.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese exports remain competitive', trigger: 'Xinjiang tomato processors maintain export pricing below California and Italian origins for a second consecutive year.', action: 'Buyers with Chinese-origin qualification may benefit from competitive spot pricing. Italian origin premiums may soften in this scenario.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current balanced supply', trigger: 'California acreage stable; Chinese exports at current volumes; steady food industry demand.', action: 'Tomato products show relatively low price volatility. Annual contracting aligned with California and Italian harvest seasons provides the most stable procurement outcomes.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'vegetable_oils': MaterialAnalysis(
    materialId: 'vegetable_oils',
    currentPrice: 890,
    priceChange1W: -0.9,
    priceChange1M: -2.8,
    priceData1Y: _vegetableOilsSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'Black Sea Sunflower Disruption', detail: 'Conflict-related disruptions to Ukrainian sunflower oil exports — Ukraine supplying roughly 50% of globally traded sunflower oil — caused a sharp rally across all vegetable oil benchmarks.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'Malaysian Palm Oil Recovery', detail: 'Malaysian palm oil production recovered above 1.8 million tonnes per month following an easing of La Niña dryness, adding supply across all vegetable oil markets.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Palm Oil Supply Linkage', explanation: 'Palm oil is the world\'s most consumed vegetable oil and acts as the global price anchor. Malaysian and Indonesian production conditions, which are determined by rainfall and historical planting cycles, set the floor and ceiling for the entire vegetable oil complex.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Biofuel & Renewable Diesel Mandates', explanation: 'EU, US, and Asian biodiesel and renewable diesel mandates are consuming a growing share of vegetable oil supply. Policy-driven industrial demand is now large enough to materially tighten balances in high-blending-policy years.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Ukraine Sunflower Oil Geopolitics', explanation: 'Ukraine produces half of globally traded sunflower oil. Any escalation affecting Black Sea export infrastructure creates an immediate and severe tightening of the broader vegetable oil market as importers scramble for palm oil substitutes.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: -1, high: 5, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -8, mid: 2, high: 12, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -11, mid: 4, high: 18, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Black Sea exports are disrupted again', trigger: 'Renewed conflict escalation affects Odessa or other Ukrainian port infrastructure.', action: 'Food manufacturers should review sunflower oil supply chain exposure and assess the feasibility of palm or rapeseed substitution in their formulations.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If palm production recovers strongly', trigger: 'Malaysian and Indonesian palm oil output both exceed seasonal norms for two consecutive months.', action: 'Vegetable oil prices typically soften when palm supply is abundant. Spot purchasing or reducing forward cover ratios may be appropriate during a palm surplus.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current balanced conditions', trigger: 'Palm recovery offsets Black Sea uncertainty; steady biofuel mandates.', action: 'Vegetable oils remain elevated versus pre-2022 levels due to structural biofuel demand and Ukraine uncertainty. Procurement strategies should reflect this higher base rather than anticipating a return to prior price norms.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'vegetables': MaterialAnalysis(
    materialId: 'vegetables',
    currentPrice: 695,
    priceChange1W: 0.4,
    priceChange1M: 1.5,
    priceData1Y: _vegetablesSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'European Heat Wave', detail: 'Record summer temperatures across Southern Europe damaged outdoor vegetable crops in Spain, Italy, and Greece, tightening supply of tomatoes, peppers, and leafy greens across EU retail markets.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'China Vegetable Export Expansion', detail: 'Chinese producers expanded exports of frozen and processed vegetables to fill European supply gaps, moderating the heat-driven price spike in processed categories.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Weather & Seasonal Cycles', explanation: 'Fresh vegetable prices are highly seasonal and weather-sensitive, with outdoor growing seasons and extreme weather events creating sharp short-term price spikes. Energy costs for heated greenhouses are an increasingly important driver of off-season pricing.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Energy Cost for Protected Growing', explanation: 'Year-round vegetable supply relies increasingly on heated glasshouse production (Netherlands, UK, Spain). Energy cost spikes during European winter months translate directly into elevated winter vegetable prices.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Health & Convenience Demand', explanation: 'Consumer preference for fresh and minimally processed vegetables is structurally growing in developed markets. Ready-to-eat salads and fresh-cut vegetables command significant premiums that are relatively inelastic to commodity price moves.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 6, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -6, mid: 2, high: 10, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -9, mid: 3, high: 14, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If European summer heat intensifies', trigger: 'Copernicus climate forecasts indicate above-average temperatures across Iberian and Italian growing regions during peak outdoor growing season.', action: 'Food service and retail buyers should build vegetable inventory before peak summer heat events materialise in weekly crop reports.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If glasshouse energy costs fall', trigger: 'European gas prices drop below €30/MWh for a sustained period, reducing protected growing costs.', action: 'Winter vegetable prices may soften. Spot purchasing rather than long-term supply agreements may offer cost advantages during periods of low energy prices.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current seasonal conditions', trigger: 'Normal outdoor growing season and stable glasshouse energy costs.', action: 'Vegetables are inherently seasonal. Annual supply frameworks with growers — with clear quality and volume commitments — provide more reliable sourcing than purely spot market purchasing.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'water': MaterialAnalysis(
    materialId: 'water',
    currentPrice: 860,
    priceChange1W: 2.6,
    priceChange1M: 8.4,
    priceData1Y: _waterSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'California Dry Year Declared', detail: 'The California State Water Resources Control Board declared a second consecutive critically dry year, triggering Tier 3 curtailments on surface water rights and pushing the Nasdaq Veles California Water Index sharply higher.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 22, title: 'Atmospheric River Events', detail: 'A series of atmospheric river storm events replenished Northern California reservoirs above 100% of historical average, easing curtailment expectations and correcting prices.', impact: PriceDirection.down),
      PriceEvent(weekIndex: 36, title: 'Groundwater Sustainability Plans', detail: 'Several San Joaquin Valley Groundwater Sustainability Agencies released plans restricting groundwater pumping, increasing demand for surface water rights and supporting prices.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'California Snowpack & Reservoir Levels', explanation: 'The Nasdaq Veles California Water Index (NQH2O) tracks water right transaction prices in California\'s five largest water markets. Snowpack accumulation and spring runoff are the dominant physical supply variables, with futures prices tracking reservoir conditions closely.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Agricultural Demand & Groundwater Restrictions', explanation: 'California agriculture uses roughly 80% of all water consumed in the state. SGMA groundwater restrictions are forcing farmers onto surface water markets, creating structural demand growth for traded water rights even in average precipitation years.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Climate Change Trend', explanation: 'Multi-decade warming trends are reducing Sierra Nevada snowpack, accelerating evaporation from reservoirs, and increasing irrigation demand. Climate change is the long-term structural driver of water scarcity and price appreciation.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -8, mid: 2, high: 14, confidence: 0.58),
      ForecastHorizon(label: '3 Months', low: -15, mid: 5, high: 28, confidence: 0.42),
      ForecastHorizon(label: '6 Months', low: -20, mid: 8, high: 40, confidence: 0.28),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If drought conditions persist through winter', trigger: 'CDFA snowpack surveys in February show Sierra Nevada snowpack below 50% of historical average.', action: 'California agricultural operations dependent on surface water should consider purchasing water rights futures as a hedge against curtailment risk before the irrigation season.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If above-average precipitation continues', trigger: 'CDEC reports reservoir storage above 120% of historical average through spring.', action: 'Water futures prices typically fall sharply after wet winters. Spot purchasing rather than forward contracts may offer better value in high-precipitation years.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current moderate drought', trigger: 'Average snowpack and continued SGMA groundwater restrictions.', action: 'Water is the most structurally bullish commodity on a 10-year horizon in the US West. Agricultural businesses in California should treat water access as a strategic asset, not just an input cost.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'wool': MaterialAnalysis(
    materialId: 'wool',
    currentPrice: 13.2,
    priceChange1W: 0.6,
    priceChange1M: 2.0,
    priceData1Y: _woolSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Australian Drought Reduces Clip', detail: 'Dry conditions across New South Wales and Victoria reduced the Australian Merino wool clip below initial forecasts, tightening fine wool availability.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 24, title: 'Chinese Mill Restocking', detail: 'Chinese worsted wool mills, having destocked aggressively in 2024, returned to Australian wool auctions with significant buying interest, supporting the fine wool price recovery.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Australian Production Conditions', explanation: 'Australia produces roughly 75% of the world\'s apparel-grade Merino wool. Seasonal rainfall in New South Wales, Victoria, and South Australia determines clip volume and quality — variables that the market monitors through quarterly Australian Wool Production Forecasting Committee reports.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Chinese Luxury & Worsted Demand', explanation: 'China is the dominant processor of Australian wool for global luxury knitwear and suiting. Chinese mill activity and inventory cycles drive large demand-side moves, with mill restocking after destocking periods creating significant price spikes.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Synthetic Fibre Competition', explanation: 'Acrylic and polyester fibres compete with wool in mid-market applications. When wool prices rise significantly above synthetic alternatives, blending and substitution in lower-end wool products increase, creating a price ceiling below luxury-grade premiums.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 6, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -5, mid: 3, high: 11, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -7, mid: 5, high: 17, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Australian clip falls further', trigger: 'AWPFC revises clip estimate below 310 million kg greasy equivalent.', action: 'Wool mills and luxury apparel brands should consider forward purchasing at Australian Eastern Market Indicator levels before auction prices reflect the full clip shortfall.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese mill buying slows', trigger: 'Chinese worsted mill utilisation rates fall below 70% on weak domestic luxury demand.', action: 'Wool prices could correct toward the AU\$12/kg range. Spot auction purchasing may offer better value than committed forward contracts during Chinese demand slowdowns.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current restocking-driven recovery', trigger: 'Chinese mills continue gradual restocking and Australian clip stabilises.', action: 'Fine wool appears in a gradual recovery. Apparel brands sourcing Merino should consider annual clip-aligned purchasing from Australian brokers rather than relying on spot market availability.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'copper': MaterialAnalysis(
    materialId: 'copper',
    currentPrice: 9250,
    priceChange1W: 1.2,
    priceChange1M: -3.7,
    priceData1Y: _copperSeries,
    events: const [
      PriceEvent(
        weekIndex: 10,
        title: 'Chile Mine Strike',
        detail:
            'Workers at Escondida mine — the world\'s largest copper deposit — launched a 21-day strike, removing roughly 180,000 tonnes from the 2025 market and spiking spot prices to 18-month highs.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 20,
        title: 'China PMI Contraction',
        detail:
            'China\'s manufacturing PMI fell below 50 for the second consecutive month, signaling demand contraction from the world\'s largest copper consumer and driving a rapid price correction.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 35,
        title: 'US Grid Infrastructure Bill',
        detail:
            'The US Infrastructure Accelerator Act allocated \$280B for grid upgrades, adding structural long-term copper demand and lifting futures sharply.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Energy Transition Demand',
        explanation:
            'Each GW of solar and wind capacity requires 4–6× more copper than fossil fuel equivalents. Global clean energy buildout is adding structural demand not present in prior commodity cycles.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Chilean Supply Uncertainty',
        explanation:
            'Chile accounts for 27% of global copper mine output. New water use restrictions and aging mine infrastructure are creating persistent supply-side constraints.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'China Demand Moderation',
        explanation:
            'China\'s property sector slowdown has reduced copper intensity in construction, partially offsetting manufacturing and EV demand. Recovery remains uncertain.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd4',
        headline: 'USD Strength',
        explanation:
            'Copper is dollar-denominated. Federal Reserve policy signaling a higher-for-longer rate environment has strengthened the USD, creating headwinds for commodity prices.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.mild,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 3, high: 9, confidence: 0.74),
      ForecastHorizon(label: '3 Months', low: -7, mid: 6, high: 16, confidence: 0.57),
      ForecastHorizon(label: '6 Months', low: -12, mid: 10, high: 26, confidence: 0.40),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If supply disruption continues',
        trigger: 'Further mine strikes or new Chilean regulatory constraints materialize.',
        action:
            'Forward contracting or locking in supplier pricing may become more attractive as spot prices move higher.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If China demand weakens further',
        trigger: 'Chinese property sector contraction deepens or PMI falls below 48.',
        action:
            'Spot purchasing may offer better value than forward contracts as prices could soften toward year-end.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current conditions',
        trigger: 'No major supply or demand shock materializes.',
        action:
            'Prices are likely range-bound between \$8,800 and \$9,800. A mixed spot-and-forward procurement approach may balance cost and certainty.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'lithium': MaterialAnalysis(
    materialId: 'lithium',
    currentPrice: 12400,
    priceChange1W: 2.8,
    priceChange1M: 14.8,
    priceData1Y: _lithiumSeries,
    events: const [
      PriceEvent(
        weekIndex: 8,
        title: 'Chinese Oversupply Correction',
        detail:
            'A surge in Chinese domestic lithium carbonate production drove global prices down 27% in 8 weeks as inventory built rapidly across the supply chain.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 30,
        title: 'Indonesia Export Restrictions',
        detail:
            'Indonesia proposed restrictions on raw lithium exports, mirroring its earlier nickel strategy. Though not yet enacted, the announcement tightened spot market sentiment.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 38,
        title: 'Global EV Sales Recovery',
        detail:
            'Q3 2025 global EV sales exceeded consensus estimates by 12%, signaling the demand trough had passed and triggering a price re-rating.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'EV Demand Recovery',
        explanation:
            'After a prolonged inventory destocking cycle in 2024–early 2025, EV manufacturers are rebuilding battery supply chains ahead of expected 2026 demand growth.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Grid Storage Buildout',
        explanation:
            'Utility-scale battery storage is emerging as a secondary demand driver independent of EV cycles, adding baseline demand that didn\'t exist three years ago.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'New Brine Projects Online',
        explanation:
            'Argentine and Chilean brine lithium projects are ramping production in 2025–2026, adding supply that could cap the upside of the current price recovery.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.moderate,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -2, mid: 5, high: 12, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -5, mid: 12, high: 28, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -10, mid: 18, high: 40, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If EV demand accelerates',
        trigger: 'Q1 2026 EV sales data shows continued beats or major OEM re-stocking announcements.',
        action:
            'Longer-term offtake agreements or forward pricing may help lock in current mid-cycle prices before a potential further recovery.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If new supply overwhelms demand',
        trigger: 'Argentine/Chilean brine projects ramp faster than forecast or Chinese inventory rebuilds.',
        action:
            'Spot market purchasing may remain advantageous through mid-2026 as oversupply pressure persists.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current recovery trajectory',
        trigger: 'Demand recovers gradually while supply adds incrementally.',
        action:
            'The price recovery appears sustainable but not dramatic. Staged procurement over the next two quarters may balance risk.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'natural_gas': MaterialAnalysis(
    materialId: 'natural_gas',
    currentPrice: 3.5,
    priceChange1W: -1.4,
    priceChange1M: -7.9,
    priceData1Y: _gasSeries,
    events: const [
      PriceEvent(
        weekIndex: 12,
        title: 'European Cold Snap',
        detail:
            'An extended cold weather event across Northern Europe drove heating demand to decade highs, drawing LNG exports from the US Gulf Coast and pushing Henry Hub prices up 50% in six weeks.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 22,
        title: 'Storage Builds Above Average',
        detail:
            'US storage injections came in 18% above the 5-year seasonal average for four consecutive weeks, signaling supply surplus and reversing the winter spike.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 36,
        title: 'Australian LNG Strike Action',
        detail:
            'Workers at two major Australian LNG export terminals threatened industrial action, briefly tightening Asian spot LNG markets and lifting global gas benchmarks.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'European LNG Import Demand',
        explanation:
            'Europe\'s continued displacement of Russian pipeline gas with LNG keeps US export facilities running near capacity, supporting US domestic prices at a structurally higher floor.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'US Shale Production Growth',
        explanation:
            'Permian Basin associated gas production continues to grow, adding supply that exceeds near-term export capacity and creating periodic domestic oversupply conditions.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'Seasonal Demand Cycle',
        explanation:
            'Spring and early summer are structurally weak demand periods as heating demand declines and cooling demand has not yet peaked, typically softening prices.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.mild,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -8, mid: -2, high: 6, confidence: 0.72),
      ForecastHorizon(label: '3 Months', low: -5, mid: 4, high: 18, confidence: 0.54),
      ForecastHorizon(label: '6 Months', low: -10, mid: 8, high: 30, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If summer heat or hurricane season disrupts supply',
        trigger: 'Above-average summer temperatures or Gulf of Mexico production disruptions.',
        action:
            'Winter forward contracts may offer better value secured before the summer-to-winter seasonal price premium develops.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If mild conditions extend through summer',
        trigger: 'Moderate summer temperatures and continued strong shale output.',
        action:
            'Spot market procurement may remain favourable through Q3; locking in large volumes at current prices carries downside risk.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under seasonal norms',
        trigger: 'Average summer weather and stable LNG export demand.',
        action:
            'A soft Q2 followed by a gradual recovery into winter is the most probable path. Hedging 40–60% of winter needs now may balance cost.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'palm_oil': MaterialAnalysis(
    materialId: 'palm_oil',
    currentPrice: 960,
    priceChange1W: 0.8,
    priceChange1M: -2.0,
    priceData1Y: _palmOilSeries,
    events: const [
      PriceEvent(
        weekIndex: 14,
        title: 'El Niño Dryness in Malaysia',
        detail:
            'El Niño conditions reduced Malaysian palm yields for three consecutive quarters, tightening the global vegetable oil supply balance and driving prices to a 14-month high.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 28,
        title: 'Indonesia Biodiesel Mandate Reduced',
        detail:
            'Indonesia temporarily reduced its B35 biodiesel mandate to B30 due to feedstock costs, releasing supply into food and oleo-chemical markets and softening prices.',
        impact: PriceDirection.down,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Indonesian Biodiesel Policy',
        explanation:
            'Indonesia\'s blending mandates directly determine how much palm oil is diverted from food/export markets to domestic fuel. Policy changes create sudden demand swings.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Weather Impact on Yields',
        explanation:
            'Palm oil yields are highly sensitive to rainfall timing in Malaysia and Indonesia. La Niña conditions building for late 2025 could support yield recovery and moderate prices.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'Soy Oil Competition',
        explanation:
            'With South American soybean harvests running above average, soy oil is pricing competitively against palm in key importing markets, limiting palm\'s upside.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.mild,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: 2, high: 8, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -8, mid: 4, high: 15, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -12, mid: 6, high: 22, confidence: 0.35),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If biodiesel mandates are raised',
        trigger: 'Indonesia raises B35 mandate or introduces B40 trials ahead of schedule.',
        action:
            'Procurement teams in food and oleo-chemical sectors may consider building forward inventory before mandate-driven demand acceleration.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If La Niña boosts yields',
        trigger: 'Malaysian and Indonesian production recovers above 5-year seasonal norms in Q3.',
        action: 'Spot buying may prove cost-efficient into Q4 as supply recovery would likely weigh on prices.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current supply-demand balance',
        trigger: 'Moderate yields and stable biodiesel policy.',
        action:
            'Prices appear fairly valued in the \$920–\$1,000 range. Mixed spot and short-dated forward contracts are appropriate.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'cotton': MaterialAnalysis(
    materialId: 'cotton',
    currentPrice: 85,
    priceChange1W: 1.9,
    priceChange1M: 2.4,
    priceData1Y: _cottonSeries,
    events: const [
      PriceEvent(
        weekIndex: 10,
        title: 'Texas Drought Declaration',
        detail:
            'USDA declared drought conditions across 62% of Texas cotton-growing counties, cutting projected US output by 14% and driving the largest single-week price jump of the year.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 25,
        title: 'India Export Expansion',
        detail:
            'India removed export restrictions on cotton for the second consecutive year, releasing buffer stock and providing significant price relief to global buyers.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 40,
        title: 'Bangladesh Mill Demand',
        detail:
            'Garment orders flowing to Bangladesh from Western brands reached record levels, driving raw cotton procurement and tightening merchant inventories.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'US Production Weather Risk',
        explanation:
            'The US is the world\'s largest cotton exporter. Texas drought conditions in the current growing season are creating persistent supply uncertainty for the 2025–26 marketing year.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Asian Mill Demand Recovery',
        explanation:
            'Bangladesh, Vietnam, and Indonesia garment mills are restocking after a prolonged destocking period, adding new buying activity to a tightening spot market.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'Synthetic Fibre Competition',
        explanation:
            'With polyester prices remaining historically low, some mills continue to substitute synthetics for cotton, limiting the ceiling of the demand recovery.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.mild,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 3, high: 8, confidence: 0.70),
      ForecastHorizon(label: '3 Months', low: -6, mid: 5, high: 14, confidence: 0.53),
      ForecastHorizon(label: '6 Months', low: -10, mid: 8, high: 20, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If Texas drought worsens',
        trigger: 'USDA August crop production report shows further US output cuts.',
        action:
            'Mills with December-March coverage gaps may find current futures levels attractive ahead of a potential supply-tightening rally.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If India expands exports further',
        trigger: 'Indian government increases export permits or Australia\'s record crop ships faster than expected.',
        action:
            'Spot purchasing on dips may outperform forward contracting as additional supply enters the market.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current mixed signals',
        trigger: 'US production uncertainty offset by adequate Indian and Australian supply.',
        action:
            'The 83–88¢ range appears to be near-term equilibrium. Layering coverage over the next 3 months rather than bulk contracting is a reasonable risk posture.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'aluminum': MaterialAnalysis(
    materialId: 'aluminum',
    currentPrice: 2380,
    priceChange1W: -0.5,
    priceChange1M: -0.8,
    priceData1Y: _aluminumSeries,
    events: const [
      PriceEvent(
        weekIndex: 15,
        title: 'EU Carbon Border Adjustment',
        detail:
            'Full implementation of the EU\'s Carbon Border Adjustment Mechanism increased the effective cost of carbon-intensive aluminum imports, benefiting European smelters and lifting LME prices.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 28,
        title: 'Chinese Smelter Restarts',
        detail:
            'Following the end of Yunnan Province power rationing, Chinese smelters restarted curtailed capacity, adding roughly 800kt to annualized production and moderating prices.',
        impact: PriceDirection.down,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Energy Cost Sensitivity',
        explanation:
            'Aluminum smelting consumes roughly 14 MWh per tonne. Rising European electricity costs are structurally increasing production costs and supporting floor prices in the Western market.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd2',
        headline: 'Automotive Lightweighting Demand',
        explanation:
            'Both ICE and EV manufacturers are increasing aluminum intensity in vehicle design to improve fuel/range efficiency, adding structural demand growth beyond traditional packaging.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'Chinese Capacity Surplus',
        explanation:
            'China holds significant latent smelter capacity that can be restarted when economics allow, acting as a ceiling on global prices as Chinese supply responds to any sustained rally.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.strong,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 6, confidence: 0.73),
      ForecastHorizon(label: '3 Months', low: -7, mid: 3, high: 12, confidence: 0.56),
      ForecastHorizon(label: '6 Months', low: -10, mid: 5, high: 18, confidence: 0.40),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If energy costs rise further in Europe',
        trigger: 'European gas prices spike or new power rationing affects Middle Eastern/African smelters.',
        action:
            'Western-origin premium aluminum may command higher regional premiums; sourcing mix adjustments could be worth examining.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If China resumes full production',
        trigger: 'Chinese power rationing fully lifted and smelter restart rate exceeds 90%.',
        action:
            'LME prices could test the \$2,100–2,200 support range; spot purchasing timed to any weakness may offer cost advantages.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current balanced conditions',
        trigger: 'Stable Chinese output and moderate Western demand.',
        action:
            'Prices are likely range-bound near current levels. Maintaining existing contracted volumes without large spot additions is reasonable.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'nickel': MaterialAnalysis(
    materialId: 'nickel',
    currentPrice: 16900,
    priceChange1W: 1.5,
    priceChange1M: -1.8,
    priceData1Y: _nickelSeries,
    events: const [
      PriceEvent(
        weekIndex: 8,
        title: 'Indonesian NPI Surge',
        detail:
            'Indonesian nickel pig iron production grew 22% year-over-year, flooding the stainless steel market and driving LME nickel to an 18-month low.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 38,
        title: 'Battery-Grade Nickel Deficit',
        detail:
            'Class 1 nickel sulfate demand from the battery sector outpaced available supply for the fourth consecutive quarter, creating a divergence between battery-grade and bulk market pricing.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Two-Market Divergence',
        explanation:
            'The nickel market is splitting: Indonesian NPI oversupplies the stainless sector while high-purity battery-grade nickel remains structurally tight. Exposure depends on which grade is required.',
        direction: PriceDirection.neutral,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Battery Demand Growth',
        explanation:
            'EV battery chemistry is gradually shifting back toward higher-nickel NMC cathodes for range, adding demand for high-purity Class 1 nickel that Indonesian NPI cannot directly supply.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'Indonesian Export Policy Risk',
        explanation:
            'Indonesia could tighten ore and NPI export conditions at any time. Policy uncertainty creates both downside risk for current supply flows and potential upside on any restriction announcement.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.mild,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: 2, high: 8, confidence: 0.65),
      ForecastHorizon(label: '3 Months', low: -8, mid: 4, high: 16, confidence: 0.48),
      ForecastHorizon(label: '6 Months', low: -12, mid: 7, high: 24, confidence: 0.34),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If Indonesia restricts exports',
        trigger: 'Indonesian government announces new NPI or ore export restrictions.',
        action:
            'Prices could spike rapidly as in 2022. Battery manufacturers and stainless producers dependent on Indonesian supply may consider diversifying sourcing.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If Indonesian supply continues to grow',
        trigger: 'New Indonesian smelter capacity continues ramping without export restrictions.',
        action:
            'LME prices may drift toward \$14,000–15,000. Stainless producers currently hedged above that level may consider reviewing hedge ratios.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current split-market conditions',
        trigger: 'Indonesian output stable and battery demand grows moderately.',
        action:
            'Buyers of Class 1 nickel for batteries and bulk nickel for stainless face different price environments. Procurement strategies should reflect which market each buyer operates in.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'wheat': MaterialAnalysis(
    materialId: 'wheat',
    currentPrice: 575,
    priceChange1W: -2.1,
    priceChange1M: -5.7,
    priceData1Y: _wheatSeries,
    events: const [
      PriceEvent(
        weekIndex: 12,
        title: 'Black Sea Export Disruption',
        detail:
            'Escalation near Ukrainian port infrastructure temporarily halted grain shipments, triggering an acute supply shock and a 15% price jump in two weeks.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 20,
        title: 'Record Australian Harvest',
        detail:
            'Australia\'s 2024–25 wheat harvest came in at 34 million tonnes — a record — with ample export availability that significantly offset Black Sea supply concerns.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 34,
        title: 'India Export Restrictions Extended',
        detail:
            'India extended its wheat export ban through September 2025 to protect domestic food inflation, removing a potential supply source for global markets.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Black Sea Supply Risk',
        explanation:
            'Ukraine and Russia account for 28% of global wheat exports. Any escalation affecting port or rail infrastructure creates immediate price sensitivity in global futures markets.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Northern Hemisphere Crop Progress',
        explanation:
            'Current condition reports for the US winter wheat belt and EU winter crop indicate near-average yields. A benign growing season could further weigh on prices through July.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'MENA Strategic Reserve Demand',
        explanation:
            'Middle Eastern and North African importers are building strategic reserves following 2023–24 food security concerns, providing a demand floor even as prices moderate.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.mild,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -6, mid: -1, high: 5, confidence: 0.71),
      ForecastHorizon(label: '3 Months', low: -10, mid: 2, high: 12, confidence: 0.54),
      ForecastHorizon(label: '6 Months', low: -8, mid: 5, high: 18, confidence: 0.40),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If Black Sea conflict escalates',
        trigger: 'Further disruption to Ukrainian or Russian export infrastructure.',
        action:
            'Food manufacturers and millers may find it prudent to review forward coverage positions for Q3 and Q4, as supply shocks in this market can be sharp and fast.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If Northern Hemisphere harvest outperforms',
        trigger: 'USDA June crop reports confirm above-average US and EU yields.',
        action:
            'Spot market purchases in July–August may offer cost advantages as harvest pressure weighs on prices seasonally.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current geopolitical conditions',
        trigger: 'Continued conflict uncertainty but no sharp escalation; average Northern Hemisphere harvest.',
        action:
            'Prices appear range-bound between 540 and 620¢/bu. Laddering procurement over the next two quarters rather than concentrating exposure is appropriate.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'cobalt': MaterialAnalysis(
    materialId: 'cobalt',
    currentPrice: 29500,
    priceChange1W: 0.3,
    priceChange1M: -4.8,
    priceData1Y: _cobaltSeries,
    events: const [
      PriceEvent(
        weekIndex: 10,
        title: 'DRC Mining Suspension',
        detail:
            'The DRC government temporarily suspended operations at two major artisanal mining zones pending safety reviews, tightening the spot cobalt market for six weeks.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 38,
        title: 'LFP Battery Share Grows',
        detail:
            'LFP (lithium iron phosphate) chemistry gained further market share in entry-level EVs, reducing per-vehicle cobalt intensity and weighing on long-term demand forecasts.',
        impact: PriceDirection.down,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'DRC Concentration Risk',
        explanation:
            'The DRC supplies approximately 70% of global cobalt. Political instability, artisanal mining regulations, and infrastructure challenges create persistent supply-side unpredictability.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'LFP Battery Substitution',
        explanation:
            'LFP chemistry, which contains no cobalt, is taking share from NMC in cost-sensitive EV segments. This structural demand threat is a key reason cobalt prices have not recovered to 2022 highs.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd3',
        headline: 'Aerospace Superalloy Demand',
        explanation:
            'Cobalt-based superalloys for jet engines remain in tight supply as civil aviation recovers to record passenger volumes, providing a demand floor independent of batteries.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -6, mid: 1, high: 7, confidence: 0.60),
      ForecastHorizon(label: '3 Months', low: -10, mid: 3, high: 16, confidence: 0.45),
      ForecastHorizon(label: '6 Months', low: -15, mid: 6, high: 25, confidence: 0.32),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If DRC supply is disrupted',
        trigger: 'Political events or regulatory action curtails DRC cobalt output significantly.',
        action:
            'Given cobalt\'s supply concentration, rapid price spikes are possible. Users of cobalt-intensive NMC batteries may consider strategic inventory or long-dated supply agreements.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If LFP adoption accelerates further',
        trigger: 'Major OEMs announce additional model line shifts from NMC to LFP chemistry.',
        action:
            'Cobalt demand from the battery sector could decline faster than supply adjusts. Spot purchasing may provide better value than forward contracting.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current mixed demand signals',
        trigger: 'Gradual LFP shift offset by aerospace and high-performance battery demand.',
        action:
            'Cobalt is in a period of structural uncertainty. Procurement strategies should prioritize supply security over price optimization given the DRC concentration risk.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'crude_oil': MaterialAnalysis(
    materialId: 'crude_oil',
    currentPrice: 79,
    priceChange1W: -1.3,
    priceChange1M: -10.2,
    priceData1Y: _oilSeries,
    events: const [
      PriceEvent(
        weekIndex: 8,
        title: 'OPEC+ Production Cut Extension',
        detail:
            'OPEC+ agreed to extend voluntary production cuts of 2.2 million barrels per day through Q3 2025, providing a price floor and driving a 10% rally in two weeks.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 20,
        title: 'US Strategic Reserve Release',
        detail:
            'The US Department of Energy announced a 30-million-barrel SPR release to address domestic fuel cost concerns, capping the OPEC-driven rally.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 35,
        title: 'Middle East Tension Spike',
        detail:
            'Escalating tensions near key Strait of Hormuz shipping lanes raised a risk premium on Brent crude, though actual flow disruptions remained limited.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'OPEC+ Supply Discipline',
        explanation:
            'OPEC+ compliance with voluntary cuts has been high in 2025. Any decision to unwind cuts — driven by Saudi fiscal needs or member defections — would be the primary downside risk.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Global Demand Slowdown Risk',
        explanation:
            'Slowing economic growth in China, the Eurozone, and emerging markets is constraining demand growth below earlier IEA forecasts, capping the upside for prices.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'US Shale Resilience',
        explanation:
            'US shale production has proven highly resilient at \$60–70/bbl breakevens, acting as a supply buffer that limits how high sustained rallies can reach before new output fills the gap.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.moderate,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -8, mid: -1, high: 6, confidence: 0.69),
      ForecastHorizon(label: '3 Months', low: -12, mid: 2, high: 14, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -15, mid: 4, high: 20, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If OPEC+ maintains cuts and geopolitical risk rises',
        trigger: 'OPEC+ extends cuts into 2027 or meaningful Middle East supply disruption materialises.',
        action:
            'Businesses with high energy cost exposure may consider reviewing fuel hedging ratios for H2 2026 before a potential rally develops.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If OPEC+ unwinds cuts or demand disappoints',
        trigger: 'OPEC+ members defect from cut agreements or Chinese demand data weakens materially.',
        action:
            'Prices could test the \$65–70 range. Fuel-intensive businesses may find spot exposure preferable to forward contracts at current levels.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current managed supply',
        trigger: 'Cuts maintained, moderate demand growth, no supply shock.',
        action:
            'Oil appears likely to trade in a \$72–88 range over the next two quarters. A balanced hedging approach — neither fully spot nor fully forward — manages both sides of the risk.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'steel': MaterialAnalysis(
    materialId: 'steel',
    currentPrice: 690,
    priceChange1W: 0.1,
    priceChange1M: -1.4,
    priceData1Y: _steelSeries,
    events: const [
      PriceEvent(
        weekIndex: 12,
        title: 'China Property Stimulus',
        detail:
            'Beijing announced a CNY 300B housing market support package, driving a short-lived steel demand surge and futures rally as market participants anticipated construction activity.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 35,
        title: 'Chinese Export Surge',
        detail:
            'China\'s steel mills, facing weak domestic demand, increased exports to record levels, flooding Asian regional markets and pulling global benchmark prices lower.',
        impact: PriceDirection.down,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'China Real Estate Recovery Pace',
        explanation:
            'China\'s construction sector consumes roughly 35% of global steel. The pace of the property sector recovery is the single largest variable in the global steel demand outlook.',
        direction: PriceDirection.neutral,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Trade Policy Fragmentation',
        explanation:
            'Escalating tariffs and trade barriers from the US, EU, and India are fragmenting the global steel market, creating regional price divergences and redirecting Chinese export flows.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'Green Steel Transition Costs',
        explanation:
            'European steelmakers investing in hydrogen-based DRI production face higher near-term costs that are being passed through to buyers, widening price spreads between conventional and green steel.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.mild,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: 1, high: 6, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -8, mid: 2, high: 12, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -12, mid: 4, high: 18, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If Chinese stimulus drives real construction activity',
        trigger: 'Chinese housing starts and steel intensity metrics show a sustained uptick beyond Q2 2026.',
        action:
            'Steel buyers with Q3–Q4 project needs may find current prices attractive ahead of a potential demand-driven rally.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If China exports continue rising',
        trigger: 'Chinese monthly steel exports exceed 12 million tonnes for a second consecutive quarter.',
        action:
            'Regional Asian buyers may benefit from continued spot market availability at competitive prices; early contracting at current levels would likely underperform.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under ongoing structural surplus',
        trigger: 'China stimulus provides partial demand support without fully clearing domestic excess capacity.',
        action:
            'Steel prices are likely to remain under moderate pressure with periodic rallies on stimulus news. Procurement in regular tranches rather than large pre-committed volumes limits timing risk.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'coffee': MaterialAnalysis(
    materialId: 'coffee',
    currentPrice: 295,
    priceChange1W: -1.9,
    priceChange1M: -4.8,
    priceData1Y: _coffeeSeries,
    events: const [
      PriceEvent(
        weekIndex: 8,
        title: 'Brazil Drought Concerns',
        detail:
            'Analysts raised concerns over moisture deficits in Minas Gerais during the critical flowering stage, driving the first significant rally of the year.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 18,
        title: 'Colombian Harvest Above Forecast',
        detail:
            'Colombia\'s coffee federation reported a 9% year-over-year increase in exports, partially offsetting Brazilian supply concerns.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 30,
        title: 'Vietnam Robusta Deficit',
        detail:
            'Vietnam reported its smallest robusta harvest in six years due to delayed rains, pushing robusta prices to multi-decade highs and lifting arabica by association.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Brazil Production Uncertainty',
        explanation:
            'Brazil produces roughly 35% of global arabica supply. The 2025/26 crop is in an off-year of the biennial cycle and weather stress during flowering has created significant forecast uncertainty.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Vietnam Robusta Deficit',
        explanation:
            'Vietnam\'s smallest robusta harvest in six years has pushed robusta to record prices, causing roasters to shift toward arabica as a partial substitute and supporting arabica prices.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd3',
        headline: 'Consumer Demand Resilience',
        explanation:
            'Despite high prices, retail coffee demand has shown limited elasticity. Consumers have traded down within coffee — from specialty to commercial — but not out of coffee entirely.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -8, mid: -2, high: 5, confidence: 0.64),
      ForecastHorizon(label: '3 Months', low: -12, mid: -3, high: 10, confidence: 0.48),
      ForecastHorizon(label: '6 Months', low: -15, mid: 2, high: 18, confidence: 0.33),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If Brazil crop stress intensifies',
        trigger: 'USDA or CONAB May crop estimate cuts Brazil output forecast by more than 3 million bags.',
        action:
            'Roasters and coffee buyers with H2 2026 needs may find value in locking in a portion of requirements before a potential additional supply shock rally.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If both Brazil and Vietnam recover',
        trigger: 'Late rains improve Vietnam yields and Brazil flowering-to-cherry conversion comes in above estimates.',
        action:
            'Prices may retrace toward the 240–260¢ range. Buyers with forward positions above current spot levels may wish to review timing.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current supply stress',
        trigger: 'Brazil supply comes in near the low end of estimates and Vietnam slowly recovers.',
        action:
            'Coffee is likely to remain elevated for at least two more quarters. Procurement strategies should account for a structurally higher cost environment rather than waiting for a return to prior price levels.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'gold': MaterialAnalysis(
    materialId: 'gold',
    currentPrice: 2640,
    priceChange1W: 1.8,
    priceChange1M: 5.6,
    priceData1Y: _goldSeries,
    events: const [
      PriceEvent(
        weekIndex: 10,
        title: 'Federal Reserve Pivot Signal',
        detail:
            'Fed Chair signalled a faster-than-expected rate-cut path, weakening the USD and driving gold to an all-time high above \$2,380/oz as real yields fell sharply.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 22,
        title: 'Dollar Rebound on Strong Jobs Data',
        detail:
            'A blowout US non-farm payrolls print reinforced higher-for-longer rate expectations, strengthening the USD and pulling gold back toward the \$2,200 level.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 36,
        title: 'Central Bank Buying Surge',
        detail:
            'The World Gold Council reported record central bank gold purchases in Q3 2025, led by China, India, and Poland, providing a structural demand floor that drove a fresh leg higher.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Central Bank Accumulation',
        explanation:
            'Emerging-market central banks are diversifying reserves away from USD assets, purchasing gold at the fastest pace since the 1960s. This structural demand is price-inelastic and not driven by the usual investment cycle.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Real Yield & USD Trajectory',
        explanation:
            'Gold is inversely correlated with real yields. Any Fed pivot toward rate cuts — or inflation re-acceleration — reduces the opportunity cost of holding gold and supports higher prices.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd3',
        headline: 'Geopolitical Risk Premium',
        explanation:
            'Ongoing conflicts in Ukraine and the Middle East, combined with US–China tensions, sustain safe-haven demand that was structurally absent in the low-volatility 2010s.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd4',
        headline: 'Investor ETF Outflows',
        explanation:
            'Western retail and institutional gold ETF holdings remain below 2020 peaks. A rotation back into ETFs would amplify any price move; continued outflows cap the upside.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.mild,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 2, high: 7, confidence: 0.72),
      ForecastHorizon(label: '3 Months', low: -5, mid: 5, high: 14, confidence: 0.56),
      ForecastHorizon(label: '6 Months', low: -8, mid: 9, high: 22, confidence: 0.42),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If Fed cuts rates or inflation re-accelerates',
        trigger: 'Fed signals 3+ cuts in 2026 or US CPI re-accelerates above 3.5%.',
        action:
            'Gold could test \$2,800–3,000. Businesses using gold as a financial hedge or raw material (electronics, jewellery) may find current levels attractive for longer-dated forward purchasing.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If USD strengthens on resilient growth',
        trigger: 'US economic outperformance delays Fed easing beyond Q3 2026.',
        action:
            'A retracement toward \$2,400 is possible. Jewellery and electronics buyers may find value in delaying non-urgent purchases if USD strength persists.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current conditions',
        trigger: 'Gradual Fed easing, sustained central bank buying, and stable geopolitical risk.',
        action:
            'Gold appears biased higher structurally. For industrial buyers, a mix of spot and short-dated forwards manages both cost and supply security in the current environment.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'silver': MaterialAnalysis(
    materialId: 'silver',
    currentPrice: 31.0,
    priceChange1W: 2.3,
    priceChange1M: 6.9,
    priceData1Y: _silverSeries,
    events: const [
      PriceEvent(
        weekIndex: 12,
        title: 'Solar Panel Demand Surge',
        detail:
            'Global solar installations in H1 2025 exceeded full-year 2023 totals, driving a sharp re-rating of silver industrial demand forecasts and lifting prices 25% in ten weeks.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 24,
        title: 'Gold Correction Drags Silver',
        detail:
            'A USD rally triggered a gold correction that pulled silver lower in sympathy, even as industrial demand fundamentals remained firm.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 38,
        title: 'Mexican Mine Output Miss',
        detail:
            'Mexico, the world\'s largest silver producer, reported a 7% year-on-year production decline due to flooding and community conflicts at key mines, tightening the supply balance.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Solar PV Industrial Demand',
        explanation:
            'Silver is a critical conductor in photovoltaic cell manufacturing. Each GW of solar capacity consumes roughly 50–80 tonnes of silver. Accelerating solar deployment is adding structural industrial demand that didn\'t exist at scale a decade ago.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Gold/Silver Ratio',
        explanation:
            'The gold-to-silver ratio remains historically elevated at ~85x. In prior bull markets, silver has outperformed gold on the upside, suggesting catch-up potential if precious metals remain bid.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'Mine Supply Constraints',
        explanation:
            'Primary silver mines account for only ~28% of supply; the rest is a byproduct of copper, lead, and zinc mining. Slower base metal output growth limits the supply response to higher silver prices.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: 3, high: 10, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -8, mid: 7, high: 20, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -12, mid: 12, high: 32, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If solar installations accelerate further',
        trigger: 'IEA raises solar installation forecasts or major national grid programmes announced.',
        action:
            'Electronics and solar manufacturers may consider forward purchasing or offtake agreements to lock in current prices ahead of potential supply tightening.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If gold corrects and industrial demand slows',
        trigger: 'Gold drops below \$2,400 or global manufacturing PMIs contract.',
        action:
            'Silver could retrace toward \$26–28. Spot purchasing may offer better value for industrial buyers who can tolerate timing risk.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current dual-demand conditions',
        trigger: 'Solar demand grows steadily and precious metals remain supported.',
        action:
            'Silver\'s dual role as an industrial and precious metal makes it unusually sensitive to both macro and sector-specific events. A layered procurement approach — part spot, part short-dated forward — is appropriate.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'zinc': MaterialAnalysis(
    materialId: 'zinc',
    currentPrice: 2550,
    priceChange1W: -0.8,
    priceChange1M: -3.1,
    priceData1Y: _zincSeries,
    events: const [
      PriceEvent(
        weekIndex: 14,
        title: 'European Smelter Curtailments',
        detail:
            'High electricity costs forced two major European zinc smelters to curtail output by 40%, removing approximately 200,000 tonnes of annual refined capacity from the market.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 26,
        title: 'China Property Sector Weakness',
        detail:
            'Continued weakness in Chinese construction activity reduced galvanised steel demand, the largest end-use for zinc, causing a demand-driven price pullback.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 40,
        title: 'Teck Resources Mine Expansion',
        detail:
            'Teck Resources announced ahead-of-schedule expansion at Red Dog mine in Alaska, adding supply visibility that capped further price recovery.',
        impact: PriceDirection.down,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Energy Cost–Driven Smelter Closures',
        explanation:
            'Zinc smelting is highly electricity-intensive. Persistently high European power prices have made several smelters uneconomic, creating a structural reduction in refined zinc supply that mine output alone cannot replace quickly.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Chinese Construction Recovery',
        explanation:
            'China\'s galvanised steel sector drives roughly 50% of global zinc demand. Any sustained recovery in Chinese construction activity would tighten the global supply balance significantly.',
        direction: PriceDirection.neutral,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd3',
        headline: 'Infrastructure Spending Globally',
        explanation:
            'US, EU, and Indian infrastructure programmes are raising galvanised steel demand outside China, providing a partial offset to Chinese demand softness.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 6, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -7, mid: 3, high: 12, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -10, mid: 6, high: 20, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If more European smelters close',
        trigger: 'Additional European smelter curtailments or permanent closures are announced.',
        action:
            'Galvanised steel and zinc die-casting buyers may consider extending forward coverage, as a supply shock could move prices rapidly without warning.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If Chinese demand remains weak',
        trigger: 'Chinese construction PMI stays below 50 through Q3 2026.',
        action:
            'Zinc prices may remain range-bound or drift lower. Spot purchasing is likely more economical than multi-quarter forward contracts in this scenario.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current balanced conditions',
        trigger: 'European smelter closures offset gradual Chinese demand recovery.',
        action:
            'Zinc is reasonably balanced at current levels. Procurement in regular monthly tranches manages timing risk without over-committing in either direction.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'coal': MaterialAnalysis(
    materialId: 'coal',
    currentPrice: 118,
    priceChange1W: -1.2,
    priceChange1M: -6.3,
    priceData1Y: _coalSeries,
    events: const [
      PriceEvent(
        weekIndex: 8,
        title: 'Indonesian Export Quota Cut',
        detail:
            'Indonesia reduced its domestic market obligation (DMO) exemption window, tightening seaborne supply availability and pushing Newcastle benchmark prices to a six-month high.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 20,
        title: 'China Reopens Australian Imports',
        detail:
            'China formally lifted its informal ban on Australian coal, adding significant seaborne supply back into Asian markets and reversing the earlier rally.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 36,
        title: 'India Power Demand Spike',
        detail:
            'An extreme heat wave across northern India drove electricity consumption to all-time highs, forcing Indian utilities to increase spot coal imports and supporting prices.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Asian Power Utility Demand',
        explanation:
            'India, Southeast Asia, and Japan continue to rely on thermal coal for baseload power. Growing electricity demand in these markets provides a structural floor despite Western coal phase-outs.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Energy Transition Headwinds',
        explanation:
            'Accelerating renewable deployment is gradually displacing coal from the power mix in key markets. Structural demand decline in Europe and increasing pressure in Asia are long-term price headwinds.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd3',
        headline: 'Chinese Import Policy',
        explanation:
            'China is the largest swing buyer in seaborne coal markets. Changes in import quotas, tariffs, or the pace of domestic production drive large short-term price moves.',
        direction: PriceDirection.neutral,
        magnitude: DriverMagnitude.moderate,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -7, mid: -2, high: 4, confidence: 0.70),
      ForecastHorizon(label: '3 Months', low: -10, mid: -1, high: 10, confidence: 0.53),
      ForecastHorizon(label: '6 Months', low: -15, mid: 2, high: 15, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If Asian heat waves or supply disruptions recur',
        trigger: 'Above-average summer temperatures in India/China or Indonesian export restrictions tighten.',
        action:
            'Power utilities and industrial coal consumers may consider extending forward coverage for Q3 2026 before seasonal demand lifts spot prices.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If renewables displace coal faster than expected',
        trigger: 'Renewables capacity additions in India and Southeast Asia exceed IEA forecasts.',
        action:
            'Spot purchasing is likely to remain competitive as structural demand pressure weighs on prices. Long-dated forward commitments carry downside risk.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current demand-transition balance',
        trigger: 'Asian demand grows gradually while Western demand declines; no major supply shock.',
        action:
            'Thermal coal is in managed structural decline in most scenarios. Procurement strategies should prioritise supply security and flexibility over price optimisation.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'uranium': MaterialAnalysis(
    materialId: 'uranium',
    currentPrice: 108,
    priceChange1W: 0.9,
    priceChange1M: 3.8,
    priceData1Y: _uraniumSeries,
    events: const [
      PriceEvent(
        weekIndex: 10,
        title: 'Kazatomprom Production Guidance Cut',
        detail:
            'Kazatomprom, the world\'s largest uranium producer, cut its 2025 production guidance by 17% citing sulfuric acid shortages and well-field development delays, shocking the market.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 22,
        title: 'US Nuclear Policy Support',
        detail:
            'The US passed legislation supporting new reactor construction and extending the operating licences of existing plants, strengthening long-term utility demand forecasts.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 34,
        title: 'New Canadian Production Online',
        detail:
            'Cameco\'s McArthur River expansion reached nameplate capacity ahead of schedule, adding supply that partially offset Kazakh shortfalls.',
        impact: PriceDirection.down,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Structural Supply Deficit',
        explanation:
            'A decade of low prices from 2011–2020 led to mine closures and underinvestment. The industry is unable to quickly respond to rising demand, creating a multi-year supply gap that utilities must contract around.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Nuclear Renaissance Demand',
        explanation:
            'Japan is restarting reactors, the US and UK are extending licences and building new capacity, and China has the largest reactor construction pipeline in history. Utility contracting demand is rising faster than spot market supply.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd3',
        headline: 'Kazatomprom Supply Risk',
        explanation:
            'Kazakhstan produces ~45% of global uranium. Production constraints — linked to acid supply, water management, and infrastructure — have made the market far more sensitive to Kazakh output than prior years.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd4',
        headline: 'Secondary Supply & Enrichment Tail',
        explanation:
            'Excess civilian inventory and government stockpile sales could re-enter the market, acting as a ceiling on prices. Russia\'s enrichment dominance also creates geopolitical supply risk.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.mild,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 2, high: 8, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -6, mid: 6, high: 16, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -8, mid: 10, high: 26, confidence: 0.40),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If Kazakhstan output misses further',
        trigger: 'Kazatomprom issues additional production guidance cuts or export restrictions emerge.',
        action:
            'Utilities and nuclear fuel buyers should consider accelerating long-term contracting. The spot market is thin — large purchases can move prices sharply.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If secondary supply or enrichment substitution increases',
        trigger: 'Russian or government stockpile sales increase, or downblending of HEU adds supply.',
        action:
            'Spot prices could soften. Utilities with near-term needs may benefit from a higher spot allocation before locking in multi-year contracts.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current tight market conditions',
        trigger: 'Supply deficit persists as new mine development lags utility contracting demand.',
        action:
            'Uranium is structurally bullish over a 3–5 year horizon. Long-dated contracts at current prices may prove advantageous as the market tightens further into the decade.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'corn': MaterialAnalysis(
    materialId: 'corn',
    currentPrice: 460,
    priceChange1W: -1.5,
    priceChange1M: -3.3,
    priceData1Y: _cornSeries,
    events: const [
      PriceEvent(
        weekIndex: 10,
        title: 'USDA Acreage Report Below Expectations',
        detail:
            'USDA\'s March planting intentions survey showed US corn acreage 4% below analyst estimates as farmers favoured soybean rotations, driving a brief price spike.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 22,
        title: 'Ideal US Corn Belt Weather',
        detail:
            'June USDA crop condition reports showed 68% of the US crop rated good-to-excellent — above the five-year average — triggering a significant harvest-pressure selloff.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 36,
        title: 'Brazil Second Crop (Safrinha) Shortfall',
        detail:
            'A delayed start to the Brazilian rainy season reduced the safrinha corn yield by an estimated 8%, removing a key Southern Hemisphere export origin from global balance sheets.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'US Crop Condition & Weather',
        explanation:
            'The US produces ~32% of global corn and its growing season weather from June–August is the single most watched variable in the corn market. Crop ratings drive large weekly price moves.',
        direction: PriceDirection.neutral,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Ethanol Demand',
        explanation:
            'US ethanol production consumes roughly 38% of the domestic corn crop. Ethanol blending mandates and gasoline prices directly influence feed corn demand and price.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd3',
        headline: 'Brazilian Production Competition',
        explanation:
            'Brazil has become the world\'s second-largest corn exporter, with a safrinha (second crop) that significantly expanded global supply and structurally capped prices that would otherwise have risen further.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.moderate,
      ),
      Driver(
        id: 'd4',
        headline: 'Feed Demand Resilience',
        explanation:
            'Global livestock and aquaculture industries provide a price-inelastic demand base for corn as a feed ingredient, limiting how far prices can fall during periods of surplus.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.mild,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: 1, high: 7, confidence: 0.70),
      ForecastHorizon(label: '3 Months', low: -8, mid: 2, high: 14, confidence: 0.54),
      ForecastHorizon(label: '6 Months', low: -6, mid: 4, high: 18, confidence: 0.42),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If US or Brazilian crop stress develops',
        trigger: 'USDA good-to-excellent ratings fall below 55% or safrinha planting is significantly delayed.',
        action:
            'Feed compounders and corn-dependent food manufacturers may find it prudent to extend forward coverage before weather-driven prices rally sharply.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If a record US crop materialises',
        trigger: 'USDA October yield estimate exceeds 181 bu/acre.',
        action:
            'Post-harvest spot prices often provide the best buying opportunity of the year. Delaying non-urgent procurement to October–November may offer cost advantages.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current balanced supply',
        trigger: 'Average US crop and stable Brazilian export flows.',
        action:
            'Corn appears fairly valued at current levels. Staging purchases across Q2 and Q3 — rather than concentrating procurement — manages the weather uncertainty inherent in this market.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'soybeans': MaterialAnalysis(
    materialId: 'soybeans',
    currentPrice: 1160,
    priceChange1W: -0.7,
    priceChange1M: -4.1,
    priceData1Y: _soybeanSeries,
    events: const [
      PriceEvent(
        weekIndex: 12,
        title: 'La Niña Threat to Argentine Crop',
        detail:
            'Forecasters raised the probability of La Niña conditions during the Southern Hemisphere growing season, historically associated with Argentine drought, lifting soybean prices 12% in three weeks.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 24,
        title: 'Brazil Record Harvest Confirmed',
        detail:
            'Conab confirmed a record 162 million tonne Brazilian soybean harvest, well above initial estimates, flooding the export market and erasing the La Niña-driven premium.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 38,
        title: 'Chinese Crush Margin Improvement',
        detail:
            'Recovering Chinese hog producer margins led to increased soy meal demand, prompting Chinese crushers to accelerate import bookings and supporting a price recovery.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Chinese Import Demand',
        explanation:
            'China imports ~60% of globally traded soybeans for its hog industry. Any change in Chinese pork demand, herd size, or trade policy has an outsized impact on global soybean prices.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'South American Production',
        explanation:
            'Brazil and Argentina together produce over 55% of global soybeans. La Niña weather events are the primary weather risk, with Argentine yields most sensitive to the phenomenon.',
        direction: PriceDirection.neutral,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd3',
        headline: 'Biodiesel & Renewable Diesel Mandates',
        explanation:
            'US and European renewable diesel growth is consuming increasing volumes of soybean oil, creating a structural demand pull that partly decouples soy oil from agricultural fundamentals.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: 1, high: 7, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -8, mid: 3, high: 14, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -10, mid: 5, high: 20, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If La Niña damages the Argentine crop',
        trigger: 'Argentine crop forecasts cut by more than 5 million tonnes from current estimates.',
        action:
            'Soy meal and soy oil buyers may find value in accelerating Q3 forward purchases, as Argentine supply shocks move prices quickly and recovery is slow.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If Brazilian exports remain strong and China demand softens',
        trigger: 'Brazilian export pace exceeds 14 million tonnes/month or Chinese ASF risk resurfaces.',
        action:
            'Spot purchasing may remain advantageous through mid-2026. Forward contracting at current prices risks overpaying into a surplus.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current balanced fundamentals',
        trigger: 'Average South American weather and steady Chinese import pace.',
        action:
            'Soybeans appear range-bound between 1,050 and 1,250¢/bu. Procurement in regular monthly tranches limits exposure to weather event timing risk.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'sugar': MaterialAnalysis(
    materialId: 'sugar',
    currentPrice: 21.0,
    priceChange1W: -2.1,
    priceChange1M: -8.5,
    priceData1Y: _sugarSeries,
    events: const [
      PriceEvent(
        weekIndex: 8,
        title: 'Brazil Ethanol Price Rally',
        detail:
            'A spike in Brazilian ethanol prices incentivised mills to divert more cane to fuel production and less to sugar, tightening global sugar supply and triggering a 15% price rally.',
        impact: PriceDirection.up,
      ),
      PriceEvent(
        weekIndex: 18,
        title: 'India Lifts Export Restrictions',
        detail:
            'India, the world\'s largest sugar producer, allowed exports after a 14-month ban as domestic cane production exceeded government estimates, adding significant supply to the market.',
        impact: PriceDirection.down,
      ),
      PriceEvent(
        weekIndex: 32,
        title: 'Thai Crop Drought Impact',
        detail:
            'El Niño-driven dryness in Thailand cut cane yields by an estimated 12%, tightening the global export balance and providing a partial recovery from the Indian-export-driven lows.',
        impact: PriceDirection.up,
      ),
    ],
    drivers: const [
      Driver(
        id: 'd1',
        headline: 'Brazilian Ethanol-Sugar Flex',
        explanation:
            'Brazilian mills can switch between sugar and ethanol production within a single season. When ethanol prices are high relative to sugar, mills flex toward fuel, reducing sugar availability. This mechanism makes Brazilian energy policy a key variable in global sugar markets.',
        direction: PriceDirection.neutral,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd2',
        headline: 'Indian Export Policy',
        explanation:
            'India holds large domestic sugar reserves and its export decisions — driven by domestic price management and foreign exchange goals — can rapidly shift the global supply balance.',
        direction: PriceDirection.down,
        magnitude: DriverMagnitude.strong,
      ),
      Driver(
        id: 'd3',
        headline: 'El Niño / La Niña Weather',
        explanation:
            'Major sugar-producing regions (Thailand, India, Australia) are highly sensitive to ENSO weather cycles. El Niño typically reduces Asian and Australian cane yields, tightening global supply.',
        direction: PriceDirection.up,
        magnitude: DriverMagnitude.moderate,
      ),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -6, mid: -1, high: 5, confidence: 0.69),
      ForecastHorizon(label: '3 Months', low: -8, mid: 2, high: 12, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -10, mid: 4, high: 18, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(
        scenario: RecommendationScenario.upside,
        scenarioLabel: 'If Brazilian mills flex to ethanol',
        trigger: 'Brazilian ethanol hydrous prices rise above BRL 3.50/litre, incentivising further mill diversion.',
        action:
            'Food manufacturers and confectioners with large sugar requirements may find forward purchasing at current levels attractive as a hedge against mill-diversion supply tightening.',
      ),
      Recommendation(
        scenario: RecommendationScenario.downside,
        scenarioLabel: 'If India resumes unrestricted exports',
        trigger: 'Indian government announces full removal of sugar export restrictions for the 2025/26 season.',
        action:
            'Global prices could test the 18–19¢ range. Spot purchasing may offer better value than forward contracts for buyers who can be flexible on procurement timing.',
      ),
      Recommendation(
        scenario: RecommendationScenario.base,
        scenarioLabel: 'Under current mixed supply signals',
        trigger: 'Brazilian flex remains balanced and Indian export policy stays cautious.',
        action:
            'Sugar is likely to trade in a 19–24¢ range in the near term. Laddering purchases over multiple months rather than making large single commitments manages the policy and weather timing risk.',
      ),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  // ── Chemicals ────────────────────────────────────────────────────────────
  'commodity_chemicals': MaterialAnalysis(
    materialId: 'commodity_chemicals',
    currentPrice: 850,
    priceChange1W: 0.8,
    priceChange1M: 2.1,
    priceData1Y: _commodityChemicalsSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Energy Cost Spike', detail: 'A surge in European natural gas prices raised feedstock costs for petrochemical producers, squeezing margins and pushing commodity chemical prices higher across the board.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 36, title: 'Downstream Restocking', detail: 'Polymer and adhesive manufacturers began rebuilding inventories after an extended destocking period, providing a demand floor that lifted benchmark prices.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Natural Gas Feedstock Cost', explanation: 'Natural gas accounts for 30–40% of production costs for many commodity chemicals including ammonia, methanol, and ethylene. European gas prices remain elevated versus historical norms, underpinning prices.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Chinese Overcapacity', explanation: 'China has aggressively expanded petrochemical capacity. Rising export volumes from Chinese producers are creating downward pressure on global benchmark prices for key intermediates.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Downstream Inventory Cycle', explanation: 'Manufacturers are cautiously rebuilding inventory after destocking in 2024, providing a modest demand floor. The restocking cycle is gradual rather than sharp.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 6, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -7, mid: 2, high: 10, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -10, mid: 3, high: 15, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If European gas prices spike again', trigger: 'TTF gas prices exceed \$15/MMBtu on supply disruptions.', action: 'Lock in 60–90 day forward contracts immediately. Feedstock-driven rallies in commodity chemicals can be sharp and short-lived.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese exports flood the market', trigger: 'China chemical export volumes rise more than 15% year-on-year.', action: 'Avoid long-term fixed-price commitments. Spot purchasing will offer better value as global benchmarks reprice lower.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current supply-demand balance', trigger: 'Gas prices stable, Chinese exports grow modestly.', action: 'Maintain a 30–45 day rolling inventory. Prices are unlikely to move dramatically in either direction without a macro catalyst.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'dyes': MaterialAnalysis(
    materialId: 'dyes',
    currentPrice: 5700,
    priceChange1W: 1.2,
    priceChange1M: 3.4,
    priceData1Y: _dyesSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'India Supply Disruption', detail: 'Environmental compliance enforcement near major dye-producing clusters in Gujarat temporarily curtailed output, sending reactive dye prices sharply higher as buyers scrambled for alternatives.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 32, title: 'Textile Demand Uptick', detail: 'A seasonal surge in orders from South and Southeast Asian garment manufacturers lifted dye procurement volumes and supported prices through Q3.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'India Supply Concentration', explanation: 'India accounts for over 70% of global reactive dye exports. Environmental compliance shutdowns near Surat or Ahmedabad create immediate supply shocks with limited short-term substitution options.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Textile & Apparel Demand Cycles', explanation: 'Seasonal ordering from textile brands creates predictable demand waves. The spring and autumn fashion cycles drive procurement surges that can temporarily outpace supply.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Petrochemical Input Costs', explanation: 'Benzene and naphthalene feedstock prices have moderated from peaks, reducing cost-push pressure on dye manufacturers and enabling some margin compression at the production level.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 7, confidence: 0.64),
      ForecastHorizon(label: '3 Months', low: -8, mid: 2, high: 12, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -12, mid: 3, high: 18, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Indian environmental crackdown intensifies', trigger: 'CPCB orders temporary closure of major dye clusters in Gujarat.', action: 'Accelerate procurement and build 60–90 days of safety stock. Supply disruptions from India resolve slowly and can push prices 20–30% higher within weeks.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese capacity re-enters market', trigger: 'Chinese dye producers restart idled capacity following environmental inspections.', action: 'Defer bulk purchases and buy on shorter cycles. Additional Chinese supply could push prices back toward the \$5,000/t range.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current India-led supply dynamics', trigger: 'No major regulatory disruption, textile demand steady.', action: 'Maintain 30–45 day rolling stock. Spot buying is preferable to long-term fixed contracts given India regulatory unpredictability.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'nitrogen': MaterialAnalysis(
    materialId: 'nitrogen',
    currentPrice: 285,
    priceChange1W: -0.7,
    priceChange1M: -2.3,
    priceData1Y: _nitrogenSeries,
    events: const [
      PriceEvent(weekIndex: 8, title: 'Gas Price Surge', detail: 'A winter gas shortage in Europe raised ammonia production costs, forcing European nitrogen fertilizer plants to curtail output and tightening the global urea market.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 30, title: 'Spring Planting Demand Peak', detail: 'North American and European farmers accelerated urea purchases ahead of spring planting, creating the seasonal demand spike that temporarily exhausted spot availability.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Natural Gas Cost — Dominant Input', explanation: 'Nitrogen fertilizers (urea, ammonia, AN) are energy-intensive. Gas prices have moderated from 2022 crisis peaks, allowing production costs and market prices to decline. Gas moves are the single biggest driver.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Seasonal Agricultural Demand', explanation: 'Spring planting in the Northern Hemisphere creates a predictable demand surge in Q1–Q2. Farmers and co-ops pre-buy before prices peak, making seasonality one of the most reliable trading signals.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Russian Export Policy Risk', explanation: 'Russia is among the world\'s largest urea exporters. Export quotas or sanctions-related disruptions can tighten global supply unexpectedly and rapidly.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: 2, high: 9, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -9, mid: 3, high: 14, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -13, mid: 5, high: 22, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If gas prices spike or Russian exports are restricted', trigger: 'TTF gas exceeds \$12/MMBtu or a new Russian export quota is announced.', action: 'Pre-buy at least 60 days of requirements immediately. Nitrogen prices can double in weeks when feedstock costs spike.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If gas prices continue falling', trigger: 'European TTF drops below \$7/MMBtu and stabilises there.', action: 'Reduce forward cover and lean on shorter purchase cycles. Spot prices may fall another 10–15% from current levels.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under stable gas and normal planting season', trigger: 'Gas steady, spring demand meets expectations.', action: 'Buy 30–45 days forward ahead of the Q1–Q2 planting window. Avoid large speculative positions given geopolitical volatility risk.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'phosphate_rock': MaterialAnalysis(
    materialId: 'phosphate_rock',
    currentPrice: 132,
    priceChange1W: 0.5,
    priceChange1M: 1.8,
    priceData1Y: _phosphateRockSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Morocco Export Controls', detail: 'OCP Group signalled a tightening of annual export allocations amid internal processing capacity investment, prompting importers to accelerate purchasing and lifting spot prices.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 38, title: 'India Import Surge', detail: 'India\'s fertilizer ministry accelerated DAP and MAP import tenders ahead of the rabi planting season, driving a significant uptick in phosphate rock procurement volumes.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Morocco/OCP Reserve Dominance', explanation: 'Morocco holds approximately 70% of global phosphate rock reserves and OCP Group controls a large share of export volumes. Any policy or production change from Morocco has outsized market impact.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Asian Fertilizer Demand', explanation: 'India and Southeast Asia are the largest importers of phosphate-based fertilizers. Strong rice and wheat planting seasons are driving robust import demand from these regions.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Chinese Domestic Capacity Growth', explanation: 'New Chinese DAP/MAP processing capacity is adding downstream supply but also consuming more rock domestically, providing a partial offset to export-market supply growth.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 2, high: 8, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -7, mid: 3, high: 14, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -11, mid: 6, high: 22, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If OCP reduces export allocations', trigger: 'OCP announces a reduction in annual export volumes for internal capacity investment.', action: 'Secure long-term offtake agreements with alternative suppliers early. Prices could rally 20–30% if Moroccan supply tightens materially.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese domestic supply expands rapidly', trigger: 'China lifts phosphate export restrictions and domestic output rises 10%+.', action: 'Defer large forward purchases and buy spot. Chinese supply expansion could cap global prices near \$115–120/t.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current Morocco-led supply structure', trigger: 'OCP exports steady, Asian demand grows at trend rates.', action: 'Lock in 90-day forward contracts ahead of Asian planting seasons. The structural upward trend favours buyers who cover requirements early.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'pigments': MaterialAnalysis(
    materialId: 'pigments',
    currentPrice: 2800,
    priceChange1W: 0.6,
    priceChange1M: 1.9,
    priceData1Y: _pigmentsSeries,
    events: const [
      PriceEvent(weekIndex: 16, title: 'TiO2 Supply Tightening', detail: 'A production curtailment by major titanium dioxide producers in China tightened global pigment supply and pushed benchmark prices for white pigment to a two-year high.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 34, title: 'Construction Slowdown', detail: 'A slowdown in European construction activity reduced demand for architectural coatings, the largest end-use for pigments, easing price pressure in the second half.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Titanium Dioxide (TiO2) Pricing', explanation: 'TiO2 is the dominant white pigment and a key cost reference for the broader pigments market. Chinese production cycles and chloride-route capacity utilisation drive TiO2 and overall pigment benchmarks.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Coatings & Construction Demand', explanation: 'Architectural and industrial coatings account for the majority of pigment consumption. Housing starts, infrastructure spending, and automotive production determine demand trends.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Feedstock — Ilmenite & Chlorine', explanation: 'TiO2 production requires ilmenite ore and chlorine. Tightness in either input can raise production costs and flow through to finished pigment prices.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 6, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -6, mid: 2, high: 11, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -9, mid: 4, high: 16, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If TiO2 producers curtail further', trigger: 'Major Chinese TiO2 plants announce additional capacity shutdowns for environmental compliance.', action: 'Build 60-day stock of critical pigment grades. TiO2 supply shocks transmit quickly to formulators and coatings manufacturers.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If construction activity weakens further', trigger: 'European housing starts fall more than 10% year-on-year for two consecutive quarters.', action: 'Reduce forward commitments and source spot. Demand weakness in coatings is the most reliable indicator of pigment price softening.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under steady construction demand', trigger: 'TiO2 supply normalises, coatings demand flat to slightly positive.', action: 'Quarterly procurement contracts provide adequate price predictability without over-exposing to spot volatility.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'plastics': MaterialAnalysis(
    materialId: 'plastics',
    currentPrice: 1090,
    priceChange1W: -0.5,
    priceChange1M: -1.2,
    priceData1Y: _plasticsSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Naphtha Feedstock Rally', detail: 'Crude oil-driven naphtha price increases raised ethylene and propylene cracker costs, pushing polyethylene and polypropylene prices higher across Asia and Europe.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 30, title: 'Chinese Export Surge', detail: 'Chinese polymer producers, running at high utilisation, exported aggressively into Southeast Asia and Europe, compressing regional margins and benchmark prices.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Crude Oil & Naphtha Feedstock', explanation: 'Polymer prices follow crude oil through the naphtha-to-olefin cracking chain. A 10% move in crude typically translates to a 7–9% move in polyethylene and polypropylene benchmark prices.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Chinese Production & Export', explanation: 'China\'s massive and growing petrochemical complex sets the marginal cost of supply globally. When Chinese producers run at high utilisation, export pressure caps prices in all importing regions.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Packaging & Consumer Demand', explanation: 'Polyethylene and polypropylene demand is broadly driven by packaging, automotive, and consumer goods. Retail sales cycles and e-commerce growth are primary demand variables.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: -1, high: 4, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -9, mid: 1, high: 9, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -13, mid: 2, high: 14, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If crude oil rallies sharply', trigger: 'Brent crude exceeds \$90/bbl and naphtha margins remain firm.', action: 'Pre-buy 45–60 days of polymer requirements. Feedstock-driven rallies move quickly through the petrochemical chain.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese exports accelerate', trigger: 'Chinese polymer export volumes rise more than 20% year-on-year.', action: 'Rely on spot purchasing. Chinese oversupply scenarios can push prices 10–15% below current levels within a quarter.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current crude-linked pricing', trigger: 'Crude stable, Chinese exports growing but not flooding.', action: 'Monthly procurement on rolling contracts balances price predictability against spot opportunity. Avoid multi-year fixed pricing.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'potash': MaterialAnalysis(
    materialId: 'potash',
    currentPrice: 260,
    priceChange1W: 0.4,
    priceChange1M: 1.1,
    priceData1Y: _potashSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Belarus Sanctions Impact', detail: 'Renewed enforcement of Western sanctions on Belarusian potash curtailed a significant share of global exports, tightening supply and supporting prices from an already elevated base.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 36, title: 'Brazil Contract Reset', detail: 'Brazil — the world\'s largest potash importer — concluded annual import contracts at prices below the prior year level, setting a new global benchmark and weighing on spot markets.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Russia/Belarus Export Constraints', explanation: 'Russia and Belarus together supplied around 40% of global potash before sanctions. Ongoing restrictions maintain structural supply tightness versus pre-2022 levels, keeping prices above the historical average.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Brazilian Import Demand', explanation: 'Brazil imports nearly 95% of its potash needs for a massive agricultural sector. Brazilian contract settlements set the global price tone, making them closely watched annual benchmarks.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Canadian Canpotex Supply', explanation: 'Canpotex (Nutrien and Mosaic) has ramped up exports to partially compensate for lost Russian and Belarusian volumes. Canadian supply growth is the primary offset to the geopolitical supply gap.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 6, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -6, mid: 3, high: 11, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -9, mid: 5, high: 17, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Belarus sanctions are tightened further', trigger: 'Additional enforcement actions further restrict Belarusian transit routes through Baltic ports.', action: 'Accelerate procurement to 90-day cover. Potash supply disruptions are difficult to replace quickly given limited producer alternatives.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Brazilian contract settles materially lower', trigger: 'Brazil\'s annual import contract settles below \$240/t CFR Paranagua.', action: 'Delay large forward purchases. Brazilian contract resets are the strongest leading indicator for global spot price direction.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current geopolitical supply structure', trigger: 'Belarus sanctions hold, Canadian supply grows steadily.', action: 'Quarterly purchasing ahead of planting seasons manages price timing risk. Current prices look range-bound absent a major geopolitical shift.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'salt': MaterialAnalysis(
    materialId: 'salt',
    currentPrice: 60,
    priceChange1W: 0.2,
    priceChange1M: 0.8,
    priceData1Y: _saltSeries,
    events: const [
      PriceEvent(weekIndex: 18, title: 'Severe Winter De-icing Demand', detail: 'An extended cold period across North America and Europe drove extraordinary de-icing salt purchases, temporarily drawing down inventories and lifting prices in highway-grade salt.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 40, title: 'Chlor-Alkali Capacity Expansion', detail: 'New chlor-alkali capacity in the Middle East increased industrial-grade salt demand for chlorine production, providing additional demand support outside the seasonal de-icing market.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Winter De-icing Demand', explanation: 'Road de-icing is the largest single end-use for salt in temperate markets. Severe winter weather can cause demand spikes that temporarily exhaust regional supply and lift prices.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd2', headline: 'Chemical Industry Feedstock', explanation: 'Salt is the primary feedstock for the chlor-alkali industry (chlorine and caustic soda). Growing PVC, water treatment, and specialty chemical demand provides a stable industrial demand base.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Abundant Global Supply', explanation: 'Salt is one of the world\'s most abundant minerals. Production is widespread and switching costs for buyers are low, which structurally limits price upside and volatility.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 4, confidence: 0.72),
      ForecastHorizon(label: '3 Months', low: -5, mid: 1, high: 7, confidence: 0.58),
      ForecastHorizon(label: '6 Months', low: -7, mid: 2, high: 10, confidence: 0.44),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If winter demand spikes regionally', trigger: 'Severe winter weather across major consuming regions depletes de-icing stockpiles simultaneously.', action: 'Winter-sensitive buyers should stock up in late summer. Regional supply shortages can push de-icing salt prices up 20–40% during peak demand windows.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If mild winter reduces seasonal demand', trigger: 'Average winter temperatures remain above seasonal norms in key markets.', action: 'Salt prices typically soften when de-icing demand disappoints. Defer large purchases and benefit from post-season pricing.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under normal seasonal demand', trigger: 'Average winter conditions, steady chemical industry demand.', action: 'Salt is a low-volatility commodity. Annual or semi-annual procurement contracts with regional suppliers provide adequate price stability for most buyers.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'soda_ash': MaterialAnalysis(
    materialId: 'soda_ash',
    currentPrice: 190,
    priceChange1W: -0.4,
    priceChange1M: -1.6,
    priceData1Y: _sodaAshSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'Glass Demand Surge', detail: 'Accelerating EV adoption drove an unexpected surge in automotive glass demand — soda ash\'s largest growth end-use — lifting prices above year-ago levels.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 32, title: 'Turkish Production Ramp', detail: 'A significant expansion of natural soda ash production capacity in Turkey added seaborne supply and weighed on European and Asian benchmark prices.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Flat Glass & Solar Panel Demand', explanation: 'Soda ash is essential for flat glass production. Solar panel glass demand is growing rapidly with renewable energy buildout, providing a structural demand uplift beyond traditional construction and automotive uses.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Turkish & US Natural Soda Ash', explanation: 'Turkey (Eti Soda, Kazan Soda) and the US (Green River, Wyoming) produce low-cost natural soda ash that competes with synthetic production. Capacity expansions in both regions exert structural price pressure.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Detergent & Chemical Demand', explanation: 'Detergent, water treatment, and chemical applications provide stable baseline demand that buffers against cyclical swings in glass markets.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: -1, high: 4, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -9, mid: 1, high: 8, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -13, mid: 2, high: 13, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If solar glass demand accelerates', trigger: 'Solar panel installations exceed forecasts and glass producers ramp procurement significantly.', action: 'Lock in 6-month contracts early. Solar-driven demand growth is structural and could tighten soda ash supply faster than new capacity can respond.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Turkish capacity ramps faster than expected', trigger: 'Eti Soda or Kazan Soda announce further capacity expansions ahead of schedule.', action: 'Prefer shorter-term spot or monthly contracts. Additional Turkish supply could push global prices below \$170/t.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current supply-demand balance', trigger: 'Solar demand growing steadily, Turkish supply ramp proceeding on schedule.', action: 'Quarterly contracts are appropriate for most buyers. The market is broadly balanced with a modest downward price bias from new capacity.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'sulfur': MaterialAnalysis(
    materialId: 'sulfur',
    currentPrice: 92,
    priceChange1W: -0.8,
    priceChange1M: -2.5,
    priceData1Y: _sulfurSeries,
    events: const [
      PriceEvent(weekIndex: 8, title: 'Refinery Maintenance Cuts Supply', detail: 'Coordinated refinery and sour gas plant maintenance programmes in the Middle East temporarily reduced recovered sulfur output, tightening the spot market.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 30, title: 'Fertilizer Demand Uptick', detail: 'Strong sulfur demand from phosphate fertilizer producers in Morocco and China lifted procurement volumes ahead of the spring planting season.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Oil & Gas Refinery By-product Supply', explanation: 'Over 90% of sulfur is a by-product of oil refining and sour gas processing. Supply is largely inelastic — it is recovered as an unavoidable output of desulfurisation. Rising refinery runs increase sulfur supply regardless of sulfur prices.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Phosphate Fertilizer Industry Demand', explanation: 'Sulfuric acid production for phosphate fertilizer (H3PO4, DAP, MAP) is the dominant demand use. Phosphate output cycles directly drive sulfur demand and are the key variable to watch.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Energy Transition Tail Risk', explanation: 'The long-term shift away from fossil fuels will reduce refinery sulfur recovery over decades. This creates a structural supply overhang risk that keeps long-term prices capped.', direction: PriceDirection.down, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -6, mid: -2, high: 4, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -11, mid: -1, high: 8, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -16, mid: 1, high: 13, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If phosphate producers ramp aggressively', trigger: 'OCP and Chinese phosphate plants announce major output increases requiring significantly more sulfuric acid.', action: 'Pre-buy sulfur or sulfuric acid 60 days forward. Demand-driven tightening in sulfur markets can be sharp when multiple large consumers ramp simultaneously.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If refinery runs increase and phosphate demand slows', trigger: 'Global refinery utilisation rises above 85% while fertilizer demand softens.', action: 'Rely on spot purchasing. Oversupply from refinery by-product recovery can push sulfur prices to their floor very quickly.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current refinery output and fertilizer demand', trigger: 'Refinery runs steady, phosphate demand growing at trend rates.', action: 'Monthly spot purchasing is typically sufficient given abundant supply. Longer contracts add little value unless securing specific acid grades.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'synthetic_fibers': MaterialAnalysis(
    materialId: 'synthetic_fibers',
    currentPrice: 1000,
    priceChange1W: -0.3,
    priceChange1M: -1.0,
    priceData1Y: _syntheticFibersSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'PTA Feedstock Spike', detail: 'A surge in purified terephthalic acid (PTA) prices — the primary feedstock for polyester — raised polyester fiber production costs and pushed filament yarn prices to a 12-month high.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 32, title: 'Chinese Textile Demand Weakness', detail: 'Softer-than-expected domestic apparel demand in China, the world\'s largest polyester producer and consumer, weighed on fiber prices and compressed producer margins.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'PTA & MEG Feedstock Costs', explanation: 'Polyester fiber (the dominant synthetic fiber) is made from PTA and mono-ethylene glycol (MEG), both crude oil derivatives. Crude oil price movements flow through to fiber prices via these intermediates.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Chinese Production Dominance', explanation: 'China produces over 70% of global polyester fiber. Chinese domestic demand cycles, producer inventory management, and export pricing set the global benchmark for the sector.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Fast Fashion & Sportswear Demand', explanation: 'Polyester and nylon fiber demand is driven by apparel, sportswear, and technical textiles. Athleisure growth and synthetic fabric substitution for cotton support medium-term demand.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: -1, high: 4, confidence: 0.66),
      ForecastHorizon(label: '3 Months', low: -9, mid: 1, high: 8, confidence: 0.50),
      ForecastHorizon(label: '6 Months', low: -13, mid: 2, high: 13, confidence: 0.36),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If crude oil and PTA rally together', trigger: 'Brent crude exceeds \$90/bbl and PTA margins remain firm.', action: 'Pre-buy 45–60 days of fiber requirements. Feedstock-driven cost-push moves in synthetic fibers can be rapid and sustained.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese demand remains subdued', trigger: 'Chinese apparel retail sales grow less than 3% year-on-year for two consecutive quarters.', action: 'Rely on shorter-cycle spot purchasing. Chinese market weakness typically transmits to global export prices within 4–6 weeks.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current crude-linked supply dynamics', trigger: 'Crude stable, Chinese demand recovering gradually.', action: 'Monthly procurement with 30-day forward coverage is appropriate. The market is broadly balanced with limited catalysts for a large directional move.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'synthetic_rubber': MaterialAnalysis(
    materialId: 'synthetic_rubber',
    currentPrice: 1600,
    priceChange1W: 0.7,
    priceChange1M: 2.2,
    priceData1Y: _syntheticRubberSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Butadiene Supply Squeeze', detail: 'Naphtha cracker maintenance across Asia reduced butadiene by-product supply, the key feedstock for styrene-butadiene rubber, pushing SBR prices to a multi-month high.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 30, title: 'Tire Demand Recovery', detail: 'Auto production recovery and post-pandemic vehicle fleet replenishment drove a significant uptick in tire demand, lifting synthetic rubber offtake from the world\'s largest end-use segment.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Butadiene Feedstock Pricing', explanation: 'Butadiene — the primary feedstock for SBR and polybutadiene rubber — is a by-product of naphtha cracking. Its price is notoriously volatile, driven by cracker operating rates rather than rubber demand, and is the dominant cost variable.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Tire Industry Demand', explanation: 'Tires account for approximately 60–70% of synthetic rubber consumption. Auto production volumes, replacement tire markets, and truck/fleet mileage are the primary demand signals to monitor.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Competition with Natural Rubber', explanation: 'Synthetic and natural rubber are partial substitutes in tire compounds. When natural rubber is cheap, tire makers substitute away from synthetic grades, and vice versa, moderating demand swings.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 2, high: 7, confidence: 0.65),
      ForecastHorizon(label: '3 Months', low: -7, mid: 3, high: 12, confidence: 0.49),
      ForecastHorizon(label: '6 Months', low: -11, mid: 5, high: 18, confidence: 0.35),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If butadiene supply tightens further', trigger: 'Additional Asian cracker maintenance or an unexpected outage tightens butadiene supply for more than four weeks.', action: 'Pre-buy SBR requirements for 60 days. Butadiene squeezes are fast-moving; waiting for spot availability can result in significant premium costs.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If auto production cuts reduce tire demand', trigger: 'Major OEM assembly plants announce significant production pauses exceeding 4 weeks.', action: 'Reduce forward cover and source spot. Tire demand destruction transmits quickly to SBR, and natural rubber substitution accelerates the move.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current butadiene and auto market conditions', trigger: 'Cracker rates steady, auto production recovering moderately.', action: 'Monthly to quarterly procurement cycles are appropriate. Maintain a modest safety stock buffer given butadiene\'s inherent volatility.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  // ── Minerals ──────────────────────────────────────────────────────────────
  'abrasives': MaterialAnalysis(
    materialId: 'abrasives',
    currentPrice: 960,
    priceChange1W: 0.3,
    priceChange1M: 1.0,
    priceData1Y: _abrasivesSeries,
    events: const [
      PriceEvent(weekIndex: 16, title: 'Silicon Carbide Demand Surge', detail: 'Rapid growth in SiC power semiconductors for EV inverters pulled material away from traditional abrasive applications, tightening supply of high-quality SiC grit and pushing abrasive prices higher.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 34, title: 'Chinese Export Restrictions', detail: 'China introduced new export licensing requirements for high-purity SiC and alumina, disrupting supply chains for precision abrasive manufacturers in Europe and Japan.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'SiC Semiconductor Competition', explanation: 'Silicon carbide abrasive-grade material now competes directly with semiconductor-grade SiC for EV power modules. This demand diversion from electronics is tightening the abrasive supply market and lifting prices.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Manufacturing & Automotive Output', explanation: 'Abrasives are consumed in metalworking, precision grinding, and surface finishing across automotive, aerospace, and electronics manufacturing. Industrial production trends drive the demand cycle.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Chinese Supply Dominance', explanation: 'China is the dominant producer of silicon carbide and fused alumina abrasives. Export policies and environmental production controls in China directly set global availability and pricing.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 6, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -5, mid: 2, high: 10, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -7, mid: 4, high: 16, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Chinese export controls tighten further', trigger: 'China expands export licensing to cover additional abrasive grades or restricts total volume allocations.', action: 'Build 90-day safety stock of critical abrasive grades. The SiC semiconductor demand pull is structural and unlikely to reverse.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If industrial production slows', trigger: 'Global manufacturing PMI falls below 48 for three consecutive months.', action: 'Defer bulk purchases. Abrasive demand is a reliable lagging indicator of industrial activity; price softening follows manufacturing downturns with a 4–8 week lag.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current semiconductor competition dynamics', trigger: 'EV growth continues, industrial production flat to slightly positive.', action: 'Secure annual supply agreements with diversified sources including non-Chinese fused alumina suppliers to reduce geopolitical exposure.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'bauxite': MaterialAnalysis(
    materialId: 'bauxite',
    currentPrice: 52,
    priceChange1W: 0.5,
    priceChange1M: 1.4,
    priceData1Y: _bauxiteSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Guinea Export Disruption', detail: 'Political instability in Guinea — which supplies over 50% of global seaborne bauxite — temporarily halted shipments, sending alumina prices higher and squeezing refinery margins globally.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 34, title: 'Australian Production Ramp', detail: 'Rio Tinto and South32 announced increased bauxite production from Australian mines to compensate for Guinea supply uncertainty, easing the immediate market tightness.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Guinea Supply Concentration', explanation: 'Guinea holds around 25% of global bauxite reserves and has become the dominant seaborne supplier. Political risk, infrastructure constraints, and mining licence disputes create recurring supply uncertainty.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Aluminium Production Chain Demand', explanation: 'Bauxite feeds the alumina refining chain that ultimately supplies aluminium smelters. Global aluminium demand — driven by EV lightweighting, packaging, and construction — determines the ultimate pull-through demand for bauxite.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Indonesia Export Ban on Ore', explanation: 'Indonesia\'s ban on unprocessed bauxite exports has removed a significant supply source and forced buyers toward Australian and Guinea alternatives, structurally tightening seaborne supply.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -4, mid: 1, high: 7, confidence: 0.65),
      ForecastHorizon(label: '3 Months', low: -7, mid: 3, high: 13, confidence: 0.49),
      ForecastHorizon(label: '6 Months', low: -10, mid: 5, high: 19, confidence: 0.35),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Guinea shipments are disrupted again', trigger: 'New political instability or mining licence disputes curtail Guinea bauxite exports for more than 4 weeks.', action: 'Alumina refiners should hold higher-than-normal bauxite stockpiles. Guinea supply shocks move through to alumina prices rapidly.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Guinea production normalises and Indonesia partially reverses ban', trigger: 'Guinea exports return to full capacity and Indonesia permits limited ore exports.', action: 'Reduce forward purchasing commitments. Additional seaborne supply would weigh on bauxite prices through to the alumina market.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current Guinea-dominated seaborne trade', trigger: 'Guinea exports steady, aluminium demand growing at trend rates.', action: 'Long-term offtake agreements with Guinea miners provide supply security but carry political risk. Diversify with Australian and Brazilian sources.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'cement': MaterialAnalysis(
    materialId: 'cement',
    currentPrice: 90,
    priceChange1W: 0.2,
    priceChange1M: 0.9,
    priceData1Y: _cementSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Carbon Cost Pass-Through', detail: 'European cement producers successfully passed higher EU ETS carbon credit costs through to construction buyers, lifting clinker and grey cement prices across the region.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 36, title: 'China Construction Slowdown', detail: 'Continued weakness in China\'s property sector sharply reduced domestic cement consumption, with Chinese producers directing more output toward export markets and pressuring Asian benchmark prices.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Construction Activity — Primary Demand', explanation: 'Cement demand is almost entirely driven by construction. Housing starts, infrastructure investment, and commercial real estate development in major markets like China, India, and the US are the key variables.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Energy & Carbon Cost Inflation', explanation: 'Cement kilns are highly energy-intensive. Coal and gas prices directly impact production costs. In Europe, EU ETS carbon credits add a significant cost layer that producers increasingly pass through to buyers.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Chinese Overcapacity & Export Pressure', explanation: 'China has massive structural cement overcapacity. When domestic demand slows, Chinese producers increase exports, suppressing prices in Southeast Asian and African markets.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 4, confidence: 0.70),
      ForecastHorizon(label: '3 Months', low: -5, mid: 1, high: 7, confidence: 0.55),
      ForecastHorizon(label: '6 Months', low: -7, mid: 2, high: 11, confidence: 0.40),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If infrastructure spending accelerates', trigger: 'Major government infrastructure programmes in the US, India, or EU are funded and break ground simultaneously.', action: 'Secure cement supply contracts early. Infrastructure demand surges create regional supply tightness that is slow to resolve.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If Chinese property sector remains depressed', trigger: 'Chinese property starts remain more than 20% below prior year.', action: 'In Asian markets, defer large forward commitments and negotiate shorter-term supply agreements to benefit from Chinese export pricing.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current mixed construction signals', trigger: 'Developed market infrastructure steady, Chinese property weak.', action: 'Cement is highly regional. Procurement strategy should be market-specific; global benchmarks are less relevant than local supply-demand dynamics.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'clay': MaterialAnalysis(
    materialId: 'clay',
    currentPrice: 175,
    priceChange1W: 0.1,
    priceChange1M: 0.5,
    priceData1Y: _claySeries,
    events: const [
      PriceEvent(weekIndex: 20, title: 'Paper Industry Kaolin Demand', detail: 'A rebound in coated paper production for packaging applications drove an uptick in kaolin demand, lifting pricing for high-brightness grades used in paper coating and filling.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 38, title: 'Ceramics Export Growth', detail: 'Rising exports of ceramic tiles from Spain and Italy, fuelled by construction recovery in neighbouring markets, increased ball clay procurement volumes and supported prices.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Paper & Packaging Kaolin Demand', explanation: 'Kaolin (china clay) is the primary clay grade for paper coating and filling. Paper industry production cycles, e-commerce packaging growth, and digital media substitution are the key demand variables.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd2', headline: 'Ceramics & Sanitaryware', explanation: 'Ball clay is essential for ceramic tile, sanitaryware, and tableware production. Construction activity and renovation cycles drive demand from this segment.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Abundant Regional Supply', explanation: 'Clay deposits are widespread globally. Production costs are low and supply is rarely constrained. Logistics and grade quality differentiate suppliers more than raw material scarcity.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -2, mid: 0, high: 3, confidence: 0.74),
      ForecastHorizon(label: '3 Months', low: -4, mid: 1, high: 6, confidence: 0.60),
      ForecastHorizon(label: '6 Months', low: -6, mid: 1, high: 9, confidence: 0.46),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If paper packaging demand accelerates', trigger: 'E-commerce growth drives a step-change increase in coated packaging board production requiring kaolin.', action: 'Annual supply contracts with kaolin producers provide pricing certainty in a tightening market. High-brightness grades are most vulnerable to supply tightness.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If ceramics production slows', trigger: 'European and Asian ceramics output falls more than 8% year-on-year.', action: 'Clay prices are stable and the downside is limited. Existing supply agreements can typically be renegotiated without significant penalties.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current steady industrial demand', trigger: 'Paper and ceramics demand growing at trend rates.', action: 'Clay is a low-volatility commodity. Annual or biannual procurement agreements with regional producers are appropriate for most buyers.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'construction_aggregate': MaterialAnalysis(
    materialId: 'construction_aggregate',
    currentPrice: 12.5,
    priceChange1W: 0.1,
    priceChange1M: 0.4,
    priceData1Y: _constructionAggregateSeries,
    events: const [
      PriceEvent(weekIndex: 22, title: 'Infrastructure Bill Funding', detail: 'Release of funds under major infrastructure legislation in the US drove a surge in aggregate demand for highway and bridge construction, lifting regional prices in constrained supply markets.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 40, title: 'Quarry Permitting Delays', detail: 'Stricter environmental permitting requirements delayed new quarry openings in several key supply-deficit markets, constraining supply growth and supporting prices above inflation.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Infrastructure Investment', explanation: 'Road, rail, and utility construction are the primary aggregate consumers. Government infrastructure spending programmes directly drive demand and are the most important market variable for long-term pricing.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Housing Construction Activity', explanation: 'Residential construction consumes significant aggregate volumes for foundations, driveways, and site preparation. Housing starts and renovation activity are important secondary demand drivers.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Quarry Permitting & Transport Costs', explanation: 'Aggregates are heavy and expensive to transport relative to value. Local supply constraints from permitting difficulties and transport cost inflation are structural price support mechanisms in supply-tight regions.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -2, mid: 0, high: 3, confidence: 0.76),
      ForecastHorizon(label: '3 Months', low: -3, mid: 1, high: 5, confidence: 0.62),
      ForecastHorizon(label: '6 Months', low: -4, mid: 2, high: 8, confidence: 0.48),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If infrastructure funding accelerates project starts', trigger: 'Multiple large infrastructure projects break ground simultaneously in supply-constrained regions.', action: 'Lock in volume commitments with local quarries early in project planning. Aggregate supply tightness is hyperlocal and difficult to resolve by importing from distant sources.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If construction activity slows significantly', trigger: 'Housing starts fall more than 15% and infrastructure project deferrals increase.', action: 'Aggregates have low price volatility on the downside. Existing supply contracts can often be reduced in volume without significant premium costs.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current steady infrastructure demand', trigger: 'Infrastructure spending growing at trend, housing stable.', action: 'Annual volume agreements with local quarries provide supply security for large projects. Spot purchasing is adequate for smaller or flexible requirements.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'diamond': MaterialAnalysis(
    materialId: 'diamond',
    currentPrice: 1.12,
    priceChange1W: -0.9,
    priceChange1M: -3.2,
    priceData1Y: _diamondSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'Lab-Grown Diamond Price Collapse', detail: 'The retail price of lab-grown diamond melee fell more than 50% year-on-year as production capacity surged, triggering a sharp re-evaluation of natural diamond pricing across the industry.', impact: PriceDirection.down),
      PriceEvent(weekIndex: 28, title: 'De Beers Sight Allocation Cut', detail: 'De Beers reduced its October sight allocation by 15–20% as sightholder demand weakened, signalling softening downstream sentiment and reinforcing bearish price momentum.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Lab-Grown Diamond Disruption', explanation: 'Rapid capacity growth in lab-grown diamonds (LGD) has created a pricing crisis for natural diamonds in the melee and smaller-stone segments. LGD prices are collapsing, forcing natural diamond producers to find a distinct value proposition.', direction: PriceDirection.down, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Luxury Jewellery Demand', explanation: 'Natural diamond demand is fundamentally driven by luxury jewellery gifting, particularly in the US, China, and India. Consumer confidence, wealth effects, and bridal jewellery cycles drive the high end of the market.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Russian Sanctions on ALROSA', explanation: 'Western sanctions on ALROSA — responsible for 30% of global natural diamond mining — have disrupted supply chains. The G7 traceability requirement adds friction but has not eliminated Russian diamonds from the market.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -5, mid: -2, high: 2, confidence: 0.62),
      ForecastHorizon(label: '3 Months', low: -10, mid: -3, high: 4, confidence: 0.46),
      ForecastHorizon(label: '6 Months', low: -15, mid: -4, high: 6, confidence: 0.32),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If luxury demand rebounds strongly', trigger: 'Chinese consumer confidence recovers sharply and US jewellery sales exceed pre-LGD-disruption growth rates.', action: 'Large natural diamonds (2ct+) are most insulated from LGD competition. Jewellers should differentiate their assortment toward sizes and cuts where lab-grown substitution is weakest.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If lab-grown adoption accelerates further', trigger: 'Major bridal jewellery retailers expand LGD assortment to more than 50% of diamond sales.', action: 'Natural diamond inventory should be managed conservatively. The melee and smaller-stone segments face structural price pressure that is unlikely to reverse.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current LGD disruption dynamics', trigger: 'LGD adoption continues but luxury natural diamond positioning holds.', action: 'For industrial diamond buyers, LGD disruption is a tailwind — costs are falling. For jewellery buyers, focus on provenance-certified large stones where natural origin commands a premium.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'diatomite': MaterialAnalysis(
    materialId: 'diatomite',
    currentPrice: 295,
    priceChange1W: 0.2,
    priceChange1M: 0.7,
    priceData1Y: _diatomiteSeries,
    events: const [
      PriceEvent(weekIndex: 18, title: 'Beverage Filtration Demand', detail: 'A recovery in global beer and wine production following post-pandemic normalisation drove higher demand for diatomite filter aids, lifting prices for food-grade grades.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 36, title: 'US Production Expansion', detail: 'Imerys expanded its Lompoc, California diatomite operations, adding incremental supply to the market and easing pricing pressure from tightening food-grade availability.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Filtration & Beverage Industry Demand', explanation: 'Diatomite is the primary filter aid for beer, wine, and edible oil production. Global beverage industry output is the dominant demand driver. Recovery in craft brewing and premium spirits has been a positive recent trend.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd2', headline: 'Industrial Absorbent Applications', explanation: 'Diatomite is used as an absorbent and carrier in agrochemicals, paints, and industrial processes. These diverse applications provide demand diversification but are less price-sensitive than filtration grades.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Concentrated Producer Market', explanation: 'Imerys and EP Minerals (US Silica) control the majority of high-quality diatomite deposits. This concentrated supply structure supports prices and limits spot market volatility.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -2, mid: 1, high: 4, confidence: 0.72),
      ForecastHorizon(label: '3 Months', low: -4, mid: 1, high: 7, confidence: 0.58),
      ForecastHorizon(label: '6 Months', low: -6, mid: 2, high: 10, confidence: 0.44),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If beverage production surges', trigger: 'Global beer and wine output grows more than 5% year-on-year, outpacing filter aid supply.', action: 'Secure annual supply contracts with Imerys or EP Minerals early. Food-grade diatomite is a specialty product and spot availability is limited in tightening markets.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If new capacity additions are brought forward', trigger: 'A major producer accelerates an expansion project by more than 6 months.', action: 'Defer annual contract renewals slightly and negotiate shorter initial terms. New capacity additions can shift pricing leverage toward buyers.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current beverage recovery dynamics', trigger: 'Beverage demand growing steadily, supply additions on schedule.', action: 'Annual contracts with established suppliers are the standard approach. Diatomite is a specialty market with limited spot liquidity — relationship-based procurement is more important than spot benchmarking.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'feldspar': MaterialAnalysis(
    materialId: 'feldspar',
    currentPrice: 84,
    priceChange1W: 0.1,
    priceChange1M: 0.4,
    priceData1Y: _feldsparSeries,
    events: const [
      PriceEvent(weekIndex: 24, title: 'Ceramic Tile Export Boom', detail: 'Strong demand for Spanish and Italian ceramic tiles in North African and Middle Eastern markets boosted feldspar consumption from the ceramics industry, the dominant end-use sector.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 40, title: 'Turkish Capacity Expansion', detail: 'Turkey — the world\'s largest feldspar producer — commissioned new processing capacity, increasing global supply and moderating price pressure from the mid-year demand spike.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Ceramics & Glass Industry Demand', explanation: 'Feldspar is a primary flux in ceramic tile, sanitaryware, and glass production. These industries account for over 90% of feldspar consumption. Construction and renovation cycles are the dominant demand drivers.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Turkish & Italian Supply', explanation: 'Turkey is the world\'s largest feldspar producer and exporter, followed by Italy. Turkish expansion and policy decisions set the marginal cost of global seaborne feldspar supply.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Abundant Global Reserves', explanation: 'Feldspar is one of the earth\'s most common minerals. Proven reserves far exceed any plausible demand scenario, limiting long-term price appreciation potential.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -2, mid: 0, high: 3, confidence: 0.75),
      ForecastHorizon(label: '3 Months', low: -4, mid: 1, high: 5, confidence: 0.61),
      ForecastHorizon(label: '6 Months', low: -6, mid: 1, high: 8, confidence: 0.47),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If ceramic production surges in new markets', trigger: 'Significant new ceramic tile capacity comes online in India or Southeast Asia, driving a step-change in feldspar demand.', action: 'Secure volume commitments with Turkish or Italian producers. The lead time for new feldspar processing capacity is 18–24 months.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If construction activity weakens broadly', trigger: 'Global ceramic tile production falls more than 8% year-on-year.', action: 'Feldspar prices are stable with limited downside. Existing supply agreements can typically accommodate volume reductions without penalty.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current steady ceramics demand', trigger: 'Ceramics production growing at trend, Turkish supply growing proportionally.', action: 'Annual contracts with Turkish or Italian producers are standard. Feldspar is a low-volatility commodity and procurement complexity is low.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'gemstones': MaterialAnalysis(
    materialId: 'gemstones',
    currentPrice: 850,
    priceChange1W: 0.4,
    priceChange1M: 1.5,
    priceData1Y: _gemstonesSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Colombian Emerald Supply Tightening', detail: 'Security incidents in the Muzo mining region of Colombia disrupted emerald extraction for approximately six weeks, tightening global fine emerald supply and lifting prices for top-quality stones.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 32, title: 'Hong Kong Jewellery Fair Recovery', detail: 'The return of full attendance at the Hong Kong Jewellery & Gem Fair signalled a strong recovery in Asian demand, with buyers competing aggressively for certified rubies and sapphires.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Luxury Consumer Demand', explanation: 'Coloured gemstone demand is driven by high-net-worth and ultra-high-net-worth consumers globally. Wealth creation in Asia, particularly China and India, has been the most powerful structural demand driver of the past decade.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Origin & Certification Premium', explanation: 'Provenance matters enormously. Burmese rubies, Colombian emeralds, and Kashmir sapphires command multiples of the price of equivalent stones from other origins. GRS and Gübelin certification adds significant value.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Lab-Grown Coloured Stone Competition', explanation: 'Lab-grown coloured gemstones are becoming more widely available and accepted in fashion jewellery. Fine natural gemstone prices are largely insulated at the top end, but the mid-market faces growing pressure.', direction: PriceDirection.down, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 2, high: 7, confidence: 0.61),
      ForecastHorizon(label: '3 Months', low: -6, mid: 3, high: 12, confidence: 0.45),
      ForecastHorizon(label: '6 Months', low: -9, mid: 5, high: 18, confidence: 0.32),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Asian luxury demand strengthens', trigger: 'Chinese consumer confidence rebounds sharply and Hong Kong auction results for top lots exceed 2021 peak levels.', action: 'Fine certified gemstones (3ct+ rubies, sapphires, emeralds) from premium origins appreciate most in bull markets. Early acquisition before auction season is advantageous.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If global luxury spending contracts', trigger: 'Global wealth contraction or a significant equity market correction reduces discretionary luxury spending.', action: 'The gemstone market is illiquid. Avoid forced selling in a downturn. Top-quality stones hold value better than mid-market grades.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current Asian-led luxury demand', trigger: 'Asian demand growing steadily, supply from key origins constrained.',  action: 'Fine certified stones from premium origins offer the best long-term value preservation. Avoid uncertified mid-market stones where lab-grown competition is most intense.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'glass_silica': MaterialAnalysis(
    materialId: 'glass_silica',
    currentPrice: 37,
    priceChange1W: 0.2,
    priceChange1M: 0.6,
    priceData1Y: _glassSilicaSeries,
    events: const [
      PriceEvent(weekIndex: 16, title: 'Solar Glass Demand Surge', detail: 'Accelerating solar panel installations globally drove unprecedented demand for high-purity silica sand used in solar glass production, tightening supply of ultra-low-iron grades.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 36, title: 'New Australian Silica Mine', detail: 'VRX Silica and Diatreme Resources commissioned new high-purity silica operations in Western Australia, adding supply to the growing export market for solar and photovoltaic glass.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Solar Panel Glass Demand', explanation: 'The rapid global buildout of solar photovoltaic capacity is driving strong demand growth for ultra-low-iron silica sand used in solar glass. This is the highest-growth end-use and commands the highest price premiums.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Flat Glass & Container Markets', explanation: 'Architectural flat glass and glass containers are the largest volume end-uses. Construction activity and beverage/food packaging trends drive baseline demand for standard-grade silica.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Silica Sand Supply Geography', explanation: 'High-purity silica suitable for solar and specialty glass is geographically concentrated. Australia, Vietnam, and a few US deposits dominate premium grade supply. Standard grades are abundantly available worldwide.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -2, mid: 1, high: 4, confidence: 0.70),
      ForecastHorizon(label: '3 Months', low: -4, mid: 2, high: 7, confidence: 0.55),
      ForecastHorizon(label: '6 Months', low: -5, mid: 3, high: 10, confidence: 0.41),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If solar installations accelerate beyond forecasts', trigger: 'Global solar PV installations exceed 600 GW/year, requiring step-change increases in solar glass supply.', action: 'Solar glass manufacturers should secure long-term supply agreements for ultra-low-iron silica from Australian or Vietnamese producers. Premium grade supply cannot be quickly expanded.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If solar policy incentives are reduced', trigger: 'Major markets reduce solar installation subsidies materially, slowing PV capacity additions.', action: 'Standard silica prices are stable and unlikely to fall significantly. Ultra-low-iron premiums would compress. Shorter-term contracts would reduce price risk.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current solar-led demand growth', trigger: 'Solar installations growing at forecast rates, Australian supply ramping proportionally.', action: 'High-purity grades require long-term supply agreements. Standard grades can be sourced spot or via annual contracts from regional suppliers.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'graphite': MaterialAnalysis(
    materialId: 'graphite',
    currentPrice: 880,
    priceChange1W: -1.1,
    priceChange1M: -3.8,
    priceData1Y: _graphiteSeries,
    events: const [
      PriceEvent(weekIndex: 10, title: 'China Export Controls', detail: 'China imposed export permit requirements on flake graphite and high-purity graphite products, citing strategic resource concerns. The announcement immediately tightened global supply expectations and spiked prices.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 28, title: 'Synthetic Graphite Capacity Ramp', detail: 'Battery manufacturers accelerated investment in synthetic graphite anode capacity outside China, partially offsetting dependence on Chinese natural graphite and easing market tension.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'EV Battery Anode Demand', explanation: 'Graphite is the dominant anode material in lithium-ion batteries. Each EV battery pack requires 50–100kg of graphite. Rapid EV adoption is driving a structural demand acceleration that will persist for decades.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Chinese Supply & Export Controls', explanation: 'China produces over 65% of global natural flake graphite and is the dominant processor of battery-grade spherical graphite. Export controls represent a significant geopolitical risk for non-Chinese battery supply chains.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Synthetic Graphite Competition', explanation: 'Synthetic graphite anodes can substitute for natural graphite in some battery applications. As non-Chinese synthetic capacity grows, it partially mitigates supply chain dependence on Chinese natural graphite.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -6, mid: -1, high: 5, confidence: 0.63),
      ForecastHorizon(label: '3 Months', low: -10, mid: 2, high: 14, confidence: 0.47),
      ForecastHorizon(label: '6 Months', low: -13, mid: 4, high: 22, confidence: 0.33),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If China tightens graphite export permits further', trigger: 'China expands export permit scope or introduces volume quotas on battery-grade graphite.', action: 'Battery manufacturers should accelerate diversification toward African (Mozambique, Madagascar) and North American graphite sources. The cost premium for non-Chinese material is justified by supply security.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If EV demand disappoints', trigger: 'Global EV sales growth falls below 15% year-on-year for two consecutive quarters.', action: 'Graphite anode inventory is expensive to hold. If EV demand softens, battery producers may extend their existing supply agreements rather than signing new long-term contracts at current prices.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current EV growth and China export control regime', trigger: 'EV adoption on trend, China permits system adding friction but not blocking flows.', action: 'Diversify the anode supply base now. Chinese material will remain cost-competitive but geopolitical risk justifies paying a small premium for supply chain optionality.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'gravel': MaterialAnalysis(
    materialId: 'gravel',
    currentPrice: 10.5,
    priceChange1W: 0.1,
    priceChange1M: 0.3,
    priceData1Y: _gravelSeries,
    events: const [
      PriceEvent(weekIndex: 20, title: 'Road Construction Season', detail: 'Warm weather in key markets kicked off the road construction season, driving a seasonal surge in gravel and crushed stone demand that temporarily tightened regional supply.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 42, title: 'Fuel Cost Increases', detail: 'Rising diesel prices increased extraction and transport costs for quarry operators, who successfully passed higher logistics costs through to gravel prices in most markets.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Road & Infrastructure Construction', explanation: 'Gravel and crushed stone are the primary materials for road base, drainage, and concrete aggregate in infrastructure projects. Government spending programmes are the most important long-term demand variable.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd2', headline: 'Transport Cost Sensitivity', explanation: 'Gravel has very low value per tonne relative to transport cost. Local supply proximity determines delivered prices more than global market dynamics. Fuel price inflation directly impacts quarry economics.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Abundant Supply', explanation: 'Gravel and crushed stone deposits are widely available. Supply constraints are driven by permitting, land access, and logistics rather than geological scarcity. This limits price upside.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -2, mid: 0, high: 3, confidence: 0.77),
      ForecastHorizon(label: '3 Months', low: -3, mid: 1, high: 5, confidence: 0.63),
      ForecastHorizon(label: '6 Months', low: -4, mid: 1, high: 7, confidence: 0.49),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If infrastructure projects surge simultaneously', trigger: 'Multiple large road and bridge projects begin in the same region, creating acute local supply competition.', action: 'Identify and contract with local quarries before construction season. Gravel supply tightness is hyperlocal and difficult to resolve through spot purchases from distant sources.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If construction activity slows materially', trigger: 'Housing starts fall more than 20% and infrastructure project deferrals increase.', action: 'Gravel prices are stable on the downside. Existing supply contracts can typically be wound down without significant financial penalty.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current steady construction demand', trigger: 'Infrastructure and housing demand growing at trend rates.', action: 'Annual volume agreements with local quarries provide supply security and modest price stability for large construction projects.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'gypsum': MaterialAnalysis(
    materialId: 'gypsum',
    currentPrice: 20,
    priceChange1W: 0.2,
    priceChange1M: 0.5,
    priceData1Y: _gypsumSeries,
    events: const [
      PriceEvent(weekIndex: 18, title: 'Wallboard Demand Surge', detail: 'A recovery in US housing construction drove strong demand for gypsum wallboard, lifting prices for both synthetic FGD gypsum and natural gypsum rock at quarry level.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 38, title: 'FGD Supply Reduction', detail: 'Coal power plant retirements reduced flue-gas desulfurisation (FGD) gypsum by-product supply, tightening the synthetic gypsum market and supporting prices for both natural and synthetic grades.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Wallboard & Construction Demand', explanation: 'Gypsum wallboard (drywall) is the primary end-use for gypsum. US housing starts and commercial construction activity are the dominant demand drivers. A 10% change in housing starts typically moves wallboard production volumes by 6–8%.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'FGD By-product Supply Dynamics', explanation: 'Coal power plant desulfurisation produces synthetic gypsum that competes with natural gypsum. As coal plants retire globally, this by-product supply is declining, providing structural long-term support to natural gypsum prices.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Cement Industry Demand', explanation: 'Gypsum is added to Portland cement clinker as a set retarder, providing stable baseline demand from the construction materials industry regardless of housing cycle fluctuations.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 4, confidence: 0.72),
      ForecastHorizon(label: '3 Months', low: -5, mid: 1, high: 7, confidence: 0.58),
      ForecastHorizon(label: '6 Months', low: -6, mid: 2, high: 9, confidence: 0.44),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If housing construction rebounds sharply', trigger: 'US housing starts exceed 1.6 million annualised units for two consecutive months.', action: 'Wallboard manufacturers should secure natural gypsum supply contracts. FGD by-product supply decline means natural gypsum will carry more of the demand increase.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If housing starts fall sharply', trigger: 'US housing starts fall below 1.1 million annualised units.', action: 'Gypsum demand compression follows housing closely. Avoid long-term fixed-volume commitments if construction slowdown appears durable.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current stable construction demand', trigger: 'Housing steady, FGD supply declining gradually.',  action: 'Annual supply contracts with natural gypsum quarries are appropriate. The long-term trend of declining FGD supply supports moderate price appreciation.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'lime': MaterialAnalysis(
    materialId: 'lime',
    currentPrice: 128,
    priceChange1W: 0.3,
    priceChange1M: 0.8,
    priceData1Y: _limeSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Steel Industry Demand Recovery', detail: 'A pickup in global steel production drove higher lime consumption for slag conditioning and desulfurisation in blast furnaces and electric arc furnaces, tightening supply in key steel-producing regions.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 32, title: 'Water Treatment Demand Growth', detail: 'Expanding municipal water treatment infrastructure in developing markets drove sustained growth in hydrated lime demand for pH adjustment and softening applications.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Steel Industry Demand', explanation: 'Steel production is the largest single end-use for lime, consuming approximately 25–30% of output. Lime is used for slag conditioning, desulfurisation, and water treatment at steel plants. Steel cycle fluctuations directly drive lime demand.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Environmental & Water Treatment', explanation: 'Lime is essential for flue gas desulfurisation, water and wastewater treatment, and soil stabilisation. Environmental regulations requiring higher standards for industrial emissions and water quality are a structural demand growth driver.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Energy-Intensive Production', explanation: 'Lime kilns are high-energy consumers. Natural gas and coal costs significantly impact production economics and are partially passed through to customers, creating cost-linked price variability.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 5, confidence: 0.70),
      ForecastHorizon(label: '3 Months', low: -5, mid: 2, high: 8, confidence: 0.55),
      ForecastHorizon(label: '6 Months', low: -7, mid: 3, high: 12, confidence: 0.41),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If steel production recovers strongly', trigger: 'Global crude steel output exceeds 1.9 billion tonnes annualised and EAF adoption accelerates.', action: 'Steel producers should lock in annual lime supply contracts before demand spikes. Lime has limited spare production capacity — demand surges take 12–18 months to add new kiln capacity.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If steel demand falls and energy costs rise sharply', trigger: 'Steel production falls more than 8% while gas prices rise, squeezing lime producer margins.', action: 'Lime buyers may be able to renegotiate downward on volume. However, lime is a cost-of-production-linked commodity and energy cost pass-through limits downside.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current steel and environment-led demand', trigger: 'Steel output stable, environmental lime demand growing steadily.', action: 'Annual supply contracts are standard for major lime-consuming industries. Prices are driven more by energy costs and local supply capacity than by global market dynamics.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'limestone': MaterialAnalysis(
    materialId: 'limestone',
    currentPrice: 24,
    priceChange1W: 0.1,
    priceChange1M: 0.3,
    priceData1Y: _limestoneSeries,
    events: const [
      PriceEvent(weekIndex: 22, title: 'Cement Production Ramp', detail: 'Indian cement capacity expansion programmes drove a significant increase in limestone quarrying activity, with several new limestone mines entering production to serve emerging cement clusters.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 40, title: 'Crushed Stone Export Growth', detail: 'Growing demand for crushed limestone from road construction programmes in East Africa prompted several major producers to redirect material from domestic to export markets, easing local supply.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Cement Industry — Dominant Consumer', explanation: 'Cement production consumes approximately 75% of global limestone output. The health of the cement industry and construction sector is therefore the primary variable for limestone demand and pricing.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Aggregate & Agricultural Demand', explanation: 'Crushed limestone for road aggregate and agricultural lime for soil pH adjustment provide diversified demand streams that are less cyclical than cement and support baseline quarry economics.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Abundant Reserves, Local Logistics', explanation: 'Limestone is one of the most abundant rocks on earth. Pricing is dominated by quarrying costs, transport distances, and permitting rather than geological scarcity. Local dynamics matter far more than global supply.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -2, mid: 0, high: 3, confidence: 0.77),
      ForecastHorizon(label: '3 Months', low: -3, mid: 1, high: 5, confidence: 0.63),
      ForecastHorizon(label: '6 Months', low: -4, mid: 1, high: 7, confidence: 0.49),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If cement production accelerates in supply-tight regions', trigger: 'New cement capacity in supply-deficit markets competes for limestone from a limited number of permitted quarries.', action: 'Cement producers planning greenfield plants should secure long-term limestone supply agreements as part of project planning, before quarry capacity is committed to competitors.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If construction activity falls broadly', trigger: 'Cement production falls more than 10% globally.', action: 'Limestone prices are stable on the downside given low extraction costs. Volume reductions in existing contracts are typically negotiable.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current cement-led demand', trigger: 'Cement industry growing at trend, no major supply disruption.',  action: 'Limestone is a low-volatility, logistics-intensive commodity. Local supply security and reliable transport access matter more than global price benchmarking.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'marble': MaterialAnalysis(
    materialId: 'marble',
    currentPrice: 192,
    priceChange1W: 0.4,
    priceChange1M: 1.2,
    priceData1Y: _marbleSeries,
    events: const [
      PriceEvent(weekIndex: 16, title: 'Middle East Luxury Construction', detail: 'Accelerating luxury real estate and hospitality development in the Gulf region drove a surge in demand for premium white marble (Calacatta, Statuario), pushing Italian quarry gate prices to multi-year highs.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 36, title: 'Turkish Export Expansion', detail: 'Turkish marble exporters increased block and slab output, capturing market share from Italian premium grades in mid-market applications and easing pricing pressure for standard white varieties.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Luxury Construction & Architecture', explanation: 'Premium marble demand is driven by high-end residential, hospitality, and commercial architecture. Gulf construction projects, luxury residential markets, and hotel sector investment are the key demand drivers for premium Italian and Greek grades.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Turkish & Chinese Competition', explanation: 'Turkey is the world\'s largest marble exporter and China is the largest producer. Both countries offer competitive pricing for standard grades, capping price appreciation for non-premium marble varieties.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Engineered Stone Competition', explanation: 'Engineered quartz and sintered stone (Dekton, Silestone) are gaining share in kitchen and bathroom applications where marble was traditionally specified. This substitution pressure is a structural demand headwind for standard grades.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 6, confidence: 0.65),
      ForecastHorizon(label: '3 Months', low: -6, mid: 2, high: 11, confidence: 0.49),
      ForecastHorizon(label: '6 Months', low: -9, mid: 4, high: 17, confidence: 0.35),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Gulf construction activity accelerates', trigger: 'Saudi Vision 2030 and UAE Expo legacy projects drive a step-change in premium marble specification volumes.', action: 'Premium grade marble (Calacatta, Carrara) supply from Italian quarries is limited and cannot be quickly expanded. Early commitment to quarry allocations is essential for large luxury projects.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If engineered stone adoption accelerates', trigger: 'Major specification guides and interior designers shift default recommendations from marble to sintered stone for residential applications.', action: 'Standard marble grades face the greatest competition from engineered alternatives. Differentiate toward provenance, grade, and finish rather than competing on price.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current luxury construction demand', trigger: 'Gulf and Asian luxury markets growing, Italian supply constrained.',  action: 'Premium certified Italian and Greek marble commands a durable quality premium. For standard grades, Turkish and Chinese sources offer better value with adequate quality.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'quartz_crystal': MaterialAnalysis(
    materialId: 'quartz_crystal',
    currentPrice: 4600,
    priceChange1W: 0.8,
    priceChange1M: 2.6,
    priceData1Y: _quartzCrystalSeries,
    events: const [
      PriceEvent(weekIndex: 12, title: 'Semiconductor Grade Shortage', detail: 'A surge in demand for high-purity quartz (HPQ) crucibles used in silicon ingot production for semiconductors tightened supply of Unimin/Sibelco\'s Spruce Pine-sourced quartz, sending prices sharply higher.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 30, title: 'Solar Wafer Demand', detail: 'Rapid growth in solar wafer production — which also requires HPQ crucibles — added further demand pressure to an already tight high-purity quartz market.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Semiconductor & Solar Wafer Demand', explanation: 'High-purity quartz is a critical and irreplaceable input for silicon crystal growth for both semiconductors and solar cells. The chip cycle and solar installation boom are the two most powerful demand drivers.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Geographic Supply Concentration', explanation: 'Commercial-scale high-purity quartz deposits are extremely rare. The Spruce Pine, North Carolina deposits (controlled by Unimin/Sibelco and The Quartz Corp) supply the majority of semiconductor-grade material globally, creating critical concentration risk.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd3', headline: 'Norwegian & Norwegian New Sources', explanation: 'The Quartz Corp\'s Norwegian operations provide a second source of high-quality quartz. Limited new deposit development globally keeps supply growth constrained relative to structural demand growth.', direction: PriceDirection.down, magnitude: DriverMagnitude.mild),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 2, high: 8, confidence: 0.64),
      ForecastHorizon(label: '3 Months', low: -5, mid: 4, high: 15, confidence: 0.48),
      ForecastHorizon(label: '6 Months', low: -7, mid: 6, high: 22, confidence: 0.34),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If semiconductor cycle peaks simultaneously with solar demand', trigger: 'Chip capex surges and solar wafer production both accelerate in the same year, requiring more HPQ crucibles than producers can supply.', action: 'HPQ crucibles are a bottleneck input with no substitutes. Chip and solar manufacturers should maintain 90-day+ inventory of HPQ-sourced crucibles.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If semiconductor cycle enters a downturn', trigger: 'Global chip demand falls and wafer fab utilisation drops below 75% industry-wide.', action: 'HPQ demand falls with chip production cycles. Existing HPQ supply agreements may allow volume step-downs; negotiate this flexibility upfront.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current combined chip and solar demand growth', trigger: 'Semiconductor cycle positive, solar installations growing strongly.',  action: 'HPQ is a critical material requiring long-term supply relationships. Spot purchasing is rarely possible given limited availability. Establish direct supply agreements with Unimin or TQC.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'rocks': MaterialAnalysis(
    materialId: 'rocks',
    currentPrice: 50,
    priceChange1W: 0.1,
    priceChange1M: 0.4,
    priceData1Y: _rocksSeries,
    events: const [
      PriceEvent(weekIndex: 24, title: 'Dimension Stone Export Growth', detail: 'Rising export demand for dimension stone (granite, sandstone, slate) from India and China lifted quarry-gate prices as international buyers competed for premium slabs and blocks.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 42, title: 'Landscaping Season Demand', detail: 'Strong residential landscaping activity drove above-average demand for decorative rock and crushed stone, creating temporary localised supply tightness in key markets.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Construction & Landscaping Demand', explanation: 'Crushed rock and dimension stone demand is closely tied to construction activity, landscaping trends, and infrastructure investment. Housing renovation cycles are an important secondary demand driver.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd2', headline: 'Export Demand for Dimension Stone', explanation: 'Globally traded dimension stone (granite countertops, marble flooring, slate cladding) is driven by architectural trends and affluent consumer preferences, particularly in North America and the Middle East.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Transport Cost Sensitivity', explanation: 'Bulk rock is expensive to transport relative to its value. Local quarry proximity is the dominant factor in delivered price competitiveness. Fuel cost inflation directly impacts quarry economics.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -2, mid: 0, high: 3, confidence: 0.76),
      ForecastHorizon(label: '3 Months', low: -3, mid: 1, high: 5, confidence: 0.62),
      ForecastHorizon(label: '6 Months', low: -5, mid: 1, high: 8, confidence: 0.48),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If construction and landscaping activity surges', trigger: 'Housing renovation spending and infrastructure construction ramp simultaneously, exhausting local quarry supply.',  action: 'Secure annual supply agreements with local quarries early in the construction season. Rock supply is hyperlocal and cannot be efficiently supplemented from distant sources.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If construction slows materially', trigger: 'Housing starts fall more than 15% and infrastructure deferrals increase.', action: 'Rock prices are stable on the downside. Existing supply contracts can typically be wound down without significant penalty.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current steady construction demand', trigger: 'Construction growing at trend, landscaping spending healthy.', action: 'Annual volume agreements with established local quarries provide adequate supply security. Dimension stone buyers should verify origin certification for premium grades.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'sand': MaterialAnalysis(
    materialId: 'sand',
    currentPrice: 28,
    priceChange1W: 0.2,
    priceChange1M: 0.5,
    priceData1Y: _sandSeries,
    events: const [
      PriceEvent(weekIndex: 18, title: 'Frac Sand Demand Surge', detail: 'A rebound in US shale drilling activity drove strong demand for proppant-grade frac sand, pushing prices for fine-grained silica sand above levels seen since the 2018 drilling boom.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 36, title: 'Southeast Asia Sand Export Bans', detail: 'Vietnam and Cambodia expanded restrictions on river sand exports, further tightening the regional supply of construction sand for Singapore, Hong Kong, and coastal China.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Construction Demand — Concrete & Fill', explanation: 'Construction sand for concrete production and site fill is the largest volume end-use. Housing, infrastructure, and commercial construction trends directly drive demand. Sand quality requirements vary significantly by application.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Frac Sand — Oil & Gas Drilling', explanation: 'High-quality silica sand for hydraulic fracturing is a significant and volatile demand source. US shale drilling activity cycles create boom-bust demand swings that drive frac sand prices independently of construction sand.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Southeast Asia Export Restrictions', explanation: 'Regional river sand export bans (Vietnam, Cambodia, Indonesia) have created acute supply shortages in densely populated coastal Asian markets. This structural shortage is supporting sand prices well above historical averages in the region.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 4, confidence: 0.71),
      ForecastHorizon(label: '3 Months', low: -5, mid: 1, high: 7, confidence: 0.57),
      ForecastHorizon(label: '6 Months', low: -7, mid: 2, high: 10, confidence: 0.43),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If Southeast Asian export bans tighten further', trigger: 'Additional ASEAN countries restrict sand exports or existing bans are enforced more strictly.', action: 'Construction buyers in supply-deficit Asian markets should evaluate manufactured sand and quarry dust alternatives. Dependence on river sand exports carries increasing regulatory risk.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If shale drilling slows', trigger: 'US rig count falls below 500 on sustained weak oil prices.', action: 'Frac sand demand can fall rapidly in drilling downturns. Producers with frac sand exposure should consider volume flexibility terms in supply agreements.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current construction and drilling demand', trigger: 'Construction steady, shale drilling at moderate levels.',  action: 'Differentiate procurement strategy by sand type. Construction sand is hyperlocal; frac sand is a commodity where national pricing applies.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'stone': MaterialAnalysis(
    materialId: 'stone',
    currentPrice: 25,
    priceChange1W: 0.1,
    priceChange1M: 0.3,
    priceData1Y: _stoneSeries,
    events: const [
      PriceEvent(weekIndex: 20, title: 'Infrastructure Programme Funding', detail: 'Approval of multi-year road and bridge funding programmes in multiple US states drove forward contracting for crushed stone, supporting prices and encouraging quarry capacity investment.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 42, title: 'Diesel Cost Inflation', detail: 'Rising diesel prices increased hauling costs for stone products, with quarry operators successfully passing incremental logistics costs through to construction buyers in most markets.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Infrastructure & Highway Construction', explanation: 'Crushed stone and dimension stone demand is primarily driven by road construction, bridge building, and utility installation programmes. Long-term government infrastructure funding commitments are the most important demand signal.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Residential & Commercial Construction', explanation: 'Stone products are used in foundation fill, drainage, and decorative applications for housing and commercial construction. Housing cycles create secondary demand variability around the infrastructure baseline.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Freight & Logistics Cost Sensitivity', explanation: 'Stone is a high-weight, low-value commodity where freight costs often exceed the ex-quarry price. Local supply proximity dominates delivered cost economics more than raw material pricing.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -2, mid: 0, high: 3, confidence: 0.77),
      ForecastHorizon(label: '3 Months', low: -3, mid: 1, high: 5, confidence: 0.63),
      ForecastHorizon(label: '6 Months', low: -4, mid: 1, high: 7, confidence: 0.49),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If infrastructure spending accelerates rapidly', trigger: 'Multiple large-scale infrastructure programmes break ground simultaneously in supply-constrained regions.', action: 'Secure quarry supply agreements before construction season. Stone supply constraints in busy construction regions can persist for an entire project cycle.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If construction slows broadly', trigger: 'Construction activity falls more than 10% year-on-year in key markets.', action: 'Stone prices are stable on the downside. Existing supply contracts typically include volume flexibility that can be exercised without significant premium.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current steady infrastructure demand', trigger: 'Road and infrastructure construction growing at trend.',  action: 'Local quarry relationships and logistics reliability matter more than price optimisation for most stone buyers. Focus on supply security over spot price arbitrage.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'talc': MaterialAnalysis(
    materialId: 'talc',
    currentPrice: 155,
    priceChange1W: 0.2,
    priceChange1M: 0.7,
    priceData1Y: _talcSeries,
    events: const [
      PriceEvent(weekIndex: 16, title: 'Automotive Polypropylene Demand', detail: 'Growing use of talc-filled polypropylene compounds in EV interior components and battery module housings drove higher talc procurement from automotive plastics compounders.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 34, title: 'Paper Industry Decline', detail: 'Continued structural decline in printing and writing paper production reduced talc demand from one of its historical core end-uses, partially offsetting gains from plastics applications.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Automotive Plastics Growth', explanation: 'Talc-filled polypropylene is a critical engineering material for automotive interior and exterior components. EV growth is increasing demand per vehicle as battery modules and structural components increasingly specify talc-PP composites.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Paper Industry Structural Decline', explanation: 'Talc has historically been a major filler and coating agent in paper production. The structural shift from print to digital media is gradually reducing this end-use, partially offsetting automotive and plastic demand growth.', direction: PriceDirection.down, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Imerys & Minerals Technologies Supply', explanation: 'A small number of producers (Imerys, Minerals Technologies, Mondo Minerals) control the majority of premium talc supply from key deposits in Finland, China, and the US. Concentrated supply supports disciplined pricing.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 5, confidence: 0.68),
      ForecastHorizon(label: '3 Months', low: -5, mid: 2, high: 9, confidence: 0.52),
      ForecastHorizon(label: '6 Months', low: -7, mid: 3, high: 13, confidence: 0.38),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If automotive talc-PP adoption accelerates', trigger: 'Major OEMs specify talc-filled PP for additional structural EV applications beyond current use cases.', action: 'Automotive compounders should lock in annual talc supply agreements. Premium grade supply from key Finnish and Chinese deposits is limited and contracted early by major automotive buyers.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If auto production falls sharply', trigger: 'Global vehicle production falls more than 10% year-on-year.', action: 'Talc demand from automotive plastics would contract. Negotiate volume flexibility into supply agreements. Paper industry decline limits upside from demand diversification.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current automotive-led demand growth', trigger: 'EV growth steady, paper decline continuing but gradual.',  action: 'Annual supply agreements with established producers are standard. Automotive buyers should specify approved talc grades carefully — particle size and purity requirements vary significantly by application.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  // ── Forestry ──────────────────────────────────────────────────────────────
  'bamboo': MaterialAnalysis(
    materialId: 'bamboo',
    currentPrice: 285,
    priceChange1W: 0.6,
    priceChange1M: 1.8,
    priceData1Y: _bambooSeries,
    events: const [
      PriceEvent(weekIndex: 14, title: 'Flooring Demand Boom', detail: 'Surging demand for bamboo flooring and engineered bamboo panels from North American and European renovation markets drove a significant uptick in processed bamboo exports from China and Vietnam.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 32, title: 'Carbon Credit Certification', detail: 'New bamboo plantation carbon credit certification standards attracted investment into managed bamboo forestry, signalling long-term supply growth but also validating bamboo\'s sustainability premium.', impact: PriceDirection.up),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'Green Building & Sustainability Demand', explanation: 'Bamboo is positioned as a sustainable alternative to timber and plastics. Growing green building certifications (LEED, BREEAM) and corporate ESG commitments are structurally increasing specification of bamboo in construction, interior design, and packaging.', direction: PriceDirection.up, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Chinese & Vietnamese Supply', explanation: 'China and Vietnam dominate global bamboo production and processing. Policy support for bamboo industrialisation in these countries can rapidly shift global supply availability and pricing.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Flooring & Panel Market Competition', explanation: 'Bamboo competes with hardwood flooring, luxury vinyl tile, and engineered wood panels. Price competitiveness with these substitutes sets a ceiling on how far bamboo prices can rise in volume markets.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -3, mid: 1, high: 6, confidence: 0.67),
      ForecastHorizon(label: '3 Months', low: -5, mid: 3, high: 11, confidence: 0.51),
      ForecastHorizon(label: '6 Months', low: -7, mid: 5, high: 17, confidence: 0.37),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If green building mandates tighten', trigger: 'Major markets update building codes to require minimum sustainable material content, with bamboo explicitly qualified.', action: 'Building product manufacturers should expand bamboo sourcing relationships. Certified sustainable bamboo (FSC, etc.) commands a premium that is increasingly demanded by green building specifiers.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If substitute materials become more competitive', trigger: 'Mass timber (CLT) or recycled plastic lumber prices fall significantly, reducing bamboo\'s relative price advantage.', action: 'Focus procurement on specialty applications where bamboo\'s unique properties (tensile strength, aesthetics) differentiate it from wood and plastic substitutes.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current sustainability-led demand growth', trigger: 'Green building demand growing steadily, Chinese and Vietnamese supply adequate.', action: 'Bamboo pricing is trending upward with sustainability demand. Early supplier relationships and certified sourcing programmes offer both supply security and ESG reporting value.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),

  'lumber': MaterialAnalysis(
    materialId: 'lumber',
    currentPrice: 390,
    priceChange1W: -1.4,
    priceChange1M: -4.2,
    priceData1Y: _lumberSeries,
    events: const [
      PriceEvent(weekIndex: 8, title: 'US Housing Surge', detail: 'A strong early spring construction season combined with low housing inventory drove lumber demand to levels that outpaced sawmill capacity, sending benchmark prices to their highest level since the 2021 peak.', impact: PriceDirection.up),
      PriceEvent(weekIndex: 18, title: 'Canadian Capacity Ramp', detail: 'Sawmill capacity additions in British Columbia and Alberta, combined with an easing of Canada-US softwood lumber duties for some producers, added supply and reversed the spring rally sharply.', impact: PriceDirection.down),
    ],
    drivers: const [
      Driver(id: 'd1', headline: 'US Housing Starts & Renovation', explanation: 'US housing construction is the single largest driver of lumber demand. New home construction requires 15,000–20,000 board feet per unit. Renovation and repair markets provide a more stable baseline. Interest rates directly influence both.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.strong),
      Driver(id: 'd2', headline: 'Canada-US Softwood Lumber Duties', explanation: 'Anti-dumping and countervailing duties on Canadian softwood lumber imports to the US periodically reshape the competitive landscape. Duty rate changes can quickly shift relative cost positions and market flows.', direction: PriceDirection.neutral, magnitude: DriverMagnitude.moderate),
      Driver(id: 'd3', headline: 'Mountain Pine Beetle & Supply Constraints', explanation: 'Decades of mountain pine beetle infestation have reduced British Columbia\'s mature timber supply. Sawmill capacity in the province is declining structurally, providing long-term support to North American lumber prices.', direction: PriceDirection.up, magnitude: DriverMagnitude.moderate),
    ],
    forecast: const [
      ForecastHorizon(label: '1 Month', low: -8, mid: -2, high: 5, confidence: 0.62),
      ForecastHorizon(label: '3 Months', low: -15, mid: 1, high: 14, confidence: 0.46),
      ForecastHorizon(label: '6 Months', low: -20, mid: 3, high: 22, confidence: 0.32),
    ],
    recommendations: const [
      Recommendation(scenario: RecommendationScenario.upside, scenarioLabel: 'If housing starts rebound sharply', trigger: 'US housing starts exceed 1.6 million annualised units and sawmill capacity cannot keep pace.', action: 'Homebuilders and framing contractors should hedge forward exposure during demand surges. Lumber can move 30–50% in weeks during supply-demand imbalances — forward contracts provide essential cost certainty.'),
      Recommendation(scenario: RecommendationScenario.downside, scenarioLabel: 'If interest rates remain elevated and housing slows', trigger: 'US 30-year mortgage rate stays above 7% and housing starts fall below 1.1 million annualised.', action: 'Avoid long-dated fixed-price lumber contracts. Spot purchasing in a demand downturn will offer better value as sawmills discount to maintain volume.'),
      Recommendation(scenario: RecommendationScenario.base, scenarioLabel: 'Under current moderate housing demand', trigger: 'Housing starts at 1.3–1.4 million, mortgage rates moderating gradually.', action: 'Lumber is one of the most volatile construction commodities. Ladder purchases over 30–60 day windows rather than committing large volumes at a single price point.'),
    ],
    dataTimestamp: 'Apr 12, 2026 · 09:00 UTC',
  ),
};

MaterialAnalysis? getAnalysis(String materialId) => kMockAnalysis[materialId];
