import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart';
import 'models/user_model.dart';
import 'providers/app_provider.dart';
import 'repositories/user_repository.dart';
import 'utils/alert_dialog/alert_dialog.dart';
import 'utils/colors.dart';
import 'widgets/app_bar.dart';

@immutable
class Root extends StatefulWidget {
  const Root({
    super.key,
    this.setupPageRoute,
    required this.child,
  });
  static RootState of(BuildContext context) {
    return context.findAncestorStateOfType<RootState>()!;
  }

  final String? setupPageRoute;
  final Widget child;

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppProvider>(context, listen: false);

    void checkAndAddBannedUsers() async {
      if (FirebaseAuth.instance.currentUser != null) {
        var bannedUserIds = await UserRepository.instance.bannedUserIds();
        appState.addManyBannedUserIds(userIds: bannedUserIds);
      }
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.idTokenChanges(),
      builder: (context, snapshot) {
        var currentUser = snapshot.data;

        return StreamBuilder<UserModel?>(
          stream: UserRepository.instance.currentStream(),
          builder: (context, snapshot) {
            var user = snapshot.data;

            if (snapshot.hasData && user != null) {
              checkAndAddBannedUsers();
            } else {
              if (appState.bannedUserIds.isNotEmpty) {
                appState.clearBannedUserIds();
              }
            }

            return Scaffold(
              appBar: AppBarHome(
                backgroundColor: AppColors.bg.basic,
                user: user,
                currentUser: currentUser,
                onPressSignIn: () => alertDialog.signIn(context),
              ),
              body: WillPopScope(
                // Handle android back button on sub routes.
                onWillPop: () async {
                  var currentState = shellNavigatorKey.currentState;
                  assert(currentState != null);

                  return !await currentState!.maybePop();
                },
                child: widget.child,
              ),
            );
          },
        );
      },
    );
  }
}
