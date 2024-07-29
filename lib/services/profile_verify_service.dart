// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileVerifyService with ChangeNotifier {
  var pickedAddressImage;
  var pickedNidImage;

  final ImagePicker _picker = ImagePicker();

  Future pickAddressImage(BuildContext context) async {
    pickedAddressImage = await _picker.pickImage(source: ImageSource.gallery);

    notifyListeners();
  }

  Future pickNidImage(BuildContext context) async {
    pickedNidImage = await _picker.pickImage(source: ImageSource.gallery);

    notifyListeners();
  }

  //=================>
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  uploadDocument(context) async {
    if (pickedAddressImage == null || pickedNidImage == null) {
      OthersHelper().showToast(
          'You must upload both Address and NID document image', Colors.black);
      return;
    }

    setLoadingTrue();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var dio = Dio();
    // dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers["Authorization"] = "Bearer $token";

    FormData formData;
    formData = FormData.fromMap({
      'national_id': await MultipartFile.fromFile(pickedNidImage.path,
          filename: 'nidImage$pickedNidImage.jpg'),
      'address': await MultipartFile.fromFile(pickedAddressImage.path,
          filename: 'addressImage$pickedAddressImage.jpg'),
    });

    var response = await dio.post(
      '$baseApi/seller/profile/verify',
      data: formData,
      options: Options(
        validateStatus: (status) {
          return true;
        },
      ),
    );

    setLoadingFalse();
    if (response.statusCode == 201) {
      OthersHelper().showSnackBar(
          context, 'Document Submitted', ConstantColors().primaryColor);

      Navigator.pop(context);
      return true;
    } else {
      print(response.data);
      OthersHelper().showToast('Something went wrong', Colors.black);
      return false;
    }
  }
}
