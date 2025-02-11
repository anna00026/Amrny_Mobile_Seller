import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:amrny_seller/helper/extension/int_extension.dart';
import 'package:amrny_seller/model/wallet_history_model.dart';
import 'package:amrny_seller/services/common_service.dart';
import 'package:amrny_seller/services/dashboard_service.dart';
import 'package:amrny_seller/services/payments_service/payment_gateway_list_service.dart';
import 'package:amrny_seller/services/payments_service/payment_service.dart';
import 'package:amrny_seller/utils/others_helper.dart';
import 'package:amrny_seller/view/home/home.dart';
import 'package:amrny_seller/view/wallet/wallet_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService with ChangeNotifier {
  var walletHistory;
  var walletBalance = 0.cur;

  var walletHistoryId;

  bool isloading = false;
  bool hasWalletHistory = true;

  setLoadingStatus(bool status) {
    isloading = status;
    notifyListeners();
  }

  var amountToAdd;

  setAmount(v) {
    amountToAdd = v;
    notifyListeners();
  }

  // Fetch subscription history
  fetchWalletHistory(BuildContext context) async {
    var connection = await checkConnection();
    if (!connection) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingStatus(true);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http.get(Uri.parse('$baseApi/user/wallet/history'),
        headers: header);

    final decodedData = jsonDecode(response.body);

    print('wallet history response ${response.body}');

    if (response.statusCode == 200 && decodedData['history'].isNotEmpty) {
      final data = WalletHistoryModel.fromJson(jsonDecode(response.body));
      walletHistory = data.history;
      notifyListeners();
    } else {
      print('Error fetching wallet history' + response.body);

      hasWalletHistory = false;
      notifyListeners();

      Future.delayed(const Duration(seconds: 1), () {
        hasWalletHistory = true;
      });
    }
  }

  // Fetch wallet balance
  Future<bool> fetchWalletBalance(BuildContext context) async {
    var connection = await checkConnection();
    if (!connection) return false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    setLoadingStatus(true);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http.get(Uri.parse('$baseApi/user/wallet/balance'),
        headers: header);

    print('wallet balance response ${response.body}');

    final decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      walletBalance = decodedData['balance'];
      notifyListeners();

      return true;
    } else {
      print('Error fetching wallet balance' + response.body);

      return false;
    }
  }

  //============>
  //=========>

  Future<bool> createDepositeRequest(BuildContext context,
      {imagePath,
      bool isManualOrCod = false,
      bool paytmPaymentSelected = false}) async {
    //get user id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var connection = await checkConnection();
    if (!connection) return false;
    //if connection is ok

    Provider.of<PaymentService>(context, listen: false).setLoadingTrue();

    var selectedPayment =
        Provider.of<PaymentGatewayListService>(context, listen: false)
                .selectedMethodName ??
            'cash_on_delivery';

    FormData formData;
    var dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Authorization'] = "Bearer $token";

    if (imagePath != null) {
      formData = FormData.fromMap({
        'amount': amountToAdd,
        'payment_gateway': selectedPayment,
        'manual_payment_image': await MultipartFile.fromFile(imagePath,
            filename: 'bankTransfer.jpg'),
      });
    } else {
      formData = FormData.fromMap({
        'amount': amountToAdd,
        'payment_gateway': selectedPayment,
      });
    }

    var response = await dio.post(
      '$baseApi/user/wallet/deposit',
      data: formData,
      options: Options(
        validateStatus: (status) {
          return true;
        },
      ),
    );

    print(response.data);

    Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

    if (response.statusCode == 200) {
      walletHistoryId = response.data['deposit_info']['wallet_history_id'];

      if (isManualOrCod == true) {
        print('manual or code ran');
        doNext(context, 'Pending');
      }

      notifyListeners();

      return true;
    } else {
      print('error depositing to wallet ${response.data}');

      OthersHelper().showToast('Something went wrong', Colors.black);
      return false;
    }
  }

  ///////////==========>
  doNext(BuildContext context, String paymentStatus) async {
    //no need to make payment status complete
    inSuccess(context);
  }

  Future<bool> makeDepositeToWalletSuccess(BuildContext context) async {
    //make payment success

    var connection = await checkConnection();
    if (!connection) return false;
    //internet connection is on
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    print('wallet history id $walletHistoryId');
    var data = jsonEncode({'wallet_history_id': walletHistoryId});

    var response = await http.post(
        Uri.parse('$baseApi/user/wallet/deposit/payment-status'),
        headers: header,
        body: data);

    Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      inSuccess(context);
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }

    return true;
  }

  // =========>
  inSuccess(BuildContext context) async {
    setAmount(null);
    OthersHelper().showToast('Wallet deposit success', Colors.black);

    await fetchWalletBalance(context);
    fetchWalletHistory(context);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Homepage()),
        (Route<dynamic> route) => false);

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const WalletPage(),
      ),
    );
  }

  // =================>
  //===============>
  // deposite from current balance
  // seller sells product, he gets money in his balance.
  // from that balance, he can refill his wallet
  depositeFromCurrentBalance(
    BuildContext context,
  ) async {
    var connection = await checkConnection();
    if (!connection) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    Provider.of<PaymentService>(context, listen: false).setLoadingTrue();

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var data = jsonEncode({'amount': amountToAdd});

    var response = await http.post(
        Uri.parse('$baseApi/seller/wallet/diposit-from-balance'),
        headers: header,
        body: data);

    print(response.body);

    if (response.statusCode == 200) {
      await fetchWalletBalance(context);
      fetchWalletHistory(context);

      //refresh total balance in dashboard
      Provider.of<DashboardService>(context, listen: false)
          .fetchData(fetchAgain: true);

      Provider.of<PaymentService>(context, listen: false).setLoadingFalse();

      Navigator.pop(context);
    } else {
      Provider.of<PaymentService>(context, listen: false).setLoadingFalse();
      OthersHelper()
          .showSnackBar(context, 'Something went wrong', Colors.black);
      print('Error deposite from current balance' + response.body);
    }
  }

  //=====================>
  //================>

  Future<bool> validate(BuildContext context, isFromDepositeToWallet) async {
    if (isFromDepositeToWallet && amountToAdd == null) {
      OthersHelper().showToast('You must enter an amount', Colors.black);
      return false;
    }
    if (isFromDepositeToWallet && num.tryParse(amountToAdd) == null) {
      // user entered non integer value
      print(amountToAdd);
      OthersHelper().showToast('Please enter a valid amount', Colors.black);
      return false;
    }
    return true;
  }
}
