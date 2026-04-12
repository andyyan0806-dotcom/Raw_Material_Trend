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

final _coffeeSeries = _buildSeries(185, [
  {'week': 0, 'value': 185},
  {'week': 8, 'value': 220},
  {'week': 18, 'value': 260},
  {'week': 30, 'value': 310},
  {'week': 51, 'value': 295},
], 0.025);

// ── Full analysis map ───────────────────────────────────────────────────────

final Map<String, MaterialAnalysis> kMockAnalysis = {
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
};

MaterialAnalysis? getAnalysis(String materialId) => kMockAnalysis[materialId];
