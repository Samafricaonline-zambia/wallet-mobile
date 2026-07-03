import 'package:sampay_wallet/core/models/chart_data_model.dart';
import 'package:sampay_wallet/core/models/wallet_transactions_model.dart';

class ChartUtils {
  double getTotalExpenditure(List<TransactionsModel> transactions) {
    final expenseTransactions = transactions.where((transaction) {
      return transaction.transactionType?.toLowerCase() == 'expense' ||
          transaction.transactionType?.toLowerCase() == 'debit';
    }).toList();

    // Check if list is not empty
    if (expenseTransactions.isEmpty) return 0.0;

    // Use reduce to sum amounts
    final total = expenseTransactions.reduce((sum, transaction) {
      final currentAmount =
          double.tryParse(transaction.amount ?? '0')?.abs() ?? 0.0;
      final sumAmount = double.tryParse(sum.amount ?? '0')?.abs() ?? 0.0;

      // Create a new transaction with accumulated sum
      return TransactionsModel(
        amount: (sumAmount + currentAmount).toString(),
        // Copy other fields if needed, but they're not used
      );
    });

    return double.tryParse(total.amount ?? '0') ?? 0.0;
  }

  List<ChartDataModel> getSpendingDistribution(
    List<TransactionsModel> transactions,
  ) {
    // Filter only expense transactions (assuming negative amounts or specific type)
    // Adjust the condition based on your transaction type logic
    final expenseTransactions = transactions.where((transaction) {
      // Option 2: If you have transaction type field
      return transaction.transactionType?.toLowerCase() == 'expense' ||
          transaction.transactionType?.toLowerCase() == 'debit';

      // Option 3: If you want all transactions
      // return true;
    }).toList();

    // Group by vendor and sum amounts
    final Map<String, double> vendorTotals = {};

    for (final transaction in expenseTransactions) {
      final vendor = transaction.vendor ?? 'Other';
      final amount = double.tryParse(transaction.amount ?? '0')?.abs() ?? 0;

      vendorTotals[vendor] = (vendorTotals[vendor] ?? 0) + amount;
    }

    // Convert to ChartDataModel list
    final chartData = vendorTotals.entries.map((entry) {
      return ChartDataModel(label: entry.key, value: entry.value);
    }).toList();

    // Optional: Sort by value descending
    chartData.sort((a, b) => b.value.compareTo(a.value));

    return chartData;
  }

  List<ChartDataModel> getVendorWiseMonthlySpending(
    List<TransactionsModel> transactions, {
    DateTime? month,
  }) {
    // Filter by month if provided
    List<TransactionsModel> filteredTransactions = transactions;

    if (month != null) {
      filteredTransactions = transactions.where((transaction) {
        DateTime? transactionDate;

        // Try to parse timestamp or date
        if (transaction.timestamp != null &&
            transaction.timestamp!.isNotEmpty) {
          try {
            String dateString = transaction.timestamp!.replaceFirst(' ', 'T');
            transactionDate = DateTime.parse(dateString);
          } catch (e) {
            return false;
          }
        } else if (transaction.date != null && transaction.date!.isNotEmpty) {
          try {
            transactionDate = DateTime.parse(transaction.date!);
          } catch (e) {
            return false;
          }
        }

        if (transactionDate == null) return false;

        return transactionDate.year == month.year &&
            transactionDate.month == month.month;
      }).toList();
    }

    // Filter only expense transactions
    final expenseTransactions = filteredTransactions.where((transaction) {
      return transaction.transactionType?.toLowerCase() == 'expense' ||
          transaction.transactionType?.toLowerCase() == 'debit';
    }).toList();

    // Group by vendor and sum amounts
    final Map<String, double> vendorTotals = {};

    for (final transaction in expenseTransactions) {
      final vendor = transaction.vendor ?? 'Other';
      final amount = double.tryParse(transaction.amount ?? '0')?.abs() ?? 0;

      vendorTotals[vendor] = (vendorTotals[vendor] ?? 0) + amount;
    }

    // Convert to ChartDataModel list
    final chartData = vendorTotals.entries.map((entry) {
      return ChartDataModel(label: entry.key, value: entry.value);
    }).toList();

    // Sort by value descending
    chartData.sort((a, b) => b.value.compareTo(a.value));

    return chartData;
  }

