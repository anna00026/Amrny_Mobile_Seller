// To parse this JSON data, do
//
//     final payoutDetailsModel = payoutDetailsModelFromJson(jsonString);

import 'dart:convert';

PayoutDetailsModel payoutDetailsModelFromJson(String str) =>
    PayoutDetailsModel.fromJson(json.decode(str));

String payoutDetailsModelToJson(PayoutDetailsModel data) =>
    json.encode(data.toJson());

class PayoutDetailsModel {
  PayoutDetailsModel({
    required this.payoutDetails,
  });

  PayoutDetails payoutDetails;

  factory PayoutDetailsModel.fromJson(Map<String, dynamic> json) =>
      PayoutDetailsModel(
        payoutDetails: PayoutDetails.fromJson(json["payout_details"]),
      );

  Map<String, dynamic> toJson() => {
        "payout_details": payoutDetails.toJson(),
      };
}

class PayoutDetails {
  PayoutDetails({
    this.id,
    this.sellerId,
    this.amount,
    this.paymentGateway,
    this.sellerNote,
    this.adminNote,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? sellerId;
  var amount;
  String? paymentGateway;
  String? sellerNote;
  dynamic adminNote;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PayoutDetails.fromJson(Map<String, dynamic> json) => PayoutDetails(
        id: json["id"],
        sellerId: json["seller_id"],
        amount: json["amount"],
        paymentGateway: json["payment_gateway"],
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
        "seller_note": sellerNote,
        "admin_note": adminNote,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
