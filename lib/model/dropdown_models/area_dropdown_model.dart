// To parse this JSON data, do
//
//     final areaDropdownModel = areaDropdownModelFromJson(jsondynamic);

import 'dart:convert';

AreaDropdownModel areaDropdownModelFromJson(dynamic str) =>
    AreaDropdownModel.fromJson(json.decode(str));

dynamic areaDropdownModelToJson(AreaDropdownModel data) =>
    json.encode(data.toJson());

class AreaDropdownModel {
  AreaDropdownModel({
    required this.serviceAreas,
  });

  ServiceAreas serviceAreas;

  factory AreaDropdownModel.fromJson(Map<dynamic, dynamic> json) =>
      AreaDropdownModel(
        serviceAreas: ServiceAreas.fromJson(json["service_areas"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "service_areas": serviceAreas.toJson(),
      };
}

class ServiceAreas {
  ServiceAreas({
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

  dynamic currentPage;
  List<Datum> data;
  dynamic firstPageUrl;
  dynamic from;
  dynamic lastPage;
  dynamic lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  dynamic path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory ServiceAreas.fromJson(Map<dynamic, dynamic> json) => ServiceAreas(
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

  Map<dynamic, dynamic> toJson() => {
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
    this.serviceArea,
  });

  dynamic id;
  dynamic serviceArea;

  factory Datum.fromJson(Map<dynamic, dynamic> json) => Datum(
        id: json["id"],
        serviceArea: json["service_area"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "service_area": serviceArea,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  dynamic url;
  dynamic label;
  bool? active;

  factory Link.fromJson(Map<dynamic, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<dynamic, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
