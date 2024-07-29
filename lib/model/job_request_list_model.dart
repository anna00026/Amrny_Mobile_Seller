// To parse this JSON data, do
//
//     final jobRequestListModel = jobRequestListModelFromJson(jsonString);

import 'dart:convert';

JobRequestListModel jobRequestListModelFromJson(String str) =>
    JobRequestListModel.fromJson(json.decode(str));

String jobRequestListModelToJson(JobRequestListModel data) =>
    json.encode(data.toJson());

class JobRequestListModel {
  JobRequestListModel({
    required this.allJobRequests,
  });

  AllJobRequests allJobRequests;

  factory JobRequestListModel.fromJson(Map<String, dynamic> json) =>
      JobRequestListModel(
        allJobRequests: AllJobRequests.fromJson(json["all_job_requests"]),
      );

  Map<String, dynamic> toJson() => {
        "all_job_requests": allJobRequests.toJson(),
      };
}

class AllJobRequests {
  AllJobRequests({
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
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory AllJobRequests.fromJson(Map<String, dynamic> json) => AllJobRequests(
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
    this.sellerId,
    this.buyerId,
    this.jobPostId,
    this.isHired,
    this.expectedSalary,
    this.jobImage,
    this.coverLetter,
    this.createdAt,
    this.updatedAt,
    this.job,
  });

  int? id;
  int? sellerId;
  int? buyerId;
  int? jobPostId;
  int? isHired;
  int? expectedSalary;
  String? coverLetter;
  String? jobImage;
  DateTime? createdAt;
  DateTime? updatedAt;
  Job? job;

  factory Datum.fromJson(Map<String, dynamic>? json) => Datum(
        id: json?["id"],
        sellerId: json?["seller_id"],
        buyerId: json?["buyer_id"],
        jobPostId: json?["job_post_id"],
        isHired: json?["is_hired"],
        expectedSalary:
            num.tryParse((json?["expected_salary"]).toString())?.toInt(),
        jobImage: json?['job_image'],
        coverLetter: json?["cover_letter"],
        createdAt: DateTime.parse(json?["created_at"]),
        updatedAt: DateTime.parse(json?["updated_at"]),
        job: Job.fromJson(json?["job"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seller_id": sellerId,
        "buyer_id": buyerId,
        "job_post_id": jobPostId,
        "is_hired": isHired,
        "expected_salary": expectedSalary,
        "cover_letter": coverLetter,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "job": job?.toJson(),
      };
}

class Job {
  Job({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.buyerId,
    this.countryId,
    this.cityId,
    this.title,
    this.slug,
    this.description,
    this.image,
    this.status,
    this.isJobOn,
    this.isJobOnline,
    this.price,
    this.view,
    this.deadLine,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? categoryId;
  int? subcategoryId;
  int? buyerId;
  int? countryId;
  int? cityId;
  String? title;
  String? slug;
  String? description;
  String? image;
  int? status;
  int? isJobOn;
  int? isJobOnline;
  int? price;
  int? view;
  DateTime? deadLine;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Job.fromJson(Map<String, dynamic>? json) => Job(
        id: json?["id"],
        categoryId: json?["category_id"],
        subcategoryId: json?["subcategory_id"],
        buyerId: json?["buyer_id"],
        countryId: json?["country_id"],
        cityId: json?["city_id"],
        title: json?["title"],
        slug: json?["slug"],
        description: json?["description"],
        image: json?["image"],
        status: json?["status"],
        isJobOn: json?["is_job_on"],
        isJobOnline: json?["is_job_online"],
        price: json?["price"],
        view: json?["view"],
        deadLine: json?["dead_line"] != null
            ? DateTime.parse(json?["dead_line"])
            : null,
        createdAt: json?["created_at"] != null
            ? DateTime.parse(json?["created_at"])
            : null,
        updatedAt: json?["updated_at"] != null
            ? DateTime.parse(json?["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
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
