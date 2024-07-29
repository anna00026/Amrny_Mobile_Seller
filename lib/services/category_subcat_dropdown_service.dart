// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer_seller/model/categoryModel.dart';
import 'package:qixer_seller/model/child_category_model.dart';
import 'package:qixer_seller/model/sub_category_model.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategorySubCatDropdownService with ChangeNotifier {
  var categoryDropdownList = [];
  var categoryDropdownIndexList = [];
  var selectedCategory;
  var selectedCategoryId;

  setCategoryValue(value) {
    selectedCategory = value;
    notifyListeners();
  }

  setSelectedCategoryId(value) {
    selectedCategoryId = value;
    print('selected category id $selectedCategoryId');
    notifyListeners();
  }

  defaultCategory() {
    categoryDropdownList = [];
    categoryDropdownIndexList = [];
    selectedCategory = null;
    selectedCategoryId = null;
    notifyListeners();
  }

//==============>

  fetchCategory() async {
    if (categoryDropdownList.isNotEmpty) return;

    defaultCategory();

    var connection = await checkConnection();
    if (!connection) return;

    var response = await http.get(Uri.parse('$baseApi/category'));

    if (response.statusCode == 201) {
      var data = CategoryModel.fromJson(jsonDecode(response.body));

      for (int i = 0; i < data.category.length; i++) {
        categoryDropdownList.add(data.category[i].name);
        categoryDropdownIndexList.add(data.category[i].id);
      }

      print(response.body);

      selectedCategory = data.category[0].name;
      selectedCategoryId = data.category[0].id;

      fetchSubCategory();

      notifyListeners();
    } else {
      //Something went wrong
      categoryDropdownList = [asProvider.getString('Select Category')];
      categoryDropdownIndexList = [0];
      selectedCategory = asProvider.getString('Select Category');
      selectedCategoryId = 0;
    }
  }

  //==========>

  // ==========>

  var subCategoryDropdownList = [];
  var subCategoryDropdownIndexList = [];
  var selectedSubCategory;
  var selectedSubCategoryId;

  setSubCategoryValue(value) {
    selectedSubCategory = value;
    notifyListeners();
  }

  setSelectedSubCategoryId(value) {
    selectedSubCategoryId = value;
    print('selected subcategory id $selectedSubCategoryId');
    notifyListeners();
  }

  defaultSubcategory() {
    subCategoryDropdownList = [];
    subCategoryDropdownIndexList = [];
    selectedSubCategory = null;
    selectedSubCategoryId = null;
    notifyListeners();
  }

  // sub category
  //==============>
  fetchSubCategory() async {
    print('fetch category func called');
    var connection = await checkConnection();
    if (!connection) return;

    defaultSubcategory();

    var response = await http
        .get(Uri.parse('$baseApi/category/sub-category/$selectedCategoryId'));

    print('sub category ${response.body}');
    if (response.statusCode == 200 &&
        jsonDecode(response.body)['sub_categories'].isNotEmpty) {
      var data = SubcategoryModel.fromJson(jsonDecode(response.body));
      for (int i = 0; i < data.subCategories.length; i++) {
        subCategoryDropdownList.add(data.subCategories[i].name!);
        subCategoryDropdownIndexList.add(data.subCategories[i].id!);
      }

      print(response.body);

      selectedSubCategory = subCategoryDropdownList[0];
      selectedSubCategoryId = subCategoryDropdownIndexList[0];

      fetchChildCategory();
      notifyListeners();
    } else {
      //Something went wrong
      subCategoryDropdownList = [asProvider.getString('Select Subcategory')];
      subCategoryDropdownIndexList = [0];
      selectedSubCategory = asProvider.getString('Select Subcategory');
      selectedSubCategoryId = 0;
      notifyListeners();
    }
  }

  // ==========>
  //child category

  var childCategoryDropdownList = [];
  var childCategoryDropdownIndexList = [];
  var selectedChildCategory;
  var selectedChildCategoryId;

  setChildCategoryValue(value) {
    selectedChildCategory = value;
    notifyListeners();
  }

  setSelectedChildCategoryId(value) {
    selectedChildCategoryId = value;
    print('selected subcategory id $selectedChildCategoryId');
    notifyListeners();
  }

  defaultChildCategory() {
    childCategoryDropdownList = [];
    childCategoryDropdownIndexList = [];
    selectedChildCategory = null;
    selectedChildCategoryId = null;
    notifyListeners();
  }

  // child category
  //==============>
  fetchChildCategory() async {
    var connection = await checkConnection();
    if (!connection) return;

    defaultChildCategory();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var response = await http.get(
        Uri.parse(
            '$baseApi/seller/service/subcategory-wise-child-category/$selectedSubCategoryId'),
        headers: header);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 201 &&
        jsonDecode(response.body)['child_category'].isNotEmpty) {
      var data = ChildCategoryModel.fromJson(jsonDecode(response.body));

      for (int i = 0; i < data.childCategory.length; i++) {
        childCategoryDropdownList.add(data.childCategory[i].name!);
        childCategoryDropdownIndexList.add(data.childCategory[i].id!);
      }

      selectedChildCategory = childCategoryDropdownList[0];
      selectedChildCategoryId = childCategoryDropdownIndexList[0];
      notifyListeners();
    } else {
      //Something went wrong
      childCategoryDropdownList = [
        asProvider.getString('Select child category')
      ];
      childCategoryDropdownIndexList = [0];
      selectedChildCategory = asProvider.getString('Select child category');
      selectedChildCategoryId = 0;
      notifyListeners();
    }
  }
}
