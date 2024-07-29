import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/dropdowns_services/country_dropdown_service.dart';
import 'package:qixer_seller/view/auth/signup/dropdowns/country_dropdown_popup.dart';
import 'package:qixer_seller/view/auth/signup/dropdowns/country_states_dropdowns.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryDropdownService>(
      builder: (context, p, child) => InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height / 2 +
                        MediaQuery.of(context).viewInsets.bottom / 2,
                    child: const CountryDropdownPopup());
              });
        },
        child: dropdownPlaceholder(hintText: p.selectedCountry),
      ),
    );
  }
}
