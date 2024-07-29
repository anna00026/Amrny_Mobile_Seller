// To parse this JSON data, do
//
//     final payoutHistoryModel = payoutHistoryModelFromJson(jsonString);

import 'dart:convert';

PayoutHistoryModel payoutHistoryModelFromJson(String str) =>
    PayoutHistoryModel.fromJson(json.decode(str));

String payoutHistoryModelToJson(PayoutHistoryModel data) =>
    json.encode(data.toJson());

class PayoutHistoryModel {
  PayoutHistoryModel({
    required this.paymentHistory,
  });

  PaymentHistory paymentHistory;

  factory PayoutHistoryModel.fromJson(Map<String, dynamic> json) =>
      PayoutHistoryModel(
        paymentHistory: PaymentHistory.fromJson(json["payment_history"]),
      );

  Map<String, dynamic> toJson() => {
        "payment_history": paymentHistory.toJson(),
      };
}

class PaymentHistory {
  PaymentHistory({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<Datum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory PaymentHistory.fromJson(Map<String, dynamic> json) => PaymentHistory(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    this.id,
    this.sellerId,
    this.amount,
    this.paymentGateway,
    this.paymentReceipt,
    this.sellerNote,
    this.adminNote,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? sellerId;
  int? amount;
  String? paymentGateway;
  String? paymentReceipt;
  String? sellerNote;
  dynamic adminNote;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        sellerId: json["seller_id"],
        amount: json["amount"],
        paymentGateway: json["payment_gateway"],
        paymentReceipt: json["payment_receipt"],
        sellerNote: json["seller_note"],
        adminNote: json["admin_note"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seller_id": sellerId,
        "amount": amount,
        "payment_gateway": paymentGateway,
        "payment_receipt": paymentReceipt,
        "seller_note": sellerNote,
        "admin_note": adminNote,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] ?? null,
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url ?? null,
        "label": label,
        "active": active,
      };
}
