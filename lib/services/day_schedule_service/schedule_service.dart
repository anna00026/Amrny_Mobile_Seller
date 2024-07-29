import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer_seller/model/schedule_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constant_colors.dart';
import '../../utils/others_helper.dart';
import '../../utils/responsive.dart';
import '../common_service.dart';

class ScheduleService with ChangeNotifier {
  ScheduleListModel? schedulesList;
  var selectedSchedule;
  Day? selectedDay;
  bool creatingScheduleLoading = false;
  bool deletingScheduleLoading = false;
  bool scheduleForAllDay = true;

  setSelectedSchedule(value) {
    if (value == selectedSchedule) {
      return;
    }
    selectedSchedule = value;
    notifyListeners();
  }

  setSelectedDay(value) {
    if (value == selectedDay) {
      return;
    }
    selectedDay = value;
    notifyListeners();
  }

  setCreatingScheduleLoading(value) {
    if (value == creatingScheduleLoading) {
      return;
    }
    creatingScheduleLoading = value;
    notifyListeners();
  }

  setDeleteScheduleLoading(value) {
    if (value == deletingScheduleLoading) {
      return;
    }
    deletingScheduleLoading = value;
    notifyListeners();
  }

  setScheduleForAllDay(value) {
    if (value == scheduleForAllDay) {
      return;
    }
    scheduleForAllDay = value;
    notifyListeners();
  }

