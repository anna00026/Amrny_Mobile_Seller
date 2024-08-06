import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/services/rtl_service.dart';
import 'package:qixer_seller/utils/app_strings_ar.dart';
import 'package:qixer_seller/utils/app_strings_en.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AppStringService with ChangeNotifier {
  bool isloading = false;

  var tStrings;

  var languageDropdownList = [
    'English',
    'Arabic'
  ];
  var localeList = [
    'en',
    'ar'
  ];
  var currentLanguage = 'English';

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  fetchTranslatedStrings({bool doNotLoad = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (doNotLoad) {
      final strings = prefs.getString('translated_string');
      tStrings = jsonDecode(strings ?? 'null');
      return;
    }
    tStrings = currentLanguage == 'English' ? appStringsEn : appStringsAr;

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //   if (doNotLoad) {
    //     final strings = prefs.getString('translated_string');
    //     tStrings = jsonDecode(strings ?? 'null');
    //     return;
    //   }
    //   tStrings = currentLanguage == 'English' ? appStringsEn : appStringsAr;
    // if (tStrings != null) {
    //   //if already loaded. no need to load again
    //   return;
    // }
    // final srf = await SharedPreferences.getInstance();
    // if (doNotLoad) {
    //   final strings = srf.getString('translated_string');
    //   tStrings = jsonDecode(strings ?? 'null');
    //   return;
    // }
    // var connection = await checkConnection();
    // if (connection) {
    //   //internet connection is on
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   var token = prefs.getString('token');

    //   setLoadingTrue();

    //   var data = jsonEncode({
    //     'strings': jsonEncode(appStrings),
    //   });

    //   var header = {
    //     //if header type is application/json then the data should be in jsonEncode method
    //     "Accept": "application/json",
    //     "Content-Type": "application/json",
    //     "Authorization": "Bearer $token",
    //   };

    //   var response = await http.post(Uri.parse('$baseApi/translate-string'),
    //       headers: header, body: data);

    //   if (response.statusCode == 201) {
    //     tStrings = jsonDecode(response.body)['strings'];
    //     srf.setString('translated_string', jsonEncode(tStrings));
    //     notifyListeners();
    //   } else {
    //     print('error fetching translated string');
    //     print(response.body);
    //   }
    // }
  }

  getString(String staticString) {
    if (tStrings == null) {
      return staticString;
    }
    if (tStrings.containsKey(staticString)) {
      return tStrings[staticString];
    } else {
      return staticString;
    }
  }

  loadInitialLanguage(BuildContext context) async {
    await getCurrentLangauge();
    String locale = currentLanguage == 'English' ? 'en' : 'ar';
    String direction = currentLanguage == 'English' ? 'ltr' : 'rtl';
    fetchTranslatedStrings();
    await Provider.of<RtlService>(context, listen: false).changeDirection(direction, locale);
  }

  getCurrentLangauge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentLanguage = prefs.getString('language') ?? 'English';
    notifyListeners();
  }

  setCurrentLangauge(BuildContext context, String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();    
    currentLanguage = language.isEmpty ? 'English' : language;
    prefs.setString('language', currentLanguage);
    String locale = currentLanguage == 'English' ? 'en' : 'ar';
    String direction = currentLanguage == 'English' ? 'ltr' : 'rtl';
    fetchTranslatedStrings();
    await Provider.of<RtlService>(context, listen: false).changeDirection(direction, locale);
    notifyListeners();
  }
}
