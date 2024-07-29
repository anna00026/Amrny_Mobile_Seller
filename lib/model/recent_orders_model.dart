// To parse this JSON data, do
//
//     final recentOrdersModel = recentOrdersModelFromJson(jsonString);

import 'dart:convert';

RecentOrdersModel recentOrdersModelFromJson(String str) =>
    RecentOrdersModel.fromJson(json.decode(str));

String recentOrdersModelToJson(RecentOrdersModel data) =>
    json.encode(data.toJson());

class RecentOrdersModel {
  RecentOrdersModel({
    required this.recentOrders,
  });

  List<RecentOrder> recentOrders;

  factory RecentOrdersModel.fromJson(Map<String, dynamic> json) =>
      RecentOrdersModel(
        recentOrders: List<RecentOrder>.from(
            json["recent_orders"].map((x) => RecentOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "recent_orders":
            List<dynamic>.from(recentOrders.map((x) => x.toJson())),
      };
}

class RecentOrder {
  RecentOrder({
    this.id,
    this.name,
    this.status,
    this.email,
    this.total,
    this.orderStatus,
  });

  int? id;
  String? name;
  int? status;
  String? email;
  String? total;
  String? orderStatus;

  factory RecentOrder.fromJson(Map<String, dynamic> json) => RecentOrder(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        email: json["email"],
        total: json["total"],
        orderStatus: json["order_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "email": email,
        "total": total,
        "order_status": orderStatus,
      };
}
