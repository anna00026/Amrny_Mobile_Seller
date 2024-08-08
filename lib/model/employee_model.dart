import 'dart:convert';

import 'package:qixer_seller/model/profile_model.dart';

EmployeeModel employeeModelFromJson(String str) =>
    EmployeeModel.fromJson(json.decode(str));

String profileModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeModel {
  EmployeeModel({
    required this.userDetails,
    this.profileImage,
  });

  UserDetails userDetails;
  ProfileImage? profileImage;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
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