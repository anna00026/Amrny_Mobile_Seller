import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:qixer_seller/model/report_list_model.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/services/report_services/report_message_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/view/report/report_chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportService with ChangeNotifier {
  var reportList = [];

  late int totalPages;
  int currentPage = 1;

  setCurrentPage(newValue) {
    currentPage = newValue;
    notifyListeners();
  }

  setTotalPage(newPageNumber) {
    totalPages = newPageNumber;
    notifyListeners();
  }

  setReportListDefault() {
    currentPage = 1;
    reportList = [];
    notifyListeners();
  }

  addNewDataReportList(subject, id, priority, status) {
    reportList.add(
        {'subject': subject, 'id': id, 'priority': priority, 'status': status});
    notifyListeners();
  }

  fetchReportList(context, {bool isrefresh = false}) async {
    if (isrefresh) {
      //making the list empty first to show loading bar (we are showing loading bar while the product list is empty)
      //we are make the list empty when the sub category or brand is selected because then the refresh is true
      reportList = [];

      notifyListeners();

      Provider.of<ReportService>(context, listen: false)
          .setCurrentPage(currentPage);
    } else {}

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var connection = await checkConnection();
    if (connection) {
      //if connection is ok

      var response = await http.post(
          Uri.parse("$baseApi/user/report/list?page=$currentPage"),
          headers: header);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 &&
          jsonDecode(response.body)['data'].isNotEmpty) {
        var data = ReportListModel.fromJson(jsonDecode(response.body));

        setTotalPage(data.total);

        if (isrefresh) {
          print('refresh true');
          //if refreshed, then remove all service from list and insert new data
          //make the list empty first so that existing data doesn't stay
          setServiceList(data.data, false);
        } else {
          print('add new data');

          //else add new data
          setServiceList(data.data, true);
        }

        currentPage++;
        setCurrentPage(currentPage);
        return true;
      } else {
        print(response.body);
        return false;
      }
    }
  }

  setServiceList(List dataList, bool addnewData) {
    if (addnewData == false) {
      //make the list empty first so that existing data doesn't stay
      reportList = [];
      notifyListeners();
    }

    for (int i = 0; i < dataList.length; i++) {
      reportList.add({
        'subject': dataList[i].report,
        'id': dataList[i].id,
        'priority': dataList[i].buyerId,
        'status': dataList[i].status,
        'orderId': dataList[i].orderId,
        'serviceId': dataList[i].serviceId,
      });
    }

    notifyListeners();
  }

  // ============>
  //===========>

  bool reportLoading = false;

  setRLoadingStatus(bool status) {
    reportLoading = status;
    notifyListeners();
  }

  Future<bool> leaveReport(BuildContext context,
      {required message, required serviceId, required orderId}) async {
    var connection = await checkConnection();
    if (!connection) return false;

    setRLoadingStatus(true);

    var data = jsonEncode({
      'report': message,
      'order_id': orderId,
      'service_id': serviceId,
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await http.post(Uri.parse('$baseApi/user/report/create'),
        body: data, headers: header);

    setRLoadingStatus(false);
    if (response.statusCode == 200) {
      OthersHelper().showToast('Report submitted', Colors.black);

      Provider.of<ReportService>(context, listen: false)
          .fetchReportList(context);
      Navigator.pop(context);

      return true;
    } else {
      print(response.body);
      //Sign up unsuccessful ==========>
      OthersHelper().showToast(jsonDecode(response.body)['msg'], Colors.black);

      return false;
    }
  }

  //

  goToMessagePage(BuildContext context, title, reportId) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ReportChatPage(
          title: reportId.toString(),
          ticketId: reportId,
        ),
      ),
    );
    //fetch message
    Provider.of<ReportMessagesService>(context, listen: false)
        .fetchMessages(reportId);
  }
}
