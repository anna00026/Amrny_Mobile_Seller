import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/dropdowns_services/area_dropdown_service.dart';
import 'package:qixer_seller/view/auth/signup/dropdowns/area_dropdown_popup.dart';
import 'package:qixer_seller/view/auth/signup/dropdowns/country_states_dropdowns.dart';

class AreaDropdown extends StatelessWidget {
  const AreaDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AreaDropdownService>(
      builder: (context, p, child) => InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height / 2 +
                        MediaQuery.of(context).viewInsets.bottom / 2,
                    child: const AreaDropdownPopup());
              });
        },
        child: dropdownPlaceholder(hintText: p.selectedArea),
      ),
    );
  }
}
