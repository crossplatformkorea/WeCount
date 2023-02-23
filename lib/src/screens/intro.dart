import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import '../providers/app_provider.dart';
import '../utils/assets.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';
import '../utils/snackbar.dart';
import '../utils/styles.dart';
import '../utils/tools.dart';
import 'feeds.dart';

var _dynamicLinks = FirebaseDynamicLinks.instance;

class Intro extends HookWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> initDynamicLinks() async {
      _dynamicLinks.onLink.listen((dynamicLink) {
        var deepLink = dynamicLink.link;

        // https://stackoverflow.com/a/65606109/8841562
        Future.microtask(() => context.pushNamed(
            deepLink.path.substring(
              1,
              deepLink.path.length,
            ),
            queryParams: deepLink.queryParameters));
      }).onError((error) {
        logger.e('dynamic link error: ${error.message}');
      });
    }

    useEffect(() {
      initDynamicLinks();

      return null;
    }, []);

    var appState = Provider.of<AppProvider>(context, listen: true);
    var t = localization(context);

    var initialMenus = [
      {
        'title': t.enterCommunity,
        'desc': t.enterCommunityDesc,
        'icon': Assets.icDoorEnter,
        'iconSize': 33.0,
        'onTap': () => context.pushNamed(AppRoutes.communities.name),
      },
    ];

    var menus = useState(initialMenus);

    useEffect(() {
      if (FirebaseAuth.instance.currentUser != null) {
        menus.value = [
          {
            'title': t.createCommunity,
            'desc': t.createCommunityDesc,
            'icon': Assets.icPlusCircle,
            'iconSize': 38.0,
            'onTap': () {
              if (FirebaseAuth.instance.currentUser == null) {
                menus.value = initialMenus;
                snackbar.alert(context, t.signInIsRequired);
                return;
              }

              context.pushNamed(AppRoutes.communityEdit.name);
            },
          },
          ...[menus.value[menus.value.length - 1]]
        ];

        return;
      }

      menus.value = initialMenus;

      return null;
    }, [FirebaseAuth.instance.currentUser?.uid]);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: appState.showFeedsInIntro
          ? const Feeds()
          : Scaffold(
              backgroundColor: AppColors.bg.paper,
              body: SafeArea(
                child: ListView(
                  children: [
                    const SizedBox(height: 120),
                    Text(
                      t.welcome,
                      textAlign: TextAlign.center,
                      style: Heading3TextStyle(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => appState.showFeedsInIntro = true,
                          child: Ink(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                child: Text(
                                  t.seeFeeds,
                                  style: TextStyle(
                                    color: AppColors.role.primary,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: menus.value.map((e) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          width: 260,
                          height: 260,
                          child: InkWell(
                            splashColor: AppColors.bg.paper,
                            borderRadius: BorderRadius.circular(30),
                            onTap: e['onTap'] as void Function(),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: AppColors.bg.basic,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.bg.basic,
                                    spreadRadius: 5,
                                    blurRadius: 42,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(32),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image(
                                            image: e['icon'] as AssetImage,
                                            width: e['iconSize'] as double,
                                            height: e['iconSize'] as double,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 22,
                                              bottom: 11,
                                            ),
                                            child: Text(
                                              e['title'] as String,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: Body1TextStyle().merge(
                                                const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  e['desc'] as String,
                                                  textAlign: TextAlign.center,
                                                  style: Body3TextStyle(),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
    );
  }
}