  List<ChartDataModel> getDateWiseMonthlySpending(
    List<TransactionsModel> transactions, {
    DateTime? month,
  }) {
    // Use current month if month is not provided
    final targetMonth = month ?? DateTime.now();

    // Filter by month
    final filteredTransactions = transactions.where((transaction) {
      DateTime? transactionDate;

      // Try to parse timestamp or date
      if (transaction.timestamp != null && transaction.timestamp!.isNotEmpty) {
        try {
          String dateString = transaction.timestamp!.replaceFirst(' ', 'T');
          transactionDate = DateTime.parse(dateString);
        } catch (e) {
          return false;
        }
      } else if (transaction.date != null && transaction.date!.isNotEmpty) {
        try {
          transactionDate = DateTime.parse(transaction.date!);
        } catch (e) {
          return false;
        }
      }

      if (transactionDate == null) return false;

      return transactionDate.year == targetMonth.year &&
          transactionDate.month == targetMonth.month;
    }).toList();

    // Filter only expense transactions
    final expenseTransactions = filteredTransactions.where((transaction) {
      return transaction.transactionType?.toLowerCase() == 'expense' ||
          transaction.transactionType?.toLowerCase() == 'debit';
    }).toList();

    // Group by date and sum amounts
    final Map<int, double> dateTotals = {};

    for (final transaction in expenseTransactions) {
      // Parse the transaction date
      DateTime? transactionDate;

      if (transaction.timestamp != null && transaction.timestamp!.isNotEmpty) {
        try {
          String dateString = transaction.timestamp!.replaceFirst(' ', 'T');
          transactionDate = DateTime.parse(dateString);
        } catch (e) {
          continue;
        }
      } else if (transaction.date != null && transaction.date!.isNotEmpty) {
        try {
          transactionDate = DateTime.parse(transaction.date!);
        } catch (e) {
          continue;
        }
      }

      if (transactionDate == null) continue;

      // Get just the day of month as integer
      final dayOfMonth = transactionDate.day;
      final amount = double.tryParse(transaction.amount ?? '0')?.abs() ?? 0;

      dateTotals[dayOfMonth] = (dateTotals[dayOfMonth] ?? 0) + amount;
    }

    // Convert to ChartDataModel list with day as string label
    final chartData = dateTotals.entries.map((entry) {
      return ChartDataModel(
        label: entry.key.toString(), // "1", "2", "3", etc.
        value: entry.value,
      );
    }).toList();

    // Sort by day (ascending)
    chartData.sort((a, b) {
      final aDay = int.tryParse(a.label) ?? 0;
      final bDay = int.tryParse(b.label) ?? 0;
      return aDay.compareTo(bDay);
    });

    return chartData;
  }

  List<ChartDataModel> getCreditVsDebit(
    List<TransactionsModel> transactions, {
    DateTime? month,
  }) {
    // Helper to parse date
    DateTime? parseDate(TransactionsModel transaction) {
      final dateStr = transaction.timestamp ?? transaction.date;
      if (dateStr == null || dateStr.isEmpty) return null;

      try {
        return DateTime.parse(dateStr.replaceFirst(' ', 'T'));
      } catch (e) {
        return null;
      }
    }

    // Apply month filter if provided
    final filteredTransactions = month == null
        ? transactions
        : transactions.where((t) {
            final date = parseDate(t);
            return date != null &&
                date.year == month.year &&
                date.month == month.month;
          }).toList();

    double creditTotal = 0.0; // Income
    double debitTotal = 0.0; // Expense

    for (final transaction in filteredTransactions) {
      final amount = double.tryParse(transaction.amount ?? '0') ?? 0;
      final transactionType = transaction.transactionType?.toLowerCase() ?? '';

      // Check if it's credit (income) or debit (expense)
      if (transactionType == 'income' || transactionType == 'credit') {
        creditTotal += amount.abs();
      } else {
        debitTotal += amount.abs();
      }
    }

    return [
      ChartDataModel(label: 'Income', value: creditTotal),
      ChartDataModel(label: 'Expense', value: debitTotal),
    ];
  }
}
