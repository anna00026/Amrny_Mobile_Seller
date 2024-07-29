import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/view/my_service/create_service_page.dart';

class MyServiceListAppbar extends StatelessWidget {
  const MyServiceListAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    ConstantColors cc = ConstantColors();
    return AppBar(
      iconTheme: IconThemeData(color: cc.greyPrimary),
      title: Consumer<AppStringService>(
        builder: (context, ln, child) => Text(
          ln.getString('My services'),
          style: TextStyle(
              color: cc.greyPrimary, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
      ),
      actions: [
        Consumer<AppStringService>(
          builder: (context, ln, child) => Container(
            width: screenWidth / 4,
            padding: const EdgeInsets.symmetric(
              vertical: 9,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const CreateServicePage(),
                  ),
                );
              },
              child: Container(
                  // width: double.infinity,

                  alignment: Alignment.center,
                  // padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: cc.successColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: AutoSizeText(
                    ln.getString('Create'),
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  )),
            ),
          ),
        ),
        const SizedBox(
          width: 25,
        ),
      ],
    );
  }
}
