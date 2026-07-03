import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/app_icons.dart';
import 'package:sampay_wallet/core/layouts/options_layout.dart';
import 'package:sampay_wallet/core/models/simple_item_model.dart';
import 'package:sampay_wallet/services/app_state_service.dart';
import 'package:sampay_wallet/core/services/configure_dependencies.dart';
import 'package:sampay_wallet/core/widgets/empty_space.dart';
import 'package:sampay_wallet/core/widgets/simple_avatar.dart';
import 'package:sampay_wallet/core/widgets/simple_buttons.dart';
import 'package:sampay_wallet/core/widgets/simple_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStateService appState = getIt<AppStateService>();

    final List<SimpleItemModel> userProfileItems = [
      SimpleItemModel(
        subTitle: appState.loggedInUser.value!.user.name,
        title: "Full name",
        icon: AppIcons.profile,
      ),
      SimpleItemModel(
        subTitle: appState.loggedInUser.value!.user.email,
        title: "Email",
        icon: AppIcons.email,
      ),
      SimpleItemModel(
        subTitle: appState.loggedInUser.value!.user.phone,
        title: "Phone",
        icon: AppIcons.phone,
      ),
    ];

    return OptionsLayout(
      title: "Profile",
      child: Column(
        children: [
          EmptySpace(),
          SimpleAvatar(userName: appState.loggedInUser.value!.user.name),
          EmptySpace(),
          ...List.generate(userProfileItems.length, (index) {
            return SimpleTile(item: userProfileItems[index]);
          }),
          // EmptySpace.large(),
          // SimpleButtons.fullWidth("Delete Account", isShadowed: true),
        ],
      ),
    );
  }
}