  fetchSellerSchedules({forceFetch = false}) async {
    schedulesList = null;
    notifyListeners();
    final haveConnection = await checkConnection();
    if (!haveConnection) {
      return;
    }
    if (schedulesList != null && !forceFetch) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      // setInfoLoading(true);
      var headers = {'Authorization': 'Bearer $token'};
      var request =
          http.Request('GET', Uri.parse('$baseApi/seller/schedule-list'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = await response.stream.bytesToString();
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        schedulesList = scheduleListModelFromJson(data);
        debugPrint((schedulesList?.schedule?.data).toString());
        // schedulesList?.schedule?.data?.forEach((element) {
        //   debugPrint(element.days.toString());
        // });
        // schedulesList?.schedule?.data?.removeWhere(
        //   (element) => element.days == null,
        // );
        notifyListeners();
      } else {
        OthersHelper().showToast(
            asProvider.getString('Schedule fetching failed') +
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
          asProvider.getString('Schedule fetching failed') +
              ": " +
              err.toString(),
          ConstantColors().warningColor);
      debugPrint(err.toString());
      rethrow;
    } finally {}
  }

  fetchNextSchedules() async {
    if (schedulesList?.schedule?.nextPageUrl == null) {
      return;
    }
    final haveConnection = await checkConnection();
    if (!haveConnection) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      // setInfoLoading(true);
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.Request(
          'GET', Uri.parse('${schedulesList?.schedule?.nextPageUrl}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final responseData = scheduleListModelFromJson(data);
        responseData.schedule?.data?.forEach(
          (element) => schedulesList?.schedule?.data?.add(element),
        );
        schedulesList!.schedule!.nextPageUrl =
            responseData.schedule?.nextPageUrl;
        print(data);
        notifyListeners();
        return true;
      } else {
        OthersHelper().showToast(
            asProvider.getString('Next page loading failed') +
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
          asProvider.getString('Next page loading failed') +
              ": " +
              err.toString(),
          ConstantColors().warningColor);
      print(err);
    } finally {}
  }

  createNewSchedule(BuildContext context, schedule) async {
    final haveConnection = await checkConnection();
    if (!haveConnection) {
      return;
    }
    if (selectedDay == null) {
      OthersHelper().showToast(asProvider.getString("Select a day to continue"),
          ConstantColors().warningColor);
      return;
    }
    if (schedule == null || schedule.toString().isEmpty) {
      OthersHelper().showToast(
          asProvider.getString("Write schedule to continue"),
          ConstantColors().warningColor);
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      setCreatingScheduleLoading(true);
      var headers = {'Authorization': 'Bearer $token'};
      final String url;
      if (scheduleForAllDay) {
        url =
            '$baseApi/seller/schedule/create?day_id=${selectedDay?.id}&schedule=$schedule&schedule_for_all_days=${scheduleForAllDay ? 1 : 0}';
      } else {
        url =
            '$baseApi/seller/schedule/create?day_id=${selectedDay?.id}&schedule=$schedule';
      }
      var request = http.Request('POST', Uri.parse(url));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200 &&
          data['message'].toString().toLowerCase().contains('success')) {
        selectedSchedule = null;
        selectedDay = null;
        Navigator.pop(context);
        await fetchSellerSchedules(forceFetch: true);
        OthersHelper().showToast(
            asProvider.getString('Schedule created successfully'),
            ConstantColors().successColor);
        notifyListeners();
      } else if (data['message'] != null) {
        OthersHelper().showToast(
            data['message'].toString(), ConstantColors().warningColor);
      } else {
        OthersHelper().showToast(
            asProvider.getString('Creating schedule failed') +
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
          asProvider.getString('Creating schedule failed') +
              ": " +
              err.toString(),
          ConstantColors().warningColor);
      print(err);
    } finally {
      setCreatingScheduleLoading(false);
    }
  }

  updateNewSchedule(BuildContext context, schedule, id) async {
    final haveConnection = await checkConnection();
    if (!haveConnection) {
      return;
    }
    if (selectedDay == null) {
      OthersHelper().showToast(asProvider.getString("Select a day to continue"),
          ConstantColors().warningColor);
      return;
    }
    if (schedule == null || schedule.toString().isEmpty) {
      OthersHelper().showToast(
          asProvider.getString("Write schedule to continue"),
          ConstantColors().warningColor);
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      setCreatingScheduleLoading(true);
      var headers = {'Authorization': 'Bearer $token'};
      final String url =
          '$baseApi/seller/schedule/create?day_id=${selectedDay?.id}&schedule=$schedule&id=$id';

      var request = http.Request('POST', Uri.parse(url));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200 &&
          data['message'].toString().toLowerCase().contains('success')) {
        await fetchSellerSchedules(forceFetch: true);
        OthersHelper().showToast(
            asProvider.getString('Schedule updated successfully'),
            ConstantColors().successColor);
        Navigator.pop(context);
        notifyListeners();
      } else if (data['message'] != null) {
        OthersHelper().showToast(
            data['message'].toString(), ConstantColors().warningColor);
      } else {
        OthersHelper().showToast(
            asProvider.getString('Updating schedule failed') +
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
          asProvider.getString('Updating schedule failed') +
              ": " +
              err.toString(),
          ConstantColors().warningColor);
      print(err);
    } finally {
      setCreatingScheduleLoading(false);
    }
  }

  deleteSchedule(BuildContext context, scheduleId) async {
    final haveConnection = await checkConnection();
    if (!haveConnection) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      setDeleteScheduleLoading(true);
      var headers = {'Authorization': 'Bearer $token'};
      var request = http.Request(
          'POST', Uri.parse('$baseApi/seller/schedule/delete?id=$scheduleId'));

      request.headers.addAll(headers);
      print('$baseApi/seller/schedule/delete?id=$scheduleId');
      http.StreamedResponse response = await request.send();

      final data = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200 &&
          data['message'].toString().toLowerCase().contains('success')) {
        schedulesList?.schedule?.data?.removeWhere(
          (element) => element.id.toString() == scheduleId.toString(),
        );
        OthersHelper().showToast(
            "Schedule deleted successfully", ConstantColors().successColor);
        print(data);
        Navigator.pop(context);
        notifyListeners();
      } else if (data['message'] != null) {
        OthersHelper().showToast(
            data['message'].toString(), ConstantColors().warningColor);
      } else {
        OthersHelper().showToast(
            asProvider.getString('Schedule delete failed') +
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
          asProvider.getString('Schedule delete failed') +
              ": " +
              err.toString(),
          ConstantColors().warningColor);
      print(err);
    } finally {
      setDeleteScheduleLoading(false);
    }
  }
}
