import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/my_services/attribute_service.dart';
import 'package:qixer_seller/utils/constant_colors.dart';

class AddAdditionalImageUpload extends StatelessWidget {
  const AddAdditionalImageUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Consumer<AttributeService>(
      builder: (context, provider, child) => Consumer<AppStringService>(
        builder: (context, ln, child) => Row(
          children: [
            //add image button
            InkWell(
              onTap: () {
                provider.pickAdditionalImage(context);
              },
              child: Container(
                color: cc.orangeColor,
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.image,
                  color: Colors.white,
                ),
              ),
            ),

            provider.pickedAdditionalImage != null
                ? Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: ListView(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: Image.file(
                                      // File(provider.images[i].path),
                                      File(provider.pickedAdditionalImage.path),
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
