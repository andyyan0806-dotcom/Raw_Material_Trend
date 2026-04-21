class PricePoint {
  final String label;
  final double value;
  const PricePoint({required this.label, required this.value});
}

class PriceEvent {
  final int weekIndex;
  final String title;
  final String detail;
  final PriceDirection impact;
  const PriceEvent({
    required this.weekIndex,
    required this.title,
    required this.detail,
    required this.impact,
  });
}

class Driver {
  final String id;
  final String headline;
  final String explanation;
  final PriceDirection direction;
  final DriverMagnitude magnitude;
  const Driver({
    required this.id,
    required this.headline,
    required this.explanation,
    required this.direction,
    required this.magnitude,
  });
}

class ForecastHorizon {
  final String label;
  final double low;
  final double mid;
  final double high;
  final double confidence; // 0.0 – 1.0
  const ForecastHorizon({
    required this.label,
    required this.low,
    required this.mid,
    required this.high,
    required this.confidence,
  });
}

class Recommendation {
  final RecommendationScenario scenario;
  final String scenarioLabel;
  final String trigger;
  final String action;
  const Recommendation({
    required this.scenario,
    required this.scenarioLabel,
    required this.trigger,
    required this.action,
  });
}

class MaterialAnalysis {
  final String materialId;
  final double currentPrice;
  final double priceChange1W;
  final double priceChange1M;
  final List<PricePoint> priceData1Y;
  final List<PriceEvent> events;
  final List<Driver> drivers;
  final List<ForecastHorizon> forecast;
  final List<Recommendation> recommendations;
  final String dataTimestamp;

  const MaterialAnalysis({
    required this.materialId,
    required this.currentPrice,
    required this.priceChange1W,
    required this.priceChange1M,
    required this.priceData1Y,
    required this.events,
    required this.drivers,
    required this.forecast,
    required this.recommendations,
    required this.dataTimestamp,
  });

  List<PricePoint> dataForRange(TimeRange range) {
    final counts = {
      TimeRange.oneMonth: 4,
      TimeRange.threeMonths: 13,
      TimeRange.sixMonths: 26,
      TimeRange.oneYear: 52,
    };
    final n = counts[range]!;
    if (priceData1Y.length <= n) return priceData1Y;
    return priceData1Y.sublist(priceData1Y.length - n);
  }
}

enum PriceDirection { up, down, neutral }

enum DriverMagnitude { strong, moderate, mild }

enum RecommendationScenario { upside, downside, base }

enum TimeRange { oneMonth, threeMonths, sixMonths, oneYear }

extension TimeRangeLabel on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.oneMonth:
        return '1M';
      case TimeRange.threeMonths:
        return '3M';
      case TimeRange.sixMonths:
        return '6M';
      case TimeRange.oneYear:
        return '1Y';
    }
  }
}
