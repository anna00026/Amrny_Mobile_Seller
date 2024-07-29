// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  DashboardModel({
    this.pendingOrder,
    this.completedOrder,
    this.totalWithdrawnMoney,
    this.remainingBalance,
    this.sellerId,
  });

  int? pendingOrder;
  int? completedOrder;
  var totalWithdrawnMoney;
  var remainingBalance;
  int? sellerId;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        pendingOrder: json["pending_order"],
        completedOrder: json["completed_order"],
        totalWithdrawnMoney: json["total_withdrawn_money"],
        remainingBalance: json["remaining_balance"],
        sellerId: json["seller_id"],
      );

  Map<String, dynamic> toJson() => {
        "pending_order": pendingOrder,
        "completed_order": completedOrder,
        "total_withdrawn_money": totalWithdrawnMoney,
        "remaining_balance": remainingBalance,
        "seller_id": sellerId,
      };
}
