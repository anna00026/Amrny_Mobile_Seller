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

  Map tStrings = {};

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
    //if already loaded. no need to load again
    var connection = await checkConnection();
    if (connection) {

      setLoadingTrue();

      var data = jsonEncode({
        "lang": currentLanguage == 'English' ? 'en' : 'ar',
      });

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        // "Accept": "application/json",
        "Content-Type": "application/json",
        // "Authorization": "Bearer $token",
      };
      var response = await http.post(Uri.parse('$baseApi/translate-string'),
          headers: header, body: data);

      try {
        if (response.statusCode == 201) {
          debugPrint(response.body.toString());
          var tStrings1 = jsonDecode(response.body)['strings'];
          tStrings = {
            ...tStrings,
            ...tStrings1
          };
          prefs.setString('translated_string', jsonEncode(tStrings));
          notifyListeners();
        } else {
          print('error fetching translations ${response.body}');
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  getString(String staticString) {
    if (tStrings.isEmpty) {
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
