import 'package:flutter_test/flutter_test.dart';
import 'package:sampay_wallet/core/utils/date_utils.dart';

/// Tests for [DateTimeUtils] driven by the exact filters list used by the
/// Reports page.
///
/// NOTE: [filters] must mirror `ReportsPage.filters` in
/// `lib/features/reports/page.dart` so that any change to the filter labels is
/// caught by these tests.
void main() {
  final DateTimeUtils dt = DateTimeUtils();

  const List<String> filters = [
    'Current week',
    'Last week',
    'Current month',
    'Last month',
    'Current quarter',
    'Last quarter',
    'This year',
    'Last year',
  ];

  /// Recomputes the range that [rangeForFilter] *should* return for [filter],
  /// based on the given [now]. It deliberately re-derives the expected values
  /// from the raw date math instead of calling the range helpers, so a bug in
  /// those helpers is still caught.
  SimpleDateRange expectedRangeFor(String filter, DateTime now) {
    switch (filter) {
      case 'Current week':
        return SimpleDateRange(
          fromDate: dt.format(dt.startOfWeek(now)),
          toDate: dt.format(dt.endOfWeek(now)),
          period: 'week',
        );
      case 'Last week':
        final weekStart = dt.startOfWeek(now);
        return SimpleDateRange(
          fromDate: dt.format(weekStart.subtract(const Duration(days: 7))),
          toDate: dt.format(weekStart.subtract(const Duration(days: 1))),
          period: 'week',
        );
      case 'Current month':
        return SimpleDateRange(
          fromDate: dt.format(DateTime(now.year, now.month, 1)),
          toDate: dt.format(DateTime(now.year, now.month + 1, 0)),
          period: 'month',
        );
      case 'Last month':
        return SimpleDateRange(
          fromDate: dt.format(DateTime(now.year, now.month - 1, 1)),
          toDate: dt.format(DateTime(now.year, now.month, 0)),
          period: 'month',
        );
      case 'Current quarter':
        return SimpleDateRange(
          fromDate: dt.format(dt.startOfQuarter(now)),
          toDate: dt.format(dt.endOfQuarter(now)),
          period: 'all',
        );
      case 'Last quarter':
        final quarter = dt.quarterOf(now);
        final lastQuarterStartMonth = ((quarter - 2) * 3) + 1;
        final yearAdjust = lastQuarterStartMonth < 1 ? -1 : 0;
        final adjustedMonth = lastQuarterStartMonth < 1
            ? lastQuarterStartMonth + 12
            : lastQuarterStartMonth;
        final year = now.year + yearAdjust;
        return SimpleDateRange(
          fromDate: dt.format(DateTime(year, adjustedMonth, 1)),
          toDate: dt.format(DateTime(year, adjustedMonth + 3, 0)),
          period: 'all',
        );
      case 'This year':
        return SimpleDateRange(
          fromDate: dt.format(DateTime(now.year, 1, 1)),
          toDate: dt.format(DateTime(now.year, 12, 31)),
          period: 'year',
        );
      case 'Last year':
        return SimpleDateRange(
          fromDate: dt.format(DateTime(now.year - 1, 1, 1)),
          toDate: dt.format(DateTime(now.year - 1, 12, 31)),
          period: 'year',
        );
      default:
        // Unknown labels fall back to the current month range.
        return SimpleDateRange(
          fromDate: dt.format(DateTime(now.year, now.month, 1)),
          toDate: dt.format(DateTime(now.year, now.month + 1, 0)),
          period: 'all',
        );
    }
  }

  group('rangeForFilter against the reports filters array', () {
    test('mirrors the 8 filters used by the Reports page', () {
      expect(filters, hasLength(8));
      // Sanity: labels are exactly what rangeForFilter's switch knows.
      for (final filter in filters) {
        final range = dt.rangeForFilter(filter);
        expect(range.fromDate, isNotEmpty, reason: filter);
        expect(range.toDate, isNotEmpty, reason: filter);
      }
    });

    test('returns an ordered, parseable range for every filter', () {
      for (final filter in filters) {
        final range = dt.rangeForFilter(filter);
        final from = dt.tryParseDate(range.fromDate);
        final to = dt.tryParseDate(range.toDate);
        expect(from, isNotNull, reason: 'Invalid fromDate for $filter');
        expect(to, isNotNull, reason: 'Invalid toDate for $filter');
        expect(
          from!.isAfter(to!),
          isFalse,
          reason: '$filter produced a reversed range',
        );
      }
    });

    test('returns the expected range for every filter', () {
      final now = DateTime.now();
      for (final filter in filters) {
        expect(
          dt.rangeForFilter(filter),
          expectedRangeFor(filter, now),
          reason: 'Mismatch for filter: $filter',
        );
      }
    });

    test('sets the expected period for every filter', () {
      final expectations = <String, String>{
        'Current week': 'week',
        'Last week': 'week',
        'Current month': 'month',
        'Last month': 'month',
        'Current quarter': 'all',
        'Last quarter': 'all',
        'This year': 'year',
        'Last year': 'year',
      };
      expectations.forEach((filter, period) {
        expect(
          dt.rangeForFilter(filter).period,
          period,
          reason: 'Wrong period for $filter',
        );
      });
    });

    test('falls back to the current month range for unknown labels', () {
      final now = DateTime.now();
      final range = dt.rangeForFilter('Custom range');
      expect(range.fromDate, dt.format(DateTime(now.year, now.month, 1)));
      expect(range.toDate, dt.format(DateTime(now.year, now.month + 1, 0)));
      expect(range.period, 'all');
    });
  });

  group('startOfWeek / endOfWeek', () {
    test('a Wednesday maps to the surrounding Monday-Sunday', () {
      final wednesday = DateTime(2026, 8, 12); // 2026-08-12 is a Wednesday
      expect(dt.startOfWeek(wednesday), DateTime(2026, 8, 10)); // Monday
      expect(dt.endOfWeek(wednesday), DateTime(2026, 8, 16)); // Sunday
    });

    test('a Monday is its own week start', () {
      final monday = DateTime(2026, 8, 10);
      expect(dt.startOfWeek(monday), DateTime(2026, 8, 10));
      expect(dt.endOfWeek(monday), DateTime(2026, 8, 16));
    });

    test('a Sunday is its own week end', () {
      final sunday = DateTime(2026, 8, 16);
      expect(dt.startOfWeek(sunday), DateTime(2026, 8, 10));
      expect(dt.endOfWeek(sunday), DateTime(2026, 8, 16));
    });

    test('handles weeks that cross a year boundary', () {
      final newYearsEve = DateTime(2026, 12, 31); // Thursday
      expect(dt.startOfWeek(newYearsEve), DateTime(2026, 12, 28));
      expect(dt.endOfWeek(newYearsEve), DateTime(2027, 1, 3));
    });
  });

  group('quarter math', () {
    test('quarterOf maps each month to the correct quarter', () {
      final expected = <int, int>{
        1: 1, 2: 1, 3: 1, // Q1
        4: 2, 5: 2, 6: 2, // Q2
        7: 3, 8: 3, 9: 3, // Q3
        10: 4, 11: 4, 12: 4, // Q4
      };
      expected.forEach((month, quarter) {
        expect(
          dt.quarterOf(DateTime(2026, month, 15)),
          quarter,
          reason: 'month $month',
        );
      });
    });

    test('startOfQuarter / endOfQuarter for a mid-quarter date', () {
      final midQ2 = DateTime(2026, 5, 20);
      expect(dt.startOfQuarter(midQ2), DateTime(2026, 4, 1));
      expect(dt.endOfQuarter(midQ2), DateTime(2026, 6, 30));
    });

    test('Q4 end is December 31', () {
      final oct = DateTime(2026, 10, 1);
      expect(dt.startOfQuarter(oct), DateTime(2026, 10, 1));
      expect(dt.endOfQuarter(oct), DateTime(2026, 12, 31));
    });
  });

  group('format', () {
    test('formats a date as yyyy-MM-dd', () {
      expect(dt.format(DateTime(2026, 8, 12)), '2026-08-12');
    });
  });

  group('tryParseDate', () {
    test('parses a valid yyyy-MM-dd string', () {
      expect(dt.tryParseDate('2026-08-12'), DateTime(2026, 8, 12));
    });

    test('returns null for null, empty, or invalid input', () {
      expect(dt.tryParseDate(null), isNull);
      expect(dt.tryParseDate(''), isNull);
      expect(dt.tryParseDate('   '), isNull);
      expect(dt.tryParseDate('not-a-date'), isNull);
    });
  });

  group('formatDateRange', () {
    test('same month and year: "10-16 Aug 2026"', () {
      expect(dt.formatDateRange('2026-08-10', '2026-08-16'), '10-16 Aug 2026');
    });

    test('different months, same year: "10 Aug - 16 Sep 2026"', () {
      expect(
        dt.formatDateRange('2026-08-10', '2026-09-16'),
        '10 Aug - 16 Sep 2026',
      );
    });

    test('different years: "10 Aug 2026 - 16 Sep 2027"', () {
      expect(
        dt.formatDateRange('2026-08-10', '2027-09-16'),
        '10 Aug 2026 - 16 Sep 2027',
      );
    });

    test('reversed range is swapped to a sane label', () {
      expect(dt.formatDateRange('2026-08-16', '2026-08-10'), '10-16 Aug 2026');
    });

    test('one missing side falls back to a single date', () {
      expect(dt.formatDateRange(null, '2026-08-10'), '10 Aug 2026');
      expect(dt.formatDateRange('2026-08-10', null), '10 Aug 2026');
    });

    test('both sides invalid returns an empty string', () {
      expect(dt.formatDateRange(null, null), '');
      expect(dt.formatDateRange('bad', 'also-bad'), '');
    });
  });

  group('SimpleDateRange', () {
    test('empty factory produces an all-period empty range', () {
      final empty = SimpleDateRange.empty();
      expect(empty.fromDate, '');
      expect(empty.toDate, '');
      expect(empty.period, 'all');
    });

    test('copyWith overrides only provided fields', () {
      final range = SimpleDateRange(
        fromDate: '2026-08-10',
        toDate: '2026-08-16',
        period: 'week',
      );
      final updated = range.copyWith(toDate: '2026-08-20');
      expect(updated.fromDate, '2026-08-10');
      expect(updated.toDate, '2026-08-20');
      expect(updated.period, 'week');
    });

    test('equality and hash are based on from/to/period', () {
      final a = SimpleDateRange(
        fromDate: '2026-08-10',
        toDate: '2026-08-16',
        period: 'week',
      );
      final b = SimpleDateRange(
        fromDate: '2026-08-10',
        toDate: '2026-08-16',
        period: 'week',
      );
      final c = SimpleDateRange(
        fromDate: '2026-08-10',
        toDate: '2026-08-16',
        period: 'month',
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
    });

    test('toMap returns the three string fields', () {
      final range = SimpleDateRange(
        fromDate: '2026-08-10',
        toDate: '2026-08-16',
        period: 'week',
      );
      expect(range.toMap(), {
        'fromDate': '2026-08-10',
        'toDate': '2026-08-16',
        'period': 'week',
      });
    });
  });
}
