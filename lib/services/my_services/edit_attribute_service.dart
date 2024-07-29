import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qixer_seller/helper/extension/string_extension.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/services/my_services/attribute_service.dart';
import 'package:qixer_seller/services/my_services/my_services_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAttributeService with ChangeNotifier {
  List includedList = [];
  num? onlineServicePrice;
  num? onlineServiceRevisions;
  num? onlineServiceDuration;

  bool isOnline = false;

  setIsOnline(bool value) {
    isOnline = value;
  }

  setOnlineServiceRevisions(value) {
    if (value == onlineServiceRevisions) {
      return;
    }
    onlineServiceRevisions = value;
    notifyListeners();
  }

  setOnlineServiceDuration(value) {
    if (value == onlineServiceDuration) {
      return;
    }
    onlineServiceDuration = value;
    notifyListeners();
  }

  setOnlineServicePrice(value) {
    if (value == onlineServicePrice) {
      return;
    }
    onlineServicePrice = value;
    notifyListeners();
  }

  addIncludedList(String title, String price) {
    includedList.add({'title': title, 'price': price, 'qty': '1'});
    notifyListeners();
  }

  removeIncludedList(int index) {
    includedList.removeAt(index);
    notifyListeners();
  }

  // additional
  //===========>

  List additionalList = [];

  addAdditional(
      {required title,
      required price,
      required qty,
      required BuildContext context}) {
    additionalList.add({'title': title, 'price': price, 'qty': qty});
    notifyListeners();
  }

  removeAdditional(int index) {
    additionalList.removeAt(index);
    notifyListeners();
  }

  //benefits of package
  //===========>

  List benefitsList = [];

  addBenefits(String title) {
    benefitsList.add({
      'title': title,
    });
    notifyListeners();
  }

  removeBenefits(int index) {
    benefitsList.removeAt(index);
    notifyListeners();
  }

  //FAQ
  //===========>

  List faqList = [];

  addFaq(String title, String desc) {
    faqList.add({'title': title, 'desc': desc});
    notifyListeners();
  }

  removeFaq(int index) {
    faqList.removeAt(index);
    notifyListeners();
  }

//===========>
//=========>

  fillAttributes(BuildContext context) {
    includedList = [];
    additionalList = [];
    benefitsList = [];
    faqList = [];

    var attributes =
        Provider.of<AttributeService>(context, listen: false).attributes;

    //include
    for (int i = 0; i < attributes.includeServices.length; i++) {
      includedList.add({
        'title': attributes.includeServices[i].includeServiceTitle,
        'price': attributes.includeServices[i].includeServicePrice,
        'qty': attributes.includeServices[i].includeServiceQuantity
      });
    }

    //additional
    for (int i = 0; i < attributes.additionalService.length; i++) {
      additionalList.add({
        'title': attributes.additionalService[i].additionalServiceTitle,
        'price': attributes.additionalService[i].additionalServicePrice,
        'qty': attributes.additionalService[i].additionalServiceQuantity
      });
    }

    //benefit
    for (int i = 0; i < attributes.serviceBenifit.length; i++) {
      benefitsList.add({'title': attributes.serviceBenifit[i].benifits});
    }

    //faq
    // for (int i = 0; i < attributes.serviceBenifit.length; i++) {
    //   benefitsList.add({'title': attributes.serviceBenifit[i].benifits});
    // }
  }

  //Edit attributes of a service
  // =================>

  bool editAttrLoading = false;

  setAddAttrLodingStatus(bool status) {
    editAttrLoading = status;
    notifyListeners();
  }

  editAttribute(BuildContext context, {required serviceId}) async {
    //check internet connection
    var connection = await checkConnection();
    if (!connection) return;

    if (editAttrLoading) return;

    // include service
    List incList = [];
    List addiList = [];
    List beniList = [];
    List fqList = [];

    for (int i = 0; i < includedList.length; i++) {
      if (isOnline) {
        incList.add({
          "service_id": serviceId,
          "include_service_title": includedList[i]['title'],
          "include_service_quantity": "0",
          "include_service_price": "0",
        });
      } else {
        incList.add({
          "service_id": serviceId,
          "include_service_title": includedList[i]['title'],
          "include_service_quantity": includedList[i]['qty'],
          "include_service_price": includedList[i]['price'],
        });
      }
    }

    for (int i = 0; i < additionalList.length; i++) {
      addiList.add({
        "service_id": serviceId,
        "additional_service_title": additionalList[i]['title'],
        "additional_service_quantity": additionalList[i]['qty'],
        "additional_service_price": additionalList[i]['price'],
      });
    }

    for (int i = 0; i < benefitsList.length; i++) {
      beniList.add({
        "service_id": serviceId,
        "benifits": benefitsList[i]['title'],
      });
    }

    for (int i = 0; i < faqList.length; i++) {
      fqList.add({
        "service_id": serviceId,
        "title": faqList[i]['title'],
        "description": faqList[i]['desc'],
      });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    print('service id $serviceId');

    var data = {
      "all_include_service": jsonEncode({"all_include_service": incList}),
      "all_additional_service":
          jsonEncode({"all_additional_service": addiList}),
      "service_benifits": jsonEncode({"service_benifits": beniList}),
      "online_service_faqs": jsonEncode({"online_service_faqs": fqList}),
    };
    if (isOnline) {
      data.addAll({
        "is_service_online_id": isOnline ? "1" : "0",
        "delivery_days": onlineServiceDuration.toString().tryToParse.toString(),
        "revision": onlineServiceRevisions.toString().tryToParse.toString(),
        "online_service_price":
            onlineServicePrice.toString().tryToParse.toString(),
      });
    }
    // log(data);
    // return;
    setAddAttrLodingStatus(true);
    print(incList);

    var response = await http.post(
        Uri.parse(
            '$baseApi/seller/service/update-service-attributes-by-id/$serviceId'),
        headers: header,
        body: jsonEncode(data));

    print(response.body);
    print(response.statusCode);

    setAddAttrLodingStatus(false);

    if (response.statusCode == 201) {
      Navigator.pop(context);
      Provider.of<MyServicesService>(context, listen: false)
          .fetchMyServiceList(context, isrefresh: true);
      onlineServicePrice = null;
      onlineServiceRevisions = null;
      onlineServiceDuration = null;
      OthersHelper().showToast('Service attribute updated', Colors.black);
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }
  }
}
