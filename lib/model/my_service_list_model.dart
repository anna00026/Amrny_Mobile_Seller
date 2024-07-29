// To parse this JSON data, do
//
//     final myServiceListModel = myServiceListModelFromJson(jsonString);

import 'dart:convert';

MyServiceListModel myServiceListModelFromJson(String str) =>
    MyServiceListModel.fromJson(json.decode(str));

String myServiceListModelToJson(MyServiceListModel data) =>
    json.encode(data.toJson());

class MyServiceListModel {
  MyServiceListModel({
    this.myServices,
    required this.serviceImage,
  });

  MyServices? myServices;
  List<ServiceImage> serviceImage;

  factory MyServiceListModel.fromJson(Map<String, dynamic> json) =>
      MyServiceListModel(
        myServices: MyServices.fromJson(json["my_services"]),
        serviceImage: List<ServiceImage>.from(json["service_image"]
            .map((x) => ServiceImage.fromJson(x is List ? {} : x))),
      );

  Map<String, dynamic> toJson() => {
        "my_services": myServices?.toJson(),
        "service_image":
            List<dynamic>.from(serviceImage.map((x) => x.toJson())),
      };
}

class MyServices {
  MyServices({
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
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory MyServices.fromJson(Map<String, dynamic> json) => MyServices(
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
    this.title,
    this.image,
    this.price,
    this.isServiceOnline,
    this.view,
    this.isServiceOn,
    this.reviewsCount,
    this.pendingOrderCount,
    this.completeOrderCount,
    this.cancelOrderCount,
    required this.reviewsForMobile,
  });

  int? id;
  String? title;
  String? image;
  var price;
  int? isServiceOnline;
  int? view;
  int? isServiceOn;
  int? reviewsCount;
  int? pendingOrderCount;
  int? completeOrderCount;
  int? cancelOrderCount;
  List<ReviewsForMobile> reviewsForMobile;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        price: json["price"],
        isServiceOnline: json["is_service_online"],
        view: json["view"],
        isServiceOn: json["is_service_on"],
        reviewsCount: json["reviews_count"],
        pendingOrderCount: json["pending_order_count"],
        completeOrderCount: json["complete_order_count"],
        cancelOrderCount: json["cancel_order_count"],
        reviewsForMobile: List<ReviewsForMobile>.from(json["reviews_for_mobile"]
            .map((x) => ReviewsForMobile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "price": price,
        "is_service_online": isServiceOnline,
        "view": view,
        "is_service_on": isServiceOn,
        "reviews_count": reviewsCount,
        "pending_order_count": pendingOrderCount,
        "complete_order_count": completeOrderCount,
        "cancel_order_count": cancelOrderCount,
        "reviews_for_mobile":
            List<dynamic>.from(reviewsForMobile.map((x) => x.toJson())),
      };
}

class ReviewsForMobile {
  ReviewsForMobile({
    this.id,
    this.serviceId,
    this.rating,
    this.message,
    this.buyerId,
  });

  int? id;
  int? serviceId;
  int? rating;
  String? message;
  int? buyerId;

  factory ReviewsForMobile.fromJson(Map<String, dynamic> json) =>
      ReviewsForMobile(
        id: json["id"],
        serviceId: json["service_id"],
        rating: json["rating"],
        message: json["message"],
        buyerId: json["buyer_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "rating": rating,
        "message": message,
        "buyer_id": buyerId,
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

class ServiceImage {
  ServiceImage({
    this.imageId,
    this.path,
    this.imgUrl,
    this.imgAlt,
  });

  int? imageId;
  String? path;
  String? imgUrl;
  dynamic imgAlt;

  factory ServiceImage.fromJson(Map<String, dynamic> json) => ServiceImage(
        imageId: json["image_id"],
        path: json["path"],
        imgUrl: json["img_url"],
        imgAlt: json["img_alt"],
      );

  Map<String, dynamic> toJson() => {
        "image_id": imageId,
        "path": path,
        "img_url": imgUrl,
        "img_alt": imgAlt,
      };
}
