import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/dropdowns_services/country_dropdown_service.dart';
import 'package:qixer_seller/utils/constant_colors.dart';

import '../../../../utils/common_helper.dart';
import '../dropdowns/area_dropdown.dart';
import '../dropdowns/country_dropdown.dart';
import '../dropdowns/state_dropdown.dart';

class CountryStatesDropdowns extends StatefulWidget {
  const CountryStatesDropdowns({Key? key}) : super(key: key);

  @override
  State<CountryStatesDropdowns> createState() => _CountryStatesDropdownsState();
}

class _CountryStatesDropdownsState extends State<CountryStatesDropdowns> {
  @override
  void initState() {
    super.initState();
    Provider.of<CountryDropdownService>(context, listen: false)
        .fetchCountries(context);
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //dropdown and search box
          const SizedBox(
            width: 17,
          ),

          // Country dropdown ===============>
          CommonHelper().labelCommon(ln.getString("Choose country")),
          const CountryDropdown(),

          const SizedBox(
            height: 25,
          ),
          // States dropdown ===============>
          CommonHelper().labelCommon(ln.getString("Choose states")),
          const StateDropdown(),

          const SizedBox(
            height: 25,
          ),

          // Area dropdown ===============>
          CommonHelper().labelCommon(ln.getString("Choose area")),
          const AreaDropdown()
        ],
      ),
    );
  }
}
