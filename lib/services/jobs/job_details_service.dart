import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:amrny_seller/model/job_details_model.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/services/profile_service.dart';
import 'package:amrny_seller/services/push_notification_service.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/profile_model.dart';

class JobDetailsService with ChangeNotifier {
  //Fetch order details
  //=====================>

  bool loadingOrderDetails = false;

  String? jobDetailsActionButtonText(BuildContext context) {
    final jd = jobDetails as JobDetails?;
    final user = Provider.of<ProfileService>(context, listen: false)
        .profileDetails as UserDetails?;
    if (jd == null) {
      return null;
    }

    for (JobRequest element in jd.jobRequest ?? []) {
      if (element.sellerId.toString() == user?.id?.toString()) {
        return "Applied";
      }
      if (element.isHired.toString() == "1") {
        return "Hired";
      }
    }
    if (DateTime.now().isAfter(jd.deadLine ?? DateTime.now())) {
      return "Job expired";
    }

    return null;
  }

  setOrderDetailsLoadingStatus(bool status) {
    loadingOrderDetails = status;
    notifyListeners();
  }

  var jobDetails;

  fetchJobDetails(jobId, BuildContext context) async {
    //check internet connection
    var connection = await checkConnection();
    if (connection) {
      //internet connection is on
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      setOrderDetailsLoadingStatus(true);
      print('fun ran');

      var response = await http.get(
        Uri.parse('$baseApi/job/details/$jobId'),
        headers: header,
      );

      setOrderDetailsLoadingStatus(false);

      if (response.statusCode == 201) {
        final data = JobDetailsModel.fromJson(jsonDecode(response.body));

        jobDetails = data.jobDetails;

        notifyListeners();
      } else {
        OthersHelper().showToast('Something went wrong', Colors.black);
      }
    }
  }

  // ===========>
  //================>
  bool applyLoading = false;

  setApplyLoadingStatus(bool status) {
    applyLoading = status;
    notifyListeners();
  }

  applyToJob(BuildContext context,
      {required buyerId,
      required buyerEmail,
      required jobPostId,
      required offerPrice,
      required coverLetter,
      required jobPrice}) async {
    var connection = await checkConnection();
    if (!connection) return;
    //internet connection is on
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var userId = prefs.getInt('userId');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    setApplyLoadingStatus(true);
    var data = jsonEncode({
      'buyer_id': buyerId,
      'buyer_email': buyerEmail,
      'seller_id': userId,
      'job_post_id': jobPostId,
      'expected_salary': offerPrice,
      'cover_letter': coverLetter,
      'job_price': jobPrice
    });

    var response = await http.post(Uri.parse('$baseApi/job/apply/new-job'),
        headers: header, body: data);

    setApplyLoadingStatus(false);
    print(response.body);
    print(response.statusCode);

    if (context.mounted) {
      Navigator.pop(context);
    }
    if (response.statusCode == 201) {
      OthersHelper().showToast('Successfully applied', Colors.black);
      sendNotificationInJobRequest(context,
          buyerId: buyerId, jobPostId: jobPostId);
    } else {
      print(response.body);
      try {
        final decodedData = jsonDecode(response.body);
        if (decodedData.containsKey('msg')) {
          OthersHelper().showToast(decodedData['msg'], Colors.black);
        } else {
          OthersHelper().showToast('Something went wrong', Colors.black);
        }
      } catch (e) {
        OthersHelper().showToast('Something went wrong', Colors.black);
      }
    }
  }

  //send notification
  //============>

  sendNotificationInJobRequest(
    BuildContext context, {
    required buyerId,
    required jobPostId,
  }) {
    //Send notification to seller
    var username = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .name ??
        '';
    PushNotificationService().sendNotificationToBuyer(context,
        buyerId: buyerId,
        title: asProvider.getString("New job request from") + " $username",
        body: asProvider.getString('Job id') + ': $jobPostId');
  }
}
