// To parse this JSON data, do
//
//     final scheduleListModel = scheduleListModelFromJson(jsonString);

import 'dart:convert';

ScheduleListModel scheduleListModelFromJson(String str) =>
    ScheduleListModel.fromJson(json.decode(str));

class ScheduleListModel {
  ScheduleListModel({
    this.schedule,
    this.days,
  });

  final Schedule? schedule;
  final List<Day>? days;

  factory ScheduleListModel.fromJson(Map<String, dynamic> json) =>
      ScheduleListModel(
        schedule: json["schedule"] == null
            ? null
            : Schedule.fromJson(json["schedule"]),
        days: json["days"] == null
            ? []
            : List<Day>.from(json["days"]!.map((x) => Day.fromJson(x))),
      );
}

class Datum {
  Datum({
    this.id,
    this.dayId,
    this.sellerId,
    this.schedule,
    this.status,
    this.allowMultipleSchedule,
    this.days,
  });

  final dynamic id;
  final dynamic dayId;
  final dynamic sellerId;
  final String? schedule;
  final dynamic status;

  final String? allowMultipleSchedule;
  final Day? days;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        dayId: json["day_id"],
        sellerId: json["seller_id"],
        schedule: json["schedule"],
        status: json["status"],
        allowMultipleSchedule: json["allow_multiple_schedule"],
        days: json["days"] == null ? null : Day.fromJson(json["days"]),
      );
}

class Day {
  Day({
    this.id,
    this.day,
    this.status,
    this.sellerId,
    this.totalDay,
    this.schedules,
  });

  final dynamic id;
  final String? day;
  final dynamic status;
  final dynamic sellerId;
  final dynamic totalDay;

  final List<Datum>? schedules;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        id: json["id"],
        day: json["day"],
        status: json["status"],
        sellerId: json["seller_id"],
        totalDay: json["total_day"],
        schedules: json["schedules"] == null
            ? []
            : List<Datum>.from(
                json["schedules"]!.map((x) => Datum.fromJson(x))),
      );
}

class Schedule {
  Schedule({
    this.currentPage,
    this.data,
    this.nextPageUrl,
  });

  final int? currentPage;
  final List<Datum>? data;
  dynamic nextPageUrl;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );
}
