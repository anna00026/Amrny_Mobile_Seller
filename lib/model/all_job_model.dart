// To parse this JSON data, do
//
//     final allJobModel = allJobModelFromJson(jsonString);

import 'dart:convert';

AllJobModel allJobModelFromJson(String str) =>
    AllJobModel.fromJson(json.decode(str));

String allJobModelToJson(AllJobModel data) => json.encode(data.toJson());

class AllJobModel {
  AllJobModel({
    this.allJobs,
  });

  final AllJobs? allJobs;

  factory AllJobModel.fromJson(Map<String, dynamic> json) => AllJobModel(
        allJobs: json["all_jobs"] == null
            ? null
            : AllJobs.fromJson(json["all_jobs"]),
      );

  Map<String, dynamic> toJson() => {
        "all_jobs": allJobs?.toJson(),
      };
}

class AllJobs {
  AllJobs({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  final int? currentPage;
  final List<Datum>? data;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final dynamic nextPageUrl;
  final String? path;
  final int? perPage;
  final dynamic prevPageUrl;
  final int? to;
  final int? total;

  factory AllJobs.fromJson(Map<String, dynamic> json) => AllJobs(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null
            ? []
            : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
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
    this.categoryId,
    this.subcategoryId,
    this.childCategoryId,
    this.buyerId,
    this.countryId,
    this.cityId,
    this.title,
    this.slug,
    this.description,
    this.image,
    this.imageUrl,
    this.status,
    this.isJobOn,
    this.isJobOnline,
    this.isHired,
    this.buttonText,
    this.price,
    this.view,
    this.deadLine,
    this.createdAt,
    this.updatedAt,
  });

  final dynamic id;
  final dynamic categoryId;
  final dynamic subcategoryId;
  final dynamic childCategoryId;
  final dynamic buyerId;
  final dynamic countryId;
  final dynamic cityId;
  final String? title;
  final String? slug;
  final String? description;
  final String? image;
  final String? imageUrl;
  final dynamic status;
  final dynamic isJobOn;
  final dynamic isJobOnline;
  final bool? isHired;
  final String? buttonText;
  final double? price;
  final dynamic view;
  final DateTime? deadLine;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        childCategoryId: json["child_category_id"],
        buyerId: json["buyer_id"],
        countryId: json["country_id"],
        cityId: json["city_id"],
        title: json["title"],
        slug: json["slug"],
        description: json["description"],
        image: json["image"],
        imageUrl: json['image_url'],
        status: json["status"],
        isJobOn: json["is_job_on"],
        isJobOnline: json["is_job_online"],
        isHired: json['is_applied']['is_hired'],
        buttonText: json['is_applied']['message'],
        price: json["price"] is String
            ? num.parse(json["price"]).toDouble()
            : json["price"]?.toDouble(),
        view: json["view"],
        deadLine: json["dead_line"] == null
            ? null
            : DateTime.parse(json["dead_line"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "child_category_id": childCategoryId,
        "buyer_id": buyerId,
        "country_id": countryId,
        "city_id": cityId,
        "title": title,
        "slug": slug,
        "description": description,
        "image": image,
        "status": status,
        "is_job_on": isJobOn,
        "is_job_online": isJobOnline,
        "price": price,
        "view": view,
        "dead_line": deadLine?.toIso8601String(),
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

  final String? url;
  final String? label;
  final bool? active;

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
