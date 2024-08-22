import 'package:flutter/material.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/others_helper.dart';

import '../../services/splash_service.dart';
import '../../utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 500), () {
      screenSizeAndPlatform(context);
    });
  }

  startInitialization(BuildContext context) async {
    try {
      await runAtSplashScreen(context);
    } catch (error) {
      print(error);
    }
    initializeLNProvider(context);
    Future.delayed(const Duration(microseconds: 2), () {
      SplashService().loginOrGoHome(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    startInitialization(context);
    return Scaffold(
        backgroundColor: cc.primaryColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: cc.primaryColor,
          ),
          // color: ConstantColors().primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fitHeight)),
              ),
              const SizedBox(height: 24),
              OthersHelper().showLoading(Colors.white),
              const SizedBox(height: 24),
            ],
          ),
        ));
  }
}
