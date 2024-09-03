// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:amrny_seller/model/my_service_list_model.dart';
import 'package:amrny_seller/model/service_details_model.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServicesService with ChangeNotifier {
  //

  List myServiceListMap = [];

  late int totalPages;

  int currentPage = 1;
  var alreadyAddedtoFav = false;
  List averageRateList = [];
  List imageList = [];
  List ratingCountList = [];
  bool hasError = false;

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  setActiveStatus(bool status, int index) {
    myServiceListMap[index]['isServiceOn'] = status;
    notifyListeners();
  }

  setDefault() {
    myServiceListMap = [];
    averageRateList = [];
    imageList = [];
    ratingCountList = [];

    currentPage = 1;
    notifyListeners();
  }

  fetchMyServiceList(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      myServiceListMap = [];
      currentPage = 1;
      notifyListeners();

      setCurrentPage(currentPage);
    } else {}

    var connection = await checkConnection();
    if (!connection) return;
    //if connection is ok

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await http.get(
        Uri.parse("$baseApi/seller/service/my-services?page=$currentPage"),
        headers: header);

    print(response.body);
    print("$baseApi/seller/service/my-services?page=$currentPage");

    if (response.statusCode == 201 &&
        jsonDecode(response.body)['my_services']['data'].isNotEmpty) {
      var data = MyServiceListModel.fromJson(jsonDecode(response.body));

      setTotalPage(data.myServices!.lastPage);

      for (int i = 0; i < data.myServices!.data.length; i++) {
        String? serviceImage;

        if (data.serviceImage.length > i) {
          serviceImage = data.serviceImage[i].imgUrl;
        } else {
          serviceImage = null;
        }

        int totalRating = 0;
        List reviews = data.myServices!.data[i].reviewsForMobile;
        for (int j = 0; j < reviews.length; j++) {
          totalRating = (totalRating + reviews[j].rating!).toInt();
        }
        double averageRate = 0;

        if (reviews.isNotEmpty) {
          averageRate = (totalRating / reviews.length);
        }
        averageRateList.add(averageRate);
        imageList.add(serviceImage);
        ratingCountList.add(reviews.length);
      }

      if (isrefresh) {
        print('refresh true');
        //if refreshed, then remove all service from list and insert new data
        setServiceList(
          data.myServices!.data,
          false,
        );
      } else {
        print('add new data');

        //else add new data
        setServiceList(
          data.myServices!.data,
          true,
        );
      }

      currentPage++;
      setCurrentPage(currentPage);
      return true;
    } else {
      if (myServiceListMap.isEmpty) {
        hasError = true;
        notifyListeners();
      }
      notifyListeners();
      return false;
    }
  }

  //=============>
  setServiceList(
    List<Datum> data,
    bool addnewData,
  ) {
    if (addnewData == false) {
      //make the list empty first so that existing data doesn't stay
      myServiceListMap = [];
      notifyListeners();
    }

    for (int i = 0; i < data.length; i++) {
      myServiceListMap.add({
        'serviceId': data[i].id,
        'title': data[i].title,
        'price': data[i].price,
        'queued': data[i].pendingOrderCount,
        'completed': data[i].completeOrderCount,
        'cancelled': data[i].cancelOrderCount,
        'isOnline':
            data[i].isServiceOnline.toString() == "1" ? 'Online' : 'Offline',
        'viewCount': data[i].view,
        'isServiceOn': data[i].isServiceOn.toString() == "1" ? true : false,
      });
    }
    notifyListeners();
  }

  //service on off
  //==============>

  serviceOnOff(BuildContext context, {required serviceId}) async {
    //check internet connection
    var connection = await checkConnection();
    if (!connection) return;
    //internet connection is on

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await http.post(
      Uri.parse('$baseApi/seller/service/on-off/$serviceId'),
      headers: header,
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
    } else {}
  }

  // Delete service
  //===============>

  bool deleteLoading = false;

  setDeleteLoadingStatus(bool status) {
    deleteLoading = status;
    notifyListeners();
  }

  deleteService(BuildContext context, {required serviceId}) async {
    //check internet connection
    var connection = await checkConnection();
    if (!connection) return;
    //internet connection is on

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      "Accept": "application/json",
      // "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    setDeleteLoadingStatus(true);

    var response = await http.post(
      Uri.parse(
          '$baseApi/seller/service/delete/service-with-all-attributes/$serviceId'),
      headers: header,
    );

    setDeleteLoadingStatus(false);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201) {
      //Reload service list
      Provider.of<MyServicesService>(context, listen: false).setDefault();
      Provider.of<MyServicesService>(context, listen: false)
          .fetchMyServiceList(context);

      OthersHelper()
          .showToast('Service deleted. Refreshing list.....', Colors.black);

      Navigator.pop(context);
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }
  }

  //service details
  // ==============>

  var serviceDetails;

  bool detailsLoading = false;

  setDetailsLoadingStatus(bool status) {
    detailsLoading = status;
    notifyListeners();
  }

  Future<bool> fetchServiceDetails({required serviceId}) async {
    var connection = await checkConnection();
    if (!connection) return false;

    setDetailsLoadingStatus(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      // "Content-Type": "application/json"
    };

    var response = await http
        .get(Uri.parse('$baseApi/service-details/$serviceId'), headers: header);

    setDetailsLoadingStatus(false);

    print(response.body);
    print('service id $serviceId');
    print('$baseApi/service-details/$serviceId');
    print(response.body);

    if (response.statusCode == 201) {
      // serviceAllDetails =
      //     ServiceDetailsModel.fromJson(jsonDecode(response.body));
      var data = ServiceDetailsModel.fromJson(jsonDecode(response.body));

      serviceDetails = data;

      notifyListeners();
      return true;
    } else {
      OthersHelper().showToast('Error filling out fields', Colors.black);
      notifyListeners();

      return false;
    }
  }
}
