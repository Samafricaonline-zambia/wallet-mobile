import 'package:intl/intl.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';

/// Represents an inclusive date range with formatted `fromDate` and `toDate`
class SimpleDateRange {
  final String? fromDate;
  final String? toDate;

  /// Time period the range represents: `week`, `month`, `year`, or `all`
  final String? period;

  const SimpleDateRange({this.fromDate, this.toDate, this.period});

  factory SimpleDateRange.empty() => SimpleDateRange();

  SimpleDateRange copyWith({String? fromDate, String? toDate, String? period}) {
    return SimpleDateRange(
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      period: period ?? this.period,
    );
  }

  Map<String, String> toMap() => {
    'fromDate': AppUtils().valueOrDefault(fromDate),
    'toDate': AppUtils().valueOrDefault(toDate),
    'period': AppUtils().valueOrDefault(period),
  };

  @override
  String toString() =>
      'SimpleDateRange(fromDate: $fromDate, toDate: $toDate, period: $period)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SimpleDateRange &&
        other.fromDate == fromDate &&
        other.toDate == toDate &&
        other.period == period;
  }

  @override
  int get hashCode => fromDate.hashCode ^ toDate.hashCode ^ period.hashCode;
}

class DateTimeUtils {
  static const String dateFormat = 'yyyy-MM-dd';

  /// Formats a [DateTime] using the standard `yyyy-MM-dd` format
  String format(DateTime date) => DateFormat(dateFormat).format(date);

  /// Returns the first day (Monday) of the week containing [date]
  DateTime startOfWeek(DateTime date) {
    final day = date.weekday; // Monday = 1, Sunday = 7
    return DateTime(date.year, date.month, date.day - (day - 1));
  }

  /// Returns the last day (Sunday) of the week containing [date]
  DateTime endOfWeek(DateTime date) {
    final day = date.weekday; // Monday = 1, Sunday = 7
    return DateTime(date.year, date.month, date.day + (7 - day));
  }

  /// Returns the quarter (1-4) of the year for [date]
  int quarterOf(DateTime date) => ((date.month - 1) ~/ 3) + 1;

  /// Returns the first day of the quarter containing [date]
  DateTime startOfQuarter(DateTime date) {
    final quarter = quarterOf(date);
    return DateTime(date.year, ((quarter - 1) * 3) + 1, 1);
  }

  /// Returns the last day of the quarter containing [date]
  DateTime endOfQuarter(DateTime date) {
    final quarter = quarterOf(date);
    return DateTime(date.year, quarter * 3 + 1, 0);
  }

  /// Date range for the current week (Monday -> Sunday)
  SimpleDateRange currentWeekRange() {
    final now = DateTime.now();
    return SimpleDateRange(
      fromDate: format(startOfWeek(now)),
      toDate: format(endOfWeek(now)),
    );
  }

  /// Date range for the previous week (Monday -> Sunday)
  SimpleDateRange lastWeekRange() {
    final now = DateTime.now();
    final thisWeekStart = startOfWeek(now);
    return SimpleDateRange(
      fromDate: format(thisWeekStart.subtract(const Duration(days: 7))),
      toDate: format(thisWeekStart.subtract(const Duration(days: 1))),
    );
  }

  /// Date range for the current month (1st -> last day of month)
  SimpleDateRange currentMonthRange() {
    final now = DateTime.now();
    return SimpleDateRange(
      fromDate: format(DateTime(now.year, now.month, 1)),
      toDate: format(DateTime(now.year, now.month + 1, 0)),
    );
  }

  /// Date range for the previous month (1st -> last day of month)
  SimpleDateRange lastMonthRange() {
    final now = DateTime.now();
    return SimpleDateRange(
      fromDate: format(DateTime(now.year, now.month - 1, 1)),
      toDate: format(DateTime(now.year, now.month, 0)),
    );
  }

  /// Date range for the current quarter (first -> last day of quarter)
  SimpleDateRange currentQuarterRange() {
    final now = DateTime.now();
    return SimpleDateRange(
      fromDate: format(startOfQuarter(now)),
      toDate: format(endOfQuarter(now)),
    );
  }

  /// Date range for the previous quarter (first -> last day of quarter)
  SimpleDateRange lastQuarterRange() {
    final now = DateTime.now();
    final lastQuarterStartMonth = ((quarterOf(now) - 2) * 3) + 1;
    final yearAdjust = lastQuarterStartMonth < 1 ? -1 : 0;
    final adjustedMonth = lastQuarterStartMonth < 1
        ? lastQuarterStartMonth + 12
        : lastQuarterStartMonth;
    final year = now.year + yearAdjust;
    return SimpleDateRange(
      fromDate: format(DateTime(year, adjustedMonth, 1)),
      toDate: format(DateTime(year, adjustedMonth + 3, 0)),
    );
  }

