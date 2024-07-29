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
    SplashService().loginOrGoHome(context);
  }

  @override
  Widget build(BuildContext context) {
    startInitialization(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          alignment: Alignment.center,
          // color: ConstantColors().primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 40,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fitHeight)),
              ),
              const SizedBox(
                height: 15,
              ),
              OthersHelper().showLoading(ConstantColors().primaryColor)
            ],
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ));
  }
}
