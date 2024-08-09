import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/helper/extension/string_extension.dart';
import 'package:qixer_seller/model/all_job_model.dart';
import 'package:qixer_seller/model/employee_model.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeesService with ChangeNotifier {
  List<EmployeeModel> allEmployeesList = [];
  bool isLoading = true;

  late int totalPages;

  int currentPage = 1;
  EmployeeModel? employeeData;
  var employeeImage;

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  fetchEmployees(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      allEmployeesList = [];
      notifyListeners();

      setCurrentPage(1);
    } else {}

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        "Authorization": "Bearer $token",
      };

      setLoadingStatus(true);

      var response = await http.post(
          Uri.parse("$baseApi/seller/employees/list?page=$currentPage"),
          headers: header);

      setLoadingStatus(false);
      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 201 &&
          decodedData['employees_list']['data'].isNotEmpty) {
        var data = EmployeeListModel.fromJson(decodedData['employees_list']);

        setTotalPage(data.lastPage ?? 1);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          // setServiceList(data.allJobs?.data??[], decodedData['image_url'], false);
          allEmployeesList = data.data ?? [];
        } else {
          print('add new data');
          data.data?.forEach((element) {
            allEmployeesList.add(element);
          });
          //else add new data
          // setServiceList(data.allJobs?.data??[], decodedData['image_url'], true);
        }

        notifyListeners();
        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        print('error fetching new jobs ${response.body}');
        return false;
      }
    }
  }

  fetchEmployeeData(int employeeId) async {
    var connection = await checkConnection();
    if (connection) {
      //internet connection is on
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      setLoadingStatus(true);

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json"
        "Authorization": "Bearer $token",
      };
      Map<String, dynamic> data = {
        'id': employeeId,
      };
      var response = await http.post(Uri.parse('$baseApi/seller/employee'),
          body: data, headers: header);

      if (response.statusCode == 201) {
        // var data = Employee.fromJson(jsonDecode(response.body));
        // profileDetails = data.userDetails;
        // profileImage = data.profileImage;

        notifyListeners();
      } else {
        // print('profile fetch error ' + response.body);
        // profileDetails == 'error';
        // setLoadingFalse();
        // OthersHelper().showToast('Something went wrong', Colors.black);
        notifyListeners();
      }
    }
  }

  final ImagePicker _picker = ImagePicker();
  Future pickImage() async {
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      return imageFile;
    } else {
      return null;
    }
  }

  Future<bool> saveEmployee(EmployeeModel? employee, String password,
      String? imagePath, context) async {
    setLoadingStatus(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var dio = Dio();
    // dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers["Authorization"] = "Bearer $token";

    try {
      FormData formData;
      Map<String, dynamic> userData = employee!.userDetails!.toJson();
      userData.remove('id');
      Map<String, dynamic> postData = {
          ...employee.toJson(),
          ...userData,
          'password': password,
        };
      if (imagePath != null) {
        formData = FormData.fromMap({
          ...postData,
          'file': await MultipartFile.fromFile(imagePath,
              filename:
                  'profileImage${employee.userDetails?.name} ${employee.userDetails?.address}$imagePath.jpg'),
        });
      } else {
        formData = FormData.fromMap(postData);
      }
      var response = await dio.post(
        '$baseApi/seller/employees/save',
        data: formData,
        options: Options(
          validateStatus: (status) {
            return true;
          },
        ),
      );

      if (response.statusCode == 201) {
        setLoadingStatus(false);
        OthersHelper().showToast('Saved employee data successfully', Colors.black);

        Navigator.pop(context);
        Provider.of<EmployeesService>(context, listen: false)
            .fetchEmployees(context, isrefresh: true);
        return true;
      } else {
        setLoadingStatus(false);
        print(response.data);
        OthersHelper().showToast('Something went wrong', Colors.black);
        return false;
      }
    } catch (e) {
      setLoadingStatus(false);
      print(e);
      OthersHelper().showToast('Something went wrong', Colors.black);
      return false;
    }
  }
}
