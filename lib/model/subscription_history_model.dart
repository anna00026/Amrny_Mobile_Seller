// To parse this JSON data, do
//
//     final subscriptionHistoryModel = subscriptionHistoryModelFromJson(jsonString);

import 'dart:convert';

SubscriptionHistoryModel subscriptionHistoryModelFromJson(String str) =>
    SubscriptionHistoryModel.fromJson(json.decode(str));

String subscriptionHistoryModelToJson(SubscriptionHistoryModel data) =>
    json.encode(data.toJson());

class SubscriptionHistoryModel {
  SubscriptionHistoryModel({
    required this.subscriptionHistory,
  });

  List<SubscriptionHistory> subscriptionHistory;

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionHistoryModel(
        subscriptionHistory: List<SubscriptionHistory>.from(
            json["subscription_history"]
                .map((x) => SubscriptionHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subscription_history":
            List<dynamic>.from(subscriptionHistory.map((x) => x.toJson())),
      };
}

class SubscriptionHistory {
  SubscriptionHistory({
    this.id,
    this.subscriptionId,
    this.sellerId,
    this.type,
    this.connect,
    this.price,
    this.couponCode,
    this.couponType,
    this.couponAmount,
    this.priceWithDiscount,
    this.expireDate,
    this.paymentGateway,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? subscriptionId;
  int? sellerId;
  String? type;
  int? connect;
  int? price;
  String? couponCode;
  String? couponType;
  String? couponAmount;
  int? priceWithDiscount;
  DateTime? expireDate;
  String? paymentGateway;
  String? paymentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SubscriptionHistory.fromJson(Map<String, dynamic> json) =>
      SubscriptionHistory(
        id: json["id"],
        subscriptionId: json["subscription_id"],
        sellerId: json["seller_id"],
        type: json["type"],
        connect: json["connect"],
        price: json["price"],
        couponCode: json["coupon_code"],
        couponType: json["coupon_type"],
        couponAmount: json["coupon_amount"],
        priceWithDiscount: json["price_with_discount"],
        expireDate: DateTime.parse(json["expire_date"]),
        paymentGateway: json["payment_gateway"],
        paymentStatus: json["payment_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscription_id": subscriptionId,
        "seller_id": sellerId,
        "type": type,
        "connect": connect,
        "price": price,
        "coupon_code": couponCode,
        "coupon_type": couponType,
        "coupon_amount": couponAmount,
        "price_with_discount": priceWithDiscount,
        "expire_date": expireDate?.toIso8601String(),
        "payment_gateway": paymentGateway,
        "payment_status": paymentStatus,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
