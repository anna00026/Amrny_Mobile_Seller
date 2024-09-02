// To parse this JSON data, do
//
//     final allOrdersModel = allOrdersModelFromJson(jsonString);

import 'dart:convert';

import 'package:qixer_seller/helper/extension/string_extension.dart';

AllOrdersModel allOrdersModelFromJson(String str) =>
    AllOrdersModel.fromJson(json.decode(str));

String allOrdersModelToJson(AllOrdersModel data) => json.encode(data.toJson());

class AllOrdersModel {
  AllOrdersModel({
    required this.myOrders,
    this.userId,
  });

  MyOrders myOrders;
  int? userId;

  factory AllOrdersModel.fromJson(Map<String, dynamic> json) => AllOrdersModel(
        myOrders: MyOrders.fromJson(json["my_orders"]),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "my_orders": myOrders.toJson(),
        "user_id": userId,
      };
}

class MyOrders {
  MyOrders({
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
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  factory MyOrders.fromJson(Map<String, dynamic> json) => MyOrders(
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
    this.serviceId,
    this.sellerId,
    this.buyerId,
    this.name,
    this.email,
    this.phone,
    this.postCode,
    this.address,
    this.city,
    this.area,
    this.country,
    this.date,
    this.schedule,
    this.packageFee,
    this.extraService,
    this.subTotal,
    this.tax,
    this.total,
    this.couponCode,
    this.couponType,
    this.couponAmount,
    this.commissionType,
    this.commissionCharge,
    this.commissionAmount,
    this.paymentGateway,
    this.paymentStatus,
    this.status,
    this.isOrderOnline,
    this.orderCompleteRequest,
    this.cancelOrderMoneyReturn,
    this.transactionId,
    this.orderNote,
    this.createdAt,
    this.updatedAt,
    this.manualPaymentImage,
  });

  int? id;
  int? serviceId;
  int? sellerId;
  int? buyerId;
  String? name;
  String? email;
  String? phone;
  String? postCode;
  String? address;
  int? city;
  int? area;
  int? country;
  DateTime? date;
  String? schedule;
  double? packageFee;
  int? extraService;
  double? subTotal;
  double? tax;
  double? total;
  String? couponCode;
  String? couponType;
  double? couponAmount;
  String? commissionType;
  int? commissionCharge;
  var commissionAmount;
  String? paymentGateway;
  String? paymentStatus;
  int? status;
  int? isOrderOnline;
  int? orderCompleteRequest;
  int? cancelOrderMoneyReturn;
  dynamic transactionId;
  String? orderNote;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? manualPaymentImage;

  factory Datum.fromJson(Map<String, dynamic>? json) => Datum(
        id: json?["id"],
        serviceId: json?["service_id"],
        sellerId: json?["seller_id"],
        buyerId: json?["buyer_id"],
        name: json?["name"],
        email: json?["email"],
        phone: json?["phone"],
        postCode: json?["post_code"],
        address: json?["address"],
        city: json?["city"],
        area: json?["area"],
        country: json?["country"],
        date: json?["date"] == null ? null : DateTime.parse(json?["date"]),
        schedule: json?["schedule"],
        packageFee: json?["package_fee"].toDouble(),
        extraService: json?["extra_service"],
        subTotal: json?["sub_total"].toDouble(),
        tax: json?["tax"].toDouble(),
        total: json?["total"].toDouble(),
        couponCode: json?["coupon_code"],
        couponType: json?["coupon_type"],
        couponAmount: (num.tryParse(json?["coupon_amount"].toString() ?? '0') ?? 0).toDouble(),
        commissionType: json?["commission_type"],
        commissionCharge: json?["commission_charge"],
        commissionAmount: json?["commission_amount"]?.toDouble(),
        paymentGateway: json?["payment_gateway"],
        paymentStatus: json?["payment_status"],
        status: json?["status"],
        isOrderOnline: json?["is_order_online"],
        orderCompleteRequest: json?["order_complete_request"],
        cancelOrderMoneyReturn: json?["cancel_order_money_return"],
        transactionId: json?["transaction_id"],
        orderNote: json?["order_note"],
        createdAt: DateTime.parse(json?["created_at"]),
        updatedAt: DateTime.parse(json?["updated_at"]),
        manualPaymentImage: json?["manual_payment_image"],
      );

  Map<String?, dynamic>? toJson() => {
        "id": id,
        "service_id": serviceId,
        "seller_id": sellerId,
        "buyer_id": buyerId,
        "name": name,
        "email": email,
        "phone": phone,
        "post_code": postCode,
        "address": address,
        "city": city,
        "area": area,
        "country": country,
        "date": date,
        "schedule": schedule,
        "package_fee": packageFee,
        "extra_service": extraService,
        "sub_total": subTotal,
        "tax": tax,
        "total": total,
        "coupon_code": couponCode,
        "coupon_type": couponType,
        "coupon_amount": couponAmount,
        "commission_type": commissionType,
        "commission_charge": commissionCharge,
        "commission_amount": commissionAmount,
        "payment_gateway": paymentGateway,
        "payment_status": paymentStatus,
        "status": status,
        "is_order_online": isOrderOnline,
        "order_complete_request": orderCompleteRequest,
        "cancel_order_money_return": cancelOrderMoneyReturn,
        "transaction_id": transactionId,
        "order_note": orderNote,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "manual_payment_image": manualPaymentImage,
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
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
