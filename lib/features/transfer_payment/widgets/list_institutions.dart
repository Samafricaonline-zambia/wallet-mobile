import 'package:flutter/material.dart';
import 'package:sampay_wallet/core/constants/assets.dart';
import 'package:sampay_wallet/core/models/institutions.dart';
import 'package:sampay_wallet/core/models/simple_item_model.dart';
import 'package:sampay_wallet/core/utils/app_utils.dart';
import 'package:sampay_wallet/core/widgets/simple_tile.dart';
import 'package:watch_it/watch_it.dart';

class ListInstitutions extends StatelessWidget with WatchItMixin {
  //final InstitutionType institutionType;
  final List<InstitutionModel> data;
  final Function(InstitutionModel value)? onClick;
  ListInstitutions({super.key, required this.data, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ...List.generate(data.length, (index) {
          return Column(
            children: [
              SimpleTile(
                item: SimpleItemModel(
                  title: data[index].participantName,
                  //subTitle: data[index].nfsId,
                  image: AppUtils().defaultIfEmpty(
                    data[index].logo,
                    AppAssets.logo,
                  ),
                ),
                onClick: () {
                  onClick?.call(data[index]);
                },
              ),
            ],
          );
        }),
      ],
    );
  }
}
