// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.userDetails,
    this.profileImage,
  });

  UserDetails userDetails;
  ProfileImage? profileImage;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        userDetails: UserDetails.fromJson(json["user_details"]),
        profileImage: json["profile_image"] is List
            ? null
            : ProfileImage.fromJson(json["profile_image"]),
      );

  Map<String, dynamic> toJson() => {
        "user_details": userDetails.toJson(),
        "profile_image": profileImage?.toJson(),
      };
}

class ProfileImage {
  ProfileImage({
    this.imageId,
    this.path,
    this.imgUrl,
    this.imgAlt,
  });

  int? imageId;
  String? path;
  String? imgUrl;
  dynamic imgAlt;

  factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
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

class UserDetails {
  UserDetails(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.about,
      this.countryId,
      this.serviceCity,
      this.serviceArea,
      this.postCode,
      this.image,
      this.countryCode,
      required this.country,
      required this.city,
      required this.area,
      required this.sellerVerify});

  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? about;
  int? countryId;
  String? serviceCity;
  String? serviceArea;
  String? postCode;
  String? image;
  dynamic countryCode;
  Country? country;
  City? city;
  Area? area;
  SellerVerify? sellerVerify;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        about: json["about"],
        countryId: json["country_id"],
        serviceCity: json["service_city"],
        serviceArea: json["service_area"],
        postCode: json["post_code"],
        image: json["image"],
        countryCode: json["country_code"],
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
        city: json["city"] == null ? null : City.fromJson(json["city"]),
        area: json["area"] == null ? null : Area.fromJson(json["area"]),
        sellerVerify: SellerVerify?.fromJson(json["seller_verify"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "about": about,
        "country_id": countryId,
        "service_city": serviceCity,
        "service_area": serviceArea,
        "post_code": postCode,
        "image": image,
        "country_code": countryCode,
        "country": country?.toJson(),
        "city": city?.toJson(),
        "area": area?.toJson(),
        "seller_verify": sellerVerify?.toJson()
      };
}

class Area {
  Area({
    this.id,
    this.serviceArea,
    this.serviceCityId,
    this.countryId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? serviceArea;
  int? serviceCityId;
  int? countryId;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        id: json["id"],
        serviceArea: json["service_area"],
        serviceCityId: json["service_city_id"],
        countryId: json["country_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_area": serviceArea,
        "service_city_id": serviceCityId,
        "country_id": countryId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class SellerVerify {
  SellerVerify({
    this.id,
    this.sellerId,
    this.nationalId,
    this.address,
    this.status,
  });

  int? id;
  int? sellerId;
  var nationalId;
  var address;
  int? status;

  factory SellerVerify.fromJson(Map<String, dynamic>? json) => SellerVerify(
        id: json?["id"],
        sellerId: json?["seller_id"],
        nationalId: json?["national_id"],
        address: json?["address"],
        status: json?["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seller_id": sellerId,
        "national_id": nationalId,
        "address": address,
        "status": status,
      };
}

class City {
  City({
    this.id,
    this.serviceCity,
    this.countryId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? serviceCity;
  int? countryId;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        serviceCity: json["service_city"],
        countryId: json["country_id"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "service_city": serviceCity,
        "country_id": countryId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Country {
  Country({
    this.id,
    this.country,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? country;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        country: json["country"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
