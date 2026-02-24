import 'dart:convert';

/// Represents a single payment in split payment scenario
class PaymentDetail {
  final String method; // "VOUCHER", "CASH", "QRIS", etc.
  final int amount; // Amount in Rupiah

  const PaymentDetail({
    required this.method,
    required this.amount,
  });

  /// Convert to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'amount': amount,
    };
  }

  /// Create from JSON Map
  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      method: json['method'] as String,
      amount: json['amount'] as int,
    );
  }

  @override
  String toString() => 'PaymentDetail(method: $method, amount: $amount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentDetail &&
        other.method == method &&
        other.amount == amount;
  }

  @override
  int get hashCode => method.hashCode ^ amount.hashCode;
}

/// Helper class for encoding/decoding split payments
class PaymentDetailsHelper {
  /// Encode list of PaymentDetail to JSON string
  static String? encode(List<PaymentDetail>? payments) {
    if (payments == null || payments.isEmpty) return null;
    final jsonList = payments.map((p) => p.toJson()).toList();
    return jsonEncode(jsonList);
  }

  /// Decode JSON string to list of PaymentDetail
  static List<PaymentDetail>? decode(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => PaymentDetail.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error decoding payment details: $e');
      return null;
    }
  }
}