  /// Date range for the current year (Jan 1 -> Dec 31)
  SimpleDateRange thisYearRange() {
    final now = DateTime.now();
    return SimpleDateRange(
      fromDate: format(DateTime(now.year, 1, 1)),
      toDate: format(DateTime(now.year, 12, 31)),
    );
  }

  /// Date range for the previous year (Jan 1 -> Dec 31)
  SimpleDateRange lastYearRange() {
    final now = DateTime.now();
    return SimpleDateRange(
      fromDate: format(DateTime(now.year - 1, 1, 1)),
      toDate: format(DateTime(now.year - 1, 12, 31)),
    );
  }

  /// Returns the date range for a given filter label
  ///
  /// Supported labels: "Current week", "Last week", "Current month",
  /// "Last month", "Current quarter", "Last quarter", "This year", "Last year".
  /// Falls back to the current month range for unknown labels.
  ///
  /// The `period` on the returned range is populated from the filter:
  /// - Contains "week" -> `week`
  /// - Contains "month" -> `month`
  /// - Contains "year" -> `year`
  /// - Anything else (quarter/custom) -> `all`
  SimpleDateRange rangeForFilter(String filter) {
    final String normalized = filter.toLowerCase();
    final String period = normalized.contains('week')
        ? 'week'
        : normalized.contains('month')
        ? 'month'
        : normalized.contains('year')
        ? 'year'
        : normalized.contains('quarter')
        ? 'month'
        : 'week';

    switch (filter) {
      case "Current week":
        return currentWeekRange().copyWith(period: period);
      case "Last week":
        return lastWeekRange().copyWith(period: period);
      case "Current month":
        return currentMonthRange().copyWith(period: period);
      case "Last month":
        return lastMonthRange().copyWith(period: period);
      case "Current quarter":
        return currentQuarterRange().copyWith(period: period);
      case "Last quarter":
        return lastQuarterRange().copyWith(period: period);
      case "This year":
        return thisYearRange().copyWith(period: period);
      case "Last year":
        return lastYearRange().copyWith(period: period);
      default:
        return currentMonthRange().copyWith(period: period);
    }
  }

  /// Tries to parse a `yyyy-MM-dd` string into a [DateTime].
  ///
  /// Returns `null` if [value] is null, empty, or not in a parseable format,
  /// so callers never crash on bad input.
  DateTime? tryParseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value.trim());
  }

  /// Formats a date range (from/to as `yyyy-MM-dd` strings) into a human
  /// readable label.
  ///
  /// Example: `2026-08-10` -> `2026-08-16` returns `10-16 Aug 2026`.
  /// - Same month/year: `10-16 Aug 2026`
  /// - Different months, same year: `10 Aug - 16 Sep 2026`
  /// - Different years: `10 Aug 2026 - 16 Sep 2027`
  ///
  /// Fail-safe: if either date is missing or invalid it falls back to showing
  /// only the valid side, and returns an empty string if both are invalid.
  /// If [fromDate] is after [toDate] the two are swapped for a sane label.
  String formatDateRange(String? fromDate, String? toDate) {
    final DateTime? from = tryParseDate(fromDate);
    final DateTime? to = tryParseDate(toDate);

    // Both invalid -> nothing to show.
    if (from == null && to == null) return '';

    // Only one side is valid -> show just that side.
    if (from == null) return _formatSingleDate(to!);
    if (to == null) return _formatSingleDate(from);

    // Guard against a reversed range.
    final DateTime start = from.isAfter(to) ? to : from;
    final DateTime end = from.isAfter(to) ? from : to;

    if (start.year == end.year && start.month == end.month) {
      // Same month and year: 10-16 Aug 2026
      return '${start.day}-${end.day} ${DateFormat('MMM').format(end)} '
          '${end.year}';
    }

    if (start.year == end.year) {
      // Different months, same year: 10 Aug - 16 Sep 2026
      return '${start.day} ${DateFormat('MMM').format(start)} - '
          '${end.day} ${DateFormat('MMM').format(end)} ${end.year}';
    }

    // Different years: 10 Aug 2026 - 16 Sep 2027
    return '${start.day} ${DateFormat('MMM').format(start)} ${start.year} - '
        '${end.day} ${DateFormat('MMM').format(end)} ${end.year}';
  }

  String _formatSingleDate(DateTime date) =>
      '${date.day} ${DateFormat('MMM').format(date)} ${date.year}';
}
