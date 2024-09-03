import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/helper/extension/string_extension.dart';
import 'package:amrny_seller/services/my_services/attribute_service.dart';
import 'package:amrny_seller/services/my_services/edit_attribute_service.dart';
import 'package:amrny_seller/utils/responsive.dart';
import 'package:amrny_seller/view/my_service/add_attribute_page.dart';
import 'package:amrny_seller/view/my_service/components/my_service_helper.dart';
import 'package:amrny_seller/view/my_service/edit_attribute_page.dart';
import 'package:amrny_seller/view/my_service/edit_service_page.dart';
import 'package:amrny_seller/view/my_service/show_attribute_page.dart';

class MyServicesPopupMenu extends StatelessWidget {
  const MyServicesPopupMenu({
    Key? key,
    required this.serviceId,
    required this.isOnline,
    this.price,
    this.duration,
    this.revision,
  }) : super(key: key);

  final serviceId;
  final bool isOnline;
  final String? price;
  final String? duration;
  final String? revision;

  @override
  Widget build(BuildContext context) {
    List popupMenuList = [
      'Show attributes',
      'Edit attributes',
      'Add attributes',
      'Delete service',
      'Edit service'
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PopupMenuButton(
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            for (int i = 0; i < popupMenuList.length; i++)
              PopupMenuItem(
                onTap: () {
                  Future.delayed(
                    Duration.zero,
                    () {
                      navigate(
                        i,
                        context,
                        serviceId: serviceId,
                      );
                    },
                  );
                },
                child: Text(asProvider.getString(popupMenuList[i])),
              ),
          ],
        ),
      ],
    );
  }

  navigate(int i, BuildContext context, {required serviceId}) {
    if (i == 0) {
      Provider.of<AttributeService>(context, listen: false)
          .setAttrLodingStatus(true);
      Provider.of<AttributeService>(context, listen: false)
          .loadAttributes(context, serviceId: serviceId);
      //
      return Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ShowAttributePage(
            serviceId: serviceId,
          ),
        ),
      );
    } else if (i == 1) {
      if (isOnline) {
        final eaProvider =
            Provider.of<EditAttributeService>(context, listen: false);
        eaProvider.setOnlineServicePrice(price?.toString().tryToParse ?? "");
      }
      return Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => EditAttributePage(
            serviceId: serviceId,
            isOnline: isOnline,
          ),
        ),
      );
    } else if (i == 2) {
      return Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => AddAttributePage(
            serviceId: serviceId,
          ),
        ),
      );
    } else if (i == 3) {
      //========>
      MyServiceHelper().deleteServicePopup(context, serviceId: serviceId);
    } else if (i == 4) {
      //========>
      return Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => EditServicePage(
            serviceId: serviceId,
          ),
        ),
      );
    }
  }
}
