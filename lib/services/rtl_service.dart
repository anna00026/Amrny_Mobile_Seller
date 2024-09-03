// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_string_service.dart';

class RtlService with ChangeNotifier {
  /// RTL support
  String direction = 'ltr';
  String? langId;
  String currencyCode = 'USD';
  String langSlug = 'en_US';

  String currency = '\$';
  String currencyDirection = 'left';

  bool alreadyCurrencyLoaded = false;
  bool alreadyRtlLoaded = false;

  fetchCurrency() async {
    if (alreadyCurrencyLoaded == false) {
      print('$baseApi/currency');
      var response = await http.get(Uri.parse('$baseApi/currency'));
      print(response.body);
      if (response.statusCode == 201) {
        currency = jsonDecode(response.body)['currency']['symbol'];
        currencyDirection = jsonDecode(response.body)['currency']['position'];
        currencyCode = jsonDecode(response.body)['currency']['code'] ?? "USD";
        alreadyCurrencyLoaded == true;

        notifyListeners();
      } else {
        print('failed loading currency');
        print(response.body);
      }
    } else {
      //already loaded from server. no need to load again
    }
  }

  fetchDirection(BuildContext context) async {
    final srf = await SharedPreferences.getInstance();

    if (alreadyRtlLoaded == false) {
      var response = await http.get(Uri.parse('$baseApi/language'));
      print(response.body);
      if (response.statusCode == 201) {
        direction = jsonDecode(response.body)['language']['direction'];
        langSlug = jsonDecode(response.body)['language']['slug'] ?? 'en_US';
        langId = jsonDecode(response.body)['language']['id'].toString();
        var now = DateTime.now();
        if (!srf.containsKey('langId')) {
          print('Translating string for the first time');
          srf.setString('langId', langId!);
          srf.setString('update_date', now.toIso8601String());
          await Provider.of<AppStringService>(context, listen: false)
              .fetchTranslatedStrings();
        } else if (srf.getString('langId') != langId) {
          print('Updating translated Strings');
          srf.setString('langId', langId!);
          srf.setString('update_date', now.toIso8601String());
          await Provider.of<AppStringService>(context, listen: false)
              .fetchTranslatedStrings();
        } else if (now
                .difference(DateTime.parse(
                    srf.getString('update_date') ?? now.toIso8601String()))
                .inMinutes >
            7200) {
          srf.setString('update_date', now.toIso8601String());
          await Provider.of<AppStringService>(context, listen: false)
              .fetchTranslatedStrings();
        } else {
          print('Loading translations from local');
          await Provider.of<AppStringService>(context, listen: false)
              .fetchTranslatedStrings(doNotLoad: true);
        }

        alreadyRtlLoaded == true;
        notifyListeners();
      } else {
        print('failed loading language direction');
        print(response.body);
      }
    } else {
      //already loaded from server. no need to load again
    }
  }
  
  changeDirection(String direction, String locale) {
    this.direction = direction;
    langSlug = locale;
    notifyListeners();
  }
}
