// To parse this JSON data, do
//
//     final attributesModel = attributesModelFromJson(jsonString);

import 'dart:convert';

AttributesModel attributesModelFromJson(String str) =>
    AttributesModel.fromJson(json.decode(str));

String attributesModelToJson(AttributesModel data) =>
    json.encode(data.toJson());

class AttributesModel {
  AttributesModel({
    required this.includeServices,
    required this.additionalService,
    required this.serviceBenifit,
  });

  List<IncludeService> includeServices;
  List<AdditionalService> additionalService;
  List<ServiceBenifit> serviceBenifit;

  factory AttributesModel.fromJson(Map<String, dynamic> json) =>
      AttributesModel(
        includeServices: List<IncludeService>.from(
            json["include_services"].map((x) => IncludeService.fromJson(x))),
        additionalService: List<AdditionalService>.from(
            json["additional_service"]
                .map((x) => AdditionalService.fromJson(x))),
        serviceBenifit: List<ServiceBenifit>.from(
            json["service_benifit"].map((x) => ServiceBenifit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "include_services":
            List<dynamic>.from(includeServices.map((x) => x.toJson())),
        "additional_service":
            List<dynamic>.from(additionalService.map((x) => x.toJson())),
        "service_benifit":
            List<dynamic>.from(serviceBenifit.map((x) => x.toJson())),
      };
}

class AdditionalService {
  AdditionalService({
    this.id,
    this.serviceId,
    this.sellerId,
    this.additionalServiceTitle,
    this.additionalServicePrice,
    this.additionalServiceQuantity,
    this.additionalServiceImage,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? serviceId;
  int? sellerId;
  String? additionalServiceTitle;
  int? additionalServicePrice;
  int? additionalServiceQuantity;
  dynamic additionalServiceImage;
  dynamic createdAt;
  DateTime? updatedAt;

  factory AdditionalService.fromJson(Map<String, dynamic> json) =>
      AdditionalService(
        id: json["id"],
        serviceId: json["service_id"],
        sellerId: json["seller_id"],
        additionalServiceTitle: json["additional_service_title"],
        additionalServicePrice: json["additional_service_price"],
        additionalServiceQuantity: json["additional_service_quantity"],
        additionalServiceImage: json["additional_service_image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "seller_id": sellerId,
        "additional_service_title": additionalServiceTitle,
        "additional_service_price": additionalServicePrice,
        "additional_service_quantity": additionalServiceQuantity,
        "additional_service_image": additionalServiceImage,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class IncludeService {
  IncludeService({
    this.id,
    this.serviceId,
    this.sellerId,
    this.includeServiceTitle,
    this.includeServicePrice,
    this.includeServiceQuantity,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? serviceId;
  int? sellerId;
  String? includeServiceTitle;
  int? includeServicePrice;
  int? includeServiceQuantity;
  dynamic createdAt;
  DateTime? updatedAt;

  factory IncludeService.fromJson(Map<String, dynamic>? json) => IncludeService(
        id: json?["id"],
        serviceId: json?["service_id"],
        sellerId: json?["seller_id"],
        includeServiceTitle: json?["include_service_title"],
        includeServicePrice: json?["include_service_price"],
        includeServiceQuantity: json?["include_service_quantity"],
        createdAt: json?["created_at"],
        updatedAt: json?["updated_at"] != null
            ? DateTime.parse(json?["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "seller_id": sellerId,
        "include_service_title": includeServiceTitle,
        "include_service_price": includeServicePrice,
        "include_service_quantity": includeServiceQuantity,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class ServiceBenifit {
  ServiceBenifit({
    this.id,
    this.serviceId,
    this.sellerId,
    this.benifits,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? serviceId;
  int? sellerId;
  String? benifits;
  dynamic createdAt;
  DateTime? updatedAt;

  factory ServiceBenifit.fromJson(Map<String, dynamic> json) => ServiceBenifit(
        id: json["id"],
        serviceId: json["service_id"],
        sellerId: json["seller_id"],
        benifits: json["benifits"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_id": serviceId,
        "seller_id": sellerId,
        "benifits": benifits,
        "created_at": createdAt,
        "updated_at": updatedAt?.toIso8601String(),
      };
}
