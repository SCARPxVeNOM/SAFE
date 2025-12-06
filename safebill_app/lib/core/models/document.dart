import 'dart:convert';

import 'package:intl/intl.dart';

class WarrantyItem {
  const WarrantyItem({
    required this.itemId,
    required this.productName,
    required this.model,
    required this.invoiceNo,
    required this.purchaseDate,
    required this.purchasePrice,
    required this.warrantyMonths,
    required this.warrantyStart,
    required this.warrantyEnd,
    required this.serialNumber,
    required this.serviceCenters,
    required this.extendedWarrantyPurchased,
    required this.notes,
  });

  final String itemId;
  final String? productName;
  final String? model;
  final String? invoiceNo;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final int? warrantyMonths;
  final DateTime? warrantyStart;
  final DateTime? warrantyEnd;
  final String? serialNumber;
  final List<String> serviceCenters;
  final bool? extendedWarrantyPurchased;
  final String? notes;

  bool get isExpired =>
      warrantyEnd != null && warrantyEnd!.isBefore(DateTime.now());

  bool get isExpiringSoon {
    if (warrantyEnd == null) return false;
    final now = DateTime.now();
    return warrantyEnd!.isAfter(now) &&
        warrantyEnd!.isBefore(now.add(const Duration(days: 30)));
  }

  String get badgeLabel {
    if (isExpired) return 'Expired';
    if (isExpiringSoon) return 'Expiring';
    return 'Active';
  }

  String get formattedWarrantyEnd =>
      warrantyEnd != null ? DateFormat.yMMMd().format(warrantyEnd!) : 'Unknown';

  WarrantyItem copyWith({
    String? productName,
    String? model,
    String? invoiceNo,
    DateTime? purchaseDate,
    double? purchasePrice,
    int? warrantyMonths,
    DateTime? warrantyStart,
    DateTime? warrantyEnd,
    String? serialNumber,
    List<String>? serviceCenters,
    bool? extendedWarrantyPurchased,
    String? notes,
  }) {
    return WarrantyItem(
      itemId: itemId,
      productName: productName ?? this.productName,
      model: model ?? this.model,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      warrantyMonths: warrantyMonths ?? this.warrantyMonths,
      warrantyStart: warrantyStart ?? this.warrantyStart,
      warrantyEnd: warrantyEnd ?? this.warrantyEnd,
      serialNumber: serialNumber ?? this.serialNumber,
      serviceCenters: serviceCenters ?? this.serviceCenters,
      extendedWarrantyPurchased:
          extendedWarrantyPurchased ?? this.extendedWarrantyPurchased,
      notes: notes ?? this.notes,
    );
  }

  factory WarrantyItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? value) =>
        value != null ? DateTime.tryParse(value) : null;

    return WarrantyItem(
      itemId: json['itemId'] as String,
      productName: json['product_name'] as String?,
      model: json['model'] as String?,
      invoiceNo: json['invoice_no'] as String?,
      purchaseDate: parseDate(json['purchase_date'] as String?),
      purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
      warrantyMonths: json['warranty_months'] as int?,
      warrantyStart: parseDate(json['warranty_start'] as String?),
      warrantyEnd: parseDate(json['warranty_end'] as String?),
      serialNumber: json['serial_no'] as String?,
      serviceCenters: (json['service_centers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      extendedWarrantyPurchased:
          json['extended_warranty_purchased'] as bool?,
      notes: json['warranty_notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'product_name': productName,
        'model': model,
        'invoice_no': invoiceNo,
        'purchase_date': purchaseDate?.toIso8601String(),
        'purchase_price': purchasePrice,
        'warranty_months': warrantyMonths,
        'warranty_start': warrantyStart?.toIso8601String(),
        'warranty_end': warrantyEnd?.toIso8601String(),
        'serial_no': serialNumber,
        'service_centers': serviceCenters,
        'extended_warranty_purchased': extendedWarrantyPurchased,
        'warranty_notes': notes,
      };
}

class Document {
  const Document({
    required this.docId,
    required this.userId,
    required this.title,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    this.rawText,
    this.status,
    this.sellerName,
    this.ocrConfidence,
    this.isVerified = false,
  });

  final String docId;
  final String userId;
  final String title;
  final List<WarrantyItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? rawText;
  final String? status;
  final String? sellerName;
  final double? ocrConfidence;
  final bool isVerified;

  WarrantyItem get primaryItem => items.first;

  bool get hasExtendedWarranty =>
      items.any((item) => item.extendedWarrantyPurchased == true);

  Map<String, dynamic> toJson() => {
        'docId': docId,
        'userId': userId,
        'title': title,
        'rawText': rawText,
        'status': status,
        'seller_name': sellerName,
        'ocrConfidence': ocrConfidence,
        'isVerified': isVerified,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'items': items.map((item) => item.toJson()).toList(),
      };

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        docId: json['docId'] as String,
        userId: json['userId'] as String,
        title: json['title'] as String? ?? 'Invoice ${json['docId']}',
        rawText: json['rawText'] as String?,
        status: json['status'] as String?,
        sellerName: json['seller_name'] as String?,
        ocrConfidence: (json['ocrConfidence'] as num?)?.toDouble(),
        isVerified: json['isVerified'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        items: (json['items'] as List<dynamic>)
            .map((item) => WarrantyItem.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

  String toJsonString() => jsonEncode(toJson());

  static Document fromJsonString(String value) =>
      Document.fromJson(jsonDecode(value) as Map<String, dynamic>);

  Document copyWith({
    String? title,
    List<WarrantyItem>? items,
    String? status,
    String? sellerName,
    bool? isVerified,
  }) {
    return Document(
      docId: docId,
      userId: userId,
      title: title ?? this.title,
      rawText: rawText,
      status: status ?? this.status,
      sellerName: sellerName ?? this.sellerName,
      ocrConfidence: ocrConfidence,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      items: items ?? this.items,
    );
  }
}

