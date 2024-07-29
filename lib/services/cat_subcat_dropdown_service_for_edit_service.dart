// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qixer_seller/model/categoryModel.dart';
import 'package:qixer_seller/model/child_category_model.dart';
import 'package:qixer_seller/model/sub_category_model.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/responsive.dart';

class CatSubcatDropdownServiceForEditService with ChangeNotifier {
//========>
  var existingCategoryId;
  var existingSubCatId;
  var existingChildCatId;

  setExistingCatSubcatDefault() {
    existingCategoryId = null;
    existingSubCatId = null;
    existingChildCatId = null;
    notifyListeners();
  }

  setExistingCatSubcatValue(
      {required categoryId, required subcategoryId, required childCategoryId}) {
    existingCategoryId = categoryId;
    existingSubCatId = subcategoryId;
    existingChildCatId = childCategoryId;
    notifyListeners();
  }

  //=============>
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

  Future<bool> fetchCategoryForEditService() async {
    defaultCategory();

    var connection = await checkConnection();
    if (!connection) return false;

    var response = await http.get(Uri.parse('$baseApi/category'));
    print(response.body);
    if (response.statusCode == 201) {
      var data = CategoryModel.fromJson(jsonDecode(response.body));

      for (int i = 0; i < data.category.length; i++) {
        categoryDropdownList.add(data.category[i].name);
        categoryDropdownIndexList.add(data.category[i].id);
      }

      //find the existing category id in all category index list
      //and show  existing data in dropdown
      int eId = categoryDropdownIndexList.indexOf(existingCategoryId);

      print('existing category id $existingCategoryId');
      print('existing category index $eId');
      print('category dropdown length ${categoryDropdownList.length}');

      if (existingCategoryId != null) {
        selectedCategory = categoryDropdownList[eId];
        selectedCategoryId = existingCategoryId;
      } else {
        selectedCategory = categoryDropdownList[0];
        selectedCategoryId = categoryDropdownIndexList[0];
      }

      fetchSubCategoryForEditService();

      notifyListeners();
      return true;
    } else {
      //Something went wrong
      categoryDropdownList = [asProvider.getString('Select Category')];
      categoryDropdownIndexList = [0];
      selectedCategory = asProvider.getString('Select Category');
      selectedCategoryId = 0;

      return false;
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
  fetchSubCategoryForEditService() async {
    var connection = await checkConnection();
    if (!connection) return;

    defaultSubcategory();

    var response = await http
        .get(Uri.parse('$baseApi/category/sub-category/$selectedCategoryId'));

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['sub_categories'].isNotEmpty) {
      var data = SubcategoryModel.fromJson(jsonDecode(response.body));
      for (int i = 0; i < data.subCategories.length; i++) {
        subCategoryDropdownList.add(data.subCategories[i].name!);
        subCategoryDropdownIndexList.add(data.subCategories[i].id!);
      }

      print(response.body);

      //find the existing category id in all category index list
      //and show  existing data in dropdown
      int eId = subCategoryDropdownIndexList.indexOf(existingSubCatId);

      if (existingSubCatId != null) {
        selectedSubCategory = subCategoryDropdownList[eId];
        selectedSubCategoryId = existingSubCatId;
      } else {
        selectedSubCategory = subCategoryDropdownList[0];
        selectedSubCategoryId = subCategoryDropdownIndexList[0];
      }

      fetchChildCategoryForEditService();
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
  fetchChildCategoryForEditService() async {
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

      //find the existing category id in all category index list
      //and show  existing data in dropdown
      if (existingChildCatId != null) {
        int eId = childCategoryDropdownIndexList.indexOf(existingChildCatId);
        print('existing child cat id $existingChildCatId');
        print('eid is $eId');
        selectedChildCategory = childCategoryDropdownList[eId];
        selectedChildCategoryId = existingChildCatId;
      } else {
        selectedChildCategory = childCategoryDropdownList[0];
        selectedChildCategoryId = childCategoryDropdownIndexList[0];
      }

      notifyListeners();
    } else {
      //Something went wrong
      setPlaceHolderChildCat();
    }

    //set existing subcat null because, it will cause bug when user selects a new category
    setExistingCatSubcatDefault();
  }

  setPlaceHolderChildCat() {
    childCategoryDropdownList = [asProvider.getString('Select child category')];
    childCategoryDropdownIndexList = [0];
    selectedChildCategory = asProvider.getString('Select child category');
    selectedChildCategoryId = 0;
    notifyListeners();
  }
}
