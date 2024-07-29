import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/my_services/create_services_service.dart';
import 'package:qixer_seller/utils/common_helper.dart';

class CreateServiceImageUpload extends StatelessWidget {
  const CreateServiceImageUpload(
      {Key? key, this.imageLink, this.isFromEditServicePage = false})
      : super(key: key);

  final imageLink;
  final isFromEditServicePage;

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateServicesService>(
      builder: (context, provider, child) => Consumer<AppStringService>(
        builder: (context, ln, child) => Column(
          children: [
            //
            if (imageLink != null && provider.pickedImage == null)
              CommonHelper().profileImage(imageLink, 80, 80),

            //
            if (provider.pickedImage != null)
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 80,
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
                                  File(provider.pickedImage.path),
                                  height: 80,
                                  width: 80,
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
              ),

            //pick image button =====>
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CommonHelper().buttonPrimary(ln.getString('Upload main image'),
                    () {
                  provider.pickMainImage(context);
                }),
              ],
            ),

            // multiple image
            //==================>
            //======================>

            // if (provider.galleryImages != null)
            //   if (provider.galleryImages!.isNotEmpty)
            //     Column(
            //       children: [
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         SizedBox(
            //           height: 80,
            //           child: ListView(
            //             clipBehavior: Clip.none,
            //             scrollDirection: Axis.horizontal,
            //             shrinkWrap: true,
            //             children: [
            //               for (int i = 0;
            //                   i < provider.galleryImages!.length;
            //                   i++)
            //                 InkWell(
            //                   onTap: () {},
            //                   child: Column(
            //                     children: [
            //                       Container(
            //                         margin: const EdgeInsets.only(right: 10),
            //                         child: Image.file(
            //                           File(provider.galleryImages![i].path),
            //                           height: 80,
            //                           width: 80,
            //                           fit: BoxFit.cover,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),

            provider.galleryImage != null
                ? Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 80,
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
                                      File(provider.galleryImage.path),
                                      height: 80,
                                      width: 80,
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

            //pick gallery image button =====>

            //not showing gallery image pick button in edit
            //service because, to do gallery , we need all gallery
            //image first, api not giving that, neight accepting
            //multiple image for gallery
            if (isFromEditServicePage == false)
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CommonHelper()
                      .buttonPrimary(ln.getString('Upload gallery image'), () {
                    provider.pickGalleryImages(context);
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
