// To parse this JSON data, do
//
//     final chartModel = chartModelFromJson(jsonString);

import 'dart:convert';

ChartModel chartModelFromJson(String str) =>
    ChartModel.fromJson(json.decode(str));

String chartModelToJson(ChartModel data) => json.encode(data.toJson());

class ChartModel {
  ChartModel({
    required this.chartData,
  });

  List<ChartDatum> chartData;

  factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
        chartData: List<ChartDatum>.from(
            json["chart_data"].map((x) => ChartDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "chart_data": List<dynamic>.from(chartData.map((x) => x.toJson())),
      };
}

class ChartDatum {
  ChartDatum({
    this.monthName,
    this.totalOrder,
  });

  String? monthName;
  int? totalOrder;

  factory ChartDatum.fromJson(Map<String, dynamic> json) => ChartDatum(
        monthName: json["monthName"],
        totalOrder: json["totalOrder"],
      );

  Map<String, dynamic> toJson() => {
        "monthName": monthName,
        "totalOrder": totalOrder,
      };
}
