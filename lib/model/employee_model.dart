import 'dart:convert';
import 'package:qixer_seller/model/all_job_model.dart';
import 'package:qixer_seller/model/profile_model.dart';

EmployeeModel employeeModelFromJson(String str) =>
    EmployeeModel.fromJson(json.decode(str));

String profileModelToJson(EmployeeModel data) => json.encode(data.toJson());

class EmployeeListModel {
  EmployeeListModel({
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
  final List<EmployeeModel>? data;
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

  factory EmployeeListModel.fromJson(Map<String, dynamic> json) => EmployeeListModel(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<EmployeeModel>.from(json["data"]!.map((x) => EmployeeModel.fromJson(x))),
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

class EmployeeModel {
  EmployeeModel({
    this.userDetails,
    this.id,
    this.profileImage,
    this.joiningDate,
    this.workType,
    this.salary,
    this.bankName,
    this.bankBranch,
    this.bankAccount,
    this.bankHolder,
    this.city
  });
  
  int? id;
  DateTime? joiningDate;
  String? workType;
  String? salary;
  String? bankName;
  String? bankBranch;
  String? bankAccount;
  String? bankHolder;
  int?    city;  
  UserDetails? userDetails;
  ProfileImage? profileImage;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        userDetails: UserDetails.fromJson(json["user"]),
        profileImage: json["profile_image"] is List || json['profile_image'] == null
            ? null
            : ProfileImage.fromJson(json["profile_image"]),
            id: json['id'],
            joiningDate: DateTime.tryParse(json['joining_date'] ?? ''),
            workType: json['work_type'],
            salary: json['salary'],
            bankName: json['bank_name'],
            bankBranch: json['bank_branch'],
            bankAccount: json['bank_account'],
            bankHolder: json['bank_holder'],
            city: json['city'],
      );

  Map<String, dynamic> toJson() => {
        "user": userDetails?.toJson(),
        "profile_image": profileImage?.toJson(),
        "id": id,
        "joining_date": joiningDate?.toIso8601String(),
        "work_type": workType,
        "salary": salary,
        "bank_name": bankName,
        "bank_branch": bankBranch,
        "bank_account": bankAccount,
        "bank_holder": bankHolder,
        "city": city,
      };
}