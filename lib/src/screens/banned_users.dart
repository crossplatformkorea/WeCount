import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../repositories/user_repository.dart';
import '../utils/alert_dialog/alert_dialog.dart';
import '../utils/colors.dart';
import '../utils/firestore_config.dart';
import '../utils/localization.dart';
import '../widgets/app_bar.dart';
import '../widgets/user_list_item.dart';

class BannedUsers extends HookWidget {
  const BannedUsers({super.key});

  @override
  Widget build(BuildContext context) {
    var loading = useState(false);
    var userState = Provider.of<AppProvider>(context, listen: false);
    var t = localization(context);

    return Scaffold(
      backgroundColor: AppColors.bg.basic,
      appBar: AppBarBack(
        title: Text(t.banUser),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Consumer<AppProvider>(
          builder: (context, state, child) {
            var bannedUsers = state.bannedUserIds;

            return FlatList<String>(
              loading: loading.value,
              listEmptyWidget: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: Text(
                  t.noUsersHaveBeenBlocked,
                  style: TextStyle(
                      color: AppColors.text.placeholder, fontSize: 14),
                ),
              ),
              data: bannedUsers,
              buildItem: (item, index) {
                return UserListItemContainer(
                  userRef: FirestoreConfig.userColRef.doc(item),
                  type: UserListItemType.list,
                  showBanned: true,
                  showFollowButton: false,
                  padding: const EdgeInsets.only(
                      left: 12, right: 24, top: 12, bottom: 12),
                  onDelete: () async {
                    if (context.mounted) {
                      alertDialog.confirm(
                        context,
                        title: t.unblockUser,
                        content: t.unblockUserHint,
                        showCancelButton: true,
                        onPress: () async {
                          var result = await UserRepository.instance
                              .deleteFromBannedUsers(item);
                          if (result && context.mounted) userState.remove(item);
                        },
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
