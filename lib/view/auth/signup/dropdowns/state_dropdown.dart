import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amrny_seller/services/dropdowns_services/state_dropdown_services.dart';
import 'package:amrny_seller/view/auth/signup/dropdowns/country_states_dropdowns.dart';
import 'package:amrny_seller/view/auth/signup/dropdowns/state_dropdown_popup.dart';

class StateDropdown extends StatelessWidget {
  const StateDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StateDropdownService>(
      builder: (context, p, child) => InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SizedBox(
                    height: MediaQuery.of(context).size.height / 2 +
                        MediaQuery.of(context).viewInsets.bottom / 2,
                    child: const StateDropdownPopup());
              });
        },
        child: dropdownPlaceholder(hintText: p.selectedState),
      ),
    );
  }
}
