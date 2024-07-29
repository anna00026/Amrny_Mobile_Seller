import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageBigPreviewPage extends StatelessWidget {
  const ImageBigPreviewPage({Key? key, this.networkImgLink, this.assetImgLink})
      : super(key: key);

  final networkImgLink;
  final assetImgLink;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.height;
    var screenHeight = MediaQuery.of(context).size.height;
    GlobalKey<ScaffoldState> _bigPagekey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _bigPagekey,
      // appBar: AppBar(),
      body: Stack(
        children: [
          networkImgLink != null
              ?
              //show network image
              Container(
                  alignment: Alignment.center,
                  child: CachedNetworkImage(
                    imageUrl: networkImgLink,
                    placeholder: (context, url) {
                      return Image.asset('assets/images/loading_image.png');
                    },
                    height: screenHeight - 150,
                    width: screenWidth,
                    // fit: BoxFit.fitHeight,
                  ),
                )
              : // else show asset image,
              Container(
                  alignment: Alignment.center,
                  child: Image.file(
                    File(assetImgLink),
                    height: screenHeight - 150,
                    width: screenWidth,
                    // fit: BoxFit.cover,
                  )),
        ],
      ),
    );
  }
}
