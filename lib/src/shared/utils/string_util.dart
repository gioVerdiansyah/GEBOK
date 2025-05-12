import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String shortInitial(
    {required String text, required String target, required String abbreviation, bool toLowerCase = false}) {
  if (toLowerCase) {
    text = text.toLowerCase();
    target = target.toLowerCase();
  }

  final nameParts = text.split(' ');
  final formattedName = nameParts.map((part) {
    if (part.toLowerCase() == target.toLowerCase()) {
      return abbreviation;
    }
    return part;
  }).join(' ');

  return formattedName;
}

String truncatedText(text, {int limit = 100}) => text.length > limit ? text.substring(0, limit) + '...' : text;

String getColorHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

String? handleEmptyStr(String? primary, String? secondary, [List<String?>? additionalValues]) {
  final params = [primary, secondary, ...?additionalValues];

  return params.firstWhere((value) => value != null && value.isNotEmpty && value != "null", orElse: () => null);
}

dynamic findNameById(List<Map<String, dynamic>> data, String id, {String field = 'name'}) {
  try {
    final item = data.firstWhere((element) => element['id'] == id, orElse: () => {});
    return item.isNotEmpty ? item[field] : null;
  } catch (e) {
    return null;
  }
}

String formatCurrency(String value) {
  try {
    final number = int.tryParse(value.replaceAll('.', '').replaceAll(',', '')) ?? 0.0;
    final formatter = NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);
    return formatter.format(number);
  } catch (_) {
    return value;
  }
}

String formatNumToIdr(dynamic number, {bool withSymbol = false}) {
  if (number == null) return '${withSymbol ? 'Rp. ' : ''}0';

  String numberString = number.toString();

  numberString = numberString.replaceAll(RegExp(r'[^0-9]'), '');

  int parsedNumber = int.tryParse(numberString) ?? 0;

  if (parsedNumber == 0) return '${withSymbol ? 'Rp. ' : ''}0';

  final formatter = NumberFormat('###,###', 'id_ID');
  String formattedNumber = formatter.format(parsedNumber);

  return "${withSymbol ? 'Rp. ' : ''}${formattedNumber.replaceAll(',', '.')}";
}