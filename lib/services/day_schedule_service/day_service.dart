import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/model/day_list_model.dart';
import 'package:qixer_seller/services/day_schedule_service/schedule_service.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/others_helper.dart';
import '../../utils/responsive.dart';
import '../common_service.dart';

class DayService with ChangeNotifier {
  var daysList = [];
  List<DayListModel> sellerDays = [];
  var selectedDay;
  bool creatingDayLoading = false;
  bool deletingDayLoading = false;
  bool dynamicDayLoading = false;

  setSelectedDay(value) {
    if (value == selectedDay) {
      return;
    }
    selectedDay = value;
    notifyListeners();
  }

  setCreatingDayLoading(value) {
    if (value == creatingDayLoading) {
      return;
    }
    creatingDayLoading = value;
    notifyListeners();
  }

  setDeletingDayLoading(value) {
    if (value == deletingDayLoading) {
      return;
    }
    deletingDayLoading = value;
    notifyListeners();
  }

  setDynamicDayLoading(value) {
    if (value == dynamicDayLoading) {
      return;
    }
    dynamicDayLoading = value;
    notifyListeners();
  }

  fetchDynamicDays(BuildContext context) async {
    final haveConnection = await checkConnection();
    if (!haveConnection) {
      return;
    }
    print(daysList);
    if (daysList.isNotEmpty) {
      return;
    }
    setDynamicDayLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      // setInfoLoading(true);
      var headers = {'Authorization': 'Bearer $token'};
      var request =
          http.Request('GET', Uri.parse('$baseApi/seller/available-days-list'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        daysList = jsonDecode(data);
        print(data);
        setDynamicDayLoading(false);
        return true;
      } else {
        OthersHelper().showToast(
            asProvider.getString('Fetching days failed') +
                ": " +
                response.reasonPhrase.toString(),
            ConstantColors().warningColor);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      OthersHelper().showToast(asProvider.getString('Request timeout'),
          ConstantColors().warningColor);
    } catch (err) {
      OthersHelper().showToast(
          asProvider.getString('Fetching days failed') + ": " + err.toString(),
          ConstantColors().warningColor);
      print(err);
    } finally {
      setDynamicDayLoading(false);
    }
  }

  fetchSellerDays({forceFetch = false}) async {
    final haveConnection = await checkConnection();
    if (!haveConnection) {
      return;
    }
    if (!forceFetch && sellerDays.isNotEmpty) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      // setInfoLoading(true);
      var headers = {'Authorization': 'Bearer $token'};
      var request =
          http.Request('GET', Uri.parse('$baseApi/seller/schedule-days-list'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        sellerDays = dayListModelFromJson(data);
        print(data);
        notifyListeners();
      } else {
        OthersHelper().showToast(
            asProvider.getString('Day fetching failed') +
                ": " +
                response.reasonPhrase.toString(),
            ConstantColors().warningColor);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      OthersHelper().showToast(asProvider.getString('Request timeout'),
          ConstantColors().warningColor);
    } catch (err) {
      OthersHelper().showToast(
          asProvider.getString('Day fetching failed') + ": " + err.toString(),
          ConstantColors().warningColor);
      print(err);
    } finally {}
  }

  createNewDay(BuildContext context) async {
    final haveConnection = await checkConnection();
    if (!haveConnection) {
      return;
    }
    if (selectedDay == null) {
      OthersHelper().showToast(asProvider.getString("Select a day to save"),
          ConstantColors().warningColor);
      return;
    }
    setCreatingDayLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      // setInfoLoading(true);
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.Request(
          'POST', Uri.parse('$baseApi/seller/create-day?day=$selectedDay'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200 &&
          data['message'].toString().toLowerCase().contains('success')) {
        print(data);
        await fetchSellerDays(forceFetch: true);
        Provider.of<ScheduleService>(context, listen: false)
            .fetchSellerSchedules(forceFetch: true);
        OthersHelper().showToast(
            asProvider.getString("Day created successfully"),
            ConstantColors().warningColor);
        Navigator.pop(context);
        notifyListeners();
      } else {
        OthersHelper().showToast(
            asProvider.getString('Creating day failed') +
                ": " +
                response.reasonPhrase.toString(),
            ConstantColors().warningColor);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      OthersHelper().showToast(asProvider.getString('Request timeout'),
          ConstantColors().warningColor);
    } catch (err) {
      OthersHelper().showToast(
          asProvider.getString('Creating day failed') + ": " + err.toString(),
          ConstantColors().warningColor);
      print(err);
    } finally {
      setCreatingDayLoading(false);
    }
  }

  deleteSellerDay(BuildContext context, id) async {
    final haveConnection = await checkConnection();
    if (!haveConnection) {
      return;
    }
    setDeletingDayLoading(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      // setInfoLoading(true);
      var headers = {'Authorization': 'Bearer $token'};
      var request =
          http.Request('POST', Uri.parse('$baseApi/seller/day-delete?id=$id'));

      request.headers.addAll(headers);
      print('$baseApi/seller/day-delete?id=$id');
      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200 &&
          data['message'].toString().toLowerCase().contains('success')) {
        print(data);
        sellerDays.removeWhere(
          (element) => element.id.toString() == id.toString(),
        );
        OthersHelper().showToast(
            asProvider.getString("Day deleted successfully"),
            ConstantColors().warningColor);
        Navigator.pop(context);
        notifyListeners();
      } else {
        OthersHelper().showToast(
            asProvider.getString('Deleting day failed') +
                ": " +
                response.reasonPhrase.toString(),
            ConstantColors().warningColor);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      OthersHelper().showToast(asProvider.getString('Request timeout'),
          ConstantColors().warningColor);
    } catch (err) {
      OthersHelper().showToast(
          asProvider.getString('Deleting day failed') + ": " + err.toString(),
          ConstantColors().warningColor);
      print(err);
    } finally {
      setDeletingDayLoading(false);
    }
  }
}
