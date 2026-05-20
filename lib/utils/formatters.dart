import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Small helpers used across the UI for consistent formatting.
class Formatters {
  static final _date = DateFormat('MMM d, yyyy');
  static final _shortDate = DateFormat('MMM d');
  static final _currency = NumberFormat.currency(symbol: '₱', decimalDigits: 2);
  static final _compact = NumberFormat.compactCurrency(symbol: '₱');

  static String date(DateTime d) => _date.format(d);
  static String shortDate(DateTime d) => _shortDate.format(d);
  static String time(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $p';
  }

  static String currency(double v) => _currency.format(v);
  static String compactCurrency(double v) => _compact.format(v);
  static String percent(double v) => '${(v * 100).toStringAsFixed(1)}%';
}
