// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/cat_subcat_dropdown_service_for_edit_service.dart';
import 'package:qixer_seller/services/category_subcat_dropdown_service.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/services/my_services/my_services_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';
import 'package:qixer_seller/view/my_service/add_attribute_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateServicesService with ChangeNotifier {
  // ===========>
  var pickedImage;
  // List<XFile>? galleryImages = [];
  var galleryImage;

  setImageNull() {
    pickedImage = null;
    galleryImage = null;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();

  Future pickMainImage(BuildContext context) async {
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    notifyListeners();
  }
  // ===========>

  Future pickGalleryImages(BuildContext context) async {
    galleryImage = await _picker.pickImage(source: ImageSource.gallery);

    notifyListeners();
  }

  //Create service
  // ===============>

  bool createServiceLoading = false;

  setCreateLodingStatus(bool status) {
    createServiceLoading = status;
    notifyListeners();
  }

  createService(BuildContext context,
      {required bool isAvailableToAllCities,
      required description,
      required videoUrl,
      required title,
      required titleAr,
      required bool isFromCreateService}) async {
    //check internet connection
    var connection = await checkConnection();
    if (!connection) return false;

    if (createServiceLoading) return;

    if (pickedImage == null) {
      OthersHelper().showToast('You must select a main image', Colors.black);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var categoryId =
        Provider.of<CategorySubCatDropdownService>(context, listen: false)
            .selectedCategoryId;
    var subCategoryId =
        Provider.of<CategorySubCatDropdownService>(context, listen: false)
            .selectedSubCategoryId;
    var childCategoryId =
        Provider.of<CategorySubCatDropdownService>(context, listen: false)
            .selectedChildCategoryId;

    try {
      setCreateLodingStatus(true);

      FormData formData;
      var dio = Dio();
      dio.options.headers['Content-Type'] = 'multipart/form-data';
      dio.options.headers['Accept'] = 'application/json';
      dio.options.headers['Authorization'] = "Bearer $token";

      formData = FormData.fromMap({
        'category_id': categoryId,
        'subcategory_id': subCategoryId,
        'child_category_id': childCategoryId,
        'title': title,
        'title_ar': titleAr,
        'description': description,
        'image': await MultipartFile.fromFile(pickedImage.path,
            filename: 'image$categoryId$childCategoryId$title.jpg'),
        'image_gallery': galleryImage != null
            ? await MultipartFile.fromFile(pickedImage.path,
                filename: 'galleryimage$categoryId$childCategoryId$title.jpg')
            : null,
        'video': videoUrl,
        'is_service_all_cities': isAvailableToAllCities ? 1 : 0,
      });

      var response = await dio.post(
        '$baseApi/seller/service/add-service',
        options: Options(
          validateStatus: (status) {
            return true;
          },
        ),
        data: formData,
      );

      setCreateLodingStatus(false);

      print(response.data);
      print(response.statusCode);

      if (response.statusCode == 201) {
        //
        var serviceId = response.data['id'];
        //
        OthersHelper().showToast('Service created', Colors.black);

        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => AddAttributePage(
              serviceId: serviceId,
              isFromCreateService: true,
            ),
          ),
        );
      } else {
        OthersHelper().showToast('Something went wrong', Colors.black);
      }
    } catch (e) {
      OthersHelper().showToast(
          asProvider.getString('Something went wrong') + '$e', Colors.black);
      setCreateLodingStatus(false);
    }
  }

  //update service
  // ===============>

  bool updateServiceLoading = false;

  setUpdateLodingStatus(bool status) {
    updateServiceLoading = status;
    notifyListeners();
  }

  updateService(BuildContext context,
      {required bool isAvailableToAllCities,
      required description,
      required videoUrl,
      required title,
      required titleAr,
      required serviceId}) async {
    //check internet connection
    var connection = await checkConnection();
    if (!connection) return false;

    if (updateServiceLoading) return;

    // if (pickedImage == null) {
    //   OthersHelper().showToast('You must select a main image', Colors.black);
    //   return;
    // }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var categoryId = Provider.of<CatSubcatDropdownServiceForEditService>(
            context,
            listen: false)
        .selectedCategoryId;
    var subCategoryId = Provider.of<CatSubcatDropdownServiceForEditService>(
            context,
            listen: false)
        .selectedSubCategoryId;
    var childCategoryId = Provider.of<CatSubcatDropdownServiceForEditService>(
            context,
            listen: false)
        .selectedChildCategoryId;

    print('category id $categoryId');
    print('sub cat id $subCategoryId');
    print('child cat id $childCategoryId');
    // return;

    setUpdateLodingStatus(true);

    FormData formData;
    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";

    formData = FormData.fromMap({
      'service_id': serviceId,
      'category_id': categoryId,
      'subcategory': subCategoryId,
      'child_category': childCategoryId,
      'title': title,
      'title_ar': titleAr,
      'description': description,
      'image': pickedImage != null
          ? await MultipartFile.fromFile(pickedImage.path,
              filename: 'image$categoryId$childCategoryId$title.jpg')
          : null,
      'image_gallery': galleryImage != null
          ? await MultipartFile.fromFile(pickedImage.path,
              filename: 'galleryimage$categoryId$childCategoryId$title.jpg')
          : null,
      'video': videoUrl,
      'is_service_all_cities': isAvailableToAllCities ? 1 : 0,
    });

    var response = await dio.post(
      '$baseApi/seller/service/update-service',
      data: formData,
      options: Options(
        validateStatus: (status) {
          return true;
        },
      ),
    );

    setUpdateLodingStatus(false);

    print(response.data);
    print(response.statusCode);

    if (response.statusCode == 201) {
      //
      var serviceId = response.data['id'];
      //
      OthersHelper()
          .showToast('Service updated. Refreshing list', Colors.black);

      //refresh list
      //Reload service list
      Provider.of<MyServicesService>(context, listen: false).setDefault();
      Provider.of<MyServicesService>(context, listen: false)
          .fetchMyServiceList(context);

      Navigator.pop(context);
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }
  }
}
