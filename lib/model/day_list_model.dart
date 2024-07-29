import 'dart:convert';

List<DayListModel> dayListModelFromJson(String str) => List<DayListModel>.from(
    json.decode(str).map((x) => DayListModel.fromJson(x)));

String dayListModelToJson(List<DayListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DayListModel {
  DayListModel({
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
  final List<Schedule>? schedules;

  factory DayListModel.fromJson(Map<String, dynamic> json) => DayListModel(
        id: json["id"],
        day: json["day"],
        status: json["status"],
        sellerId: json["seller_id"],
        totalDay: json["total_day"],
        schedules: json["schedules"] == null
            ? []
            : List<Schedule>.from(
                json["schedules"]!.map((x) => Schedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "status": status,
        "seller_id": sellerId,
        "total_day": totalDay,
        "schedules": schedules == null
            ? []
            : List<dynamic>.from(schedules!.map((x) => x.toJson())),
      };
}

class Schedule {
  Schedule({
    this.id,
    this.dayId,
    this.sellerId,
    this.schedule,
    this.status,
    this.allowMultipleSchedule,
  });

  final dynamic id;
  final dynamic dayId;
  final dynamic sellerId;
  final String? schedule;
  final dynamic status;
  final String? allowMultipleSchedule;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        dayId: json["day_id"],
        sellerId: json["seller_id"],
        schedule: json["schedule"],
        status: json["status"],
        allowMultipleSchedule: json["allow_multiple_schedule"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day_id": dayId,
        "seller_id": sellerId,
        "schedule": schedule,
        "status": status,
        "allow_multiple_schedule": allowMultipleSchedule,
      };
}
