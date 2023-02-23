import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../models/community_model.dart';
import '../models/user_model.dart';
import '../repositories/community_repository.dart';
import '../repositories/user_repository.dart';
import '../utils/alert_dialog/alert_dialog.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';
import '../utils/snackbar.dart';
import '../utils/styles.dart';
import '../utils/tools.dart';
import '../widgets/app_bar.dart';
import '../widgets/button.dart';
import '../widgets/community_card.dart';
import '../widgets/edit_text.dart';
import '../widgets/loading_indicator.dart';

var currencyInputDecoration = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.text.link,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.text.placeholder,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.text.link,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(8),
  ),
);

enum CommunityActions {
  add,
  edit,
  delete,
}

/// Specify result of the router
class CommunityEditResult {
  const CommunityEditResult({
    this.action,
    this.community,
  });

  final CommunityActions? action;
  final CommunityModel? community;
}

/// Used for extra params in go router
class CommunityEditArguments {
  CommunityEditArguments({
    this.onUpdate,
  });

  final Function(CommunityEditResult)? onUpdate;
}

/// Used for go router deep linking
class CommunityEdit extends HookWidget {
  const CommunityEdit({
    super.key,
    required this.communityId,
    required this.extra,
  });

  final String? communityId;
  final CommunityEditArguments? extra;

  @override
  Widget build(BuildContext context) {
    var community = useState<CommunityModel?>(null);

    useEffect(() {
      Future<void> getCommunity() async {
        var result = await CommunityRepository.instance.getWithId(communityId);

        if (context.mounted && result != null) {
          community.value = result;
        }
      }

      getCommunity();
      return null;
    }, []);

    /// Edit community
    if (communityId != null) {
      if (community.value == null) {
        return const LoadingIndicator();
      }

      return _CommunityEdit(
        community: community.value!,
        extra: extra,
      );
    }

    /// Create community
    return const _CommunityCreate();
  }
}

class _CommunityCreate extends HookWidget {
  const _CommunityCreate();

  @override
  Widget build(BuildContext context) {
    var t = localization(context);
    var loading = useState(false);

    var visibilityItems = [
      DropdownMenuItem(value: 'public', child: Text(t.public)),
      DropdownMenuItem(value: 'private', child: Text(t.private)),
    ];

    var currencyItems = [
      const DropdownMenuItem(value: 'USD', child: Text('USD (₩)')),
      const DropdownMenuItem(value: 'KRW', child: Text('KRW (\$)')),
    ];

    var title = useState('');
    var titleController = useTextEditingController(text: '');
    var description = useState('');
    var descriptionController = useTextEditingController(text: '');
    var selectedColor = useState(communityColors[0]);
    var colors = useState(communityColors);
    var shouldDisableButton = useState(false);
    var isMobile = MediaQuery.of(context).size.width < 640;
    var user = useState<UserModel?>(null);
    var selectedVisibility = useState(visibilityItems[0].value);
    var selectedCurrency = useState(currencyItems[0].value);

    useEffect(() {
      Future<void> getUser() async {
        var result = await UserRepository.instance.getCurrent();

        if (context.mounted && result != null) {
          user.value = result;
        }
      }

      getUser();

      return null;
    }, []);

    Future<void> editCommunity() async {
      loading.value = true;

      try {
        await CommunityRepository.instance.edit(
          id: null,
          title: title.value,
          color: selectedColor.value,
          visibility: selectedVisibility.value == 'public',
          currency: selectedCurrency.value == 'KRW'
              ? CommunityCurrency.krw
              : CommunityCurrency.usd,
          description: description.value,
        );

        if (context.mounted) {
          context.canPop() ? context.pop() : null;

          snackbar.alert(
            context,
            t.communityCreated,
            backgroundColor: AppColors.role.primary,
            textColor: AppColors.text.contrast,
          );
        }
      } catch (e) {
        logger.e(e);

        if (context.mounted) {
          snackbar.alert(
            context,
            t.errorOccurred,
            backgroundColor: AppColors.role.danger,
            textColor: AppColors.text.contrast,
          );
        }
      } finally {
        if (context.mounted) {
          loading.value = false;
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bg.paper,
      appBar: const AppBarBack(),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                t.createYourCommunity,
                style: Heading3TextStyle(),
              ),
            ),
            // Carousel
            Padding(
              padding: const EdgeInsets.only(top: 22, bottom: 18),
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.25,
                  height: isMobile ? 210 : 330,
                  onPageChanged: (index, reason) =>
                      selectedColor.value = colors.value[index],
                  viewportFraction:
                      isMobile ? 0.7 : 520 / MediaQuery.of(context).size.width,
                ),
                items: colors.value.map((e) {
                  return CommunityCard(
                    userDisplayNameMaxWidth: 120,
                    hideAmount: true,
                    hideUser: selectedColor.value != e ||
                        title.value.isEmpty ||
                        description.value.isEmpty,
                    community: CommunityModel(
                      id: '',
                      title: title.value,
                      description: description.value,
                      createdAt: DateTime.now(),
                      color: e,
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: selectedColor.value,
                    border: Border.all(
                      color: AppColors.bg.basic,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: 16,
                  height: 16,
                ),
              ],
            ),
            // Inputs
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.bg.basic,
                border: Border.all(
                  color: AppColors.bg.disabled,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: AppColors.bg.paper,
                    ),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: currencyInputDecoration,
                      style: Body2TextStyle(),
                      value: selectedVisibility.value,
                      onChanged: (str) => selectedVisibility.value = str,
                      items: visibilityItems,
                      dropdownColor: AppColors.bg.paper,
                    ),
                  ),
                  EditFormText(
                    textEditingController: titleController,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    label: t.nameOfCommunity,
                    textHint: t.nameOfCommunityHint,
                    onChanged: (str) => title.value = str,
                  ),
                  EditFormText(
                    textEditingController: descriptionController,
                    margin: const EdgeInsets.only(bottom: 20),
                    label: t.descriptionOfCommunity,
                    textHint: t.descriptionOfCommunityHint,
                    onChanged: (str) => description.value = str,
                    maxLines: 6,
                    minLines: 6,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: AppColors.bg.paper,
                    ),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: currencyInputDecoration,
                      style: Body2TextStyle(),
                      value: selectedCurrency.value,
                      onChanged: (str) => selectedCurrency.value = str,
                      items: currencyItems,
                      dropdownColor: AppColors.bg.paper,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Button(
              loading: loading.value,
              disabled: shouldDisableButton.value,
              onPress: editCommunity,
              maximumSize: const Size(300, 52),
              text: t.createCommunity,
              textStyle: const TextStyle(fontSize: 16),
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _CommunityEdit extends HookWidget {
  const _CommunityEdit({
    required this.community,
    this.extra,
  });

  final CommunityModel community;
  final CommunityEditArguments? extra;

  @override
  Widget build(BuildContext context) {
    var t = localization(context);
    var loading = useState(false);

    var visibilityItems = [
      DropdownMenuItem(value: 'public', child: Text(t.public)),
      DropdownMenuItem(value: 'private', child: Text(t.private)),
    ];

    var currencyItems = [
      const DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
      const DropdownMenuItem(value: 'KRW', child: Text('KRW (₩)')),
    ];

    var title = useState(community.title);
    var description = useState(community.description ?? '');
    var selectedColor = useState(community.color);
    var colors = useState(communityColors);
    var isMobile = MediaQuery.of(context).size.width < 640;
    var user = useState<UserModel?>(null);
    var photoUrl = useState(community.thumbUrl ?? community.thumbUrl ?? '');
    var shouldDisableButton = title.value.isEmpty || description.value.isEmpty;

    var selectedVisibility = useState(
      visibilityItems[community.visibility == false ? 1 : 0].value,
    );

    var selectedCurrency = useState(
      currencyItems[community.currency == CommunityCurrency.usd ? 0 : 1].value,
    );

    useEffect(() {
      Future<void> getUser() async {
        var result = await UserRepository.instance.getCurrent();

        if (context.mounted && result != null) {
          user.value = result;
        }
      }

      getUser();

      return null;
    }, []);

    useEffect(() {
      var index = communityColors.indexOf(community.color);

      if (index != -1) {
        colors.value = [
          communityColors[index],
          ...communityColors.sublist(0, index),
          ...communityColors.sublist(index + 1),
        ];
      }

      return null;
    }, [community.color]);

    Future<void> updateImages(images) async {
      if (context.mounted) {
        await CommunityRepository.instance
            .updateImages(community: community, images: images);

        if (context.mounted) {
          photoUrl.value = images.thumbUrl ?? images.photoUrl ?? '';

          extra?.onUpdate?.call(
            CommunityEditResult(
              action: CommunityActions.edit,
              community: community.copyWith(
                thumbUrl: images.thumbUrl,
                photoUrl: images.photoUrl,
              ),
            ),
          );
        }
      }
    }

    Future<void> editCommunity() async {
      loading.value = true;

      try {
        await CommunityRepository.instance.edit(
          id: community.id,
          title: title.value,
          color: selectedColor.value,
          visibility: selectedVisibility.value == 'public',
          currency: selectedCurrency.value == 'KRW'
              ? CommunityCurrency.krw
              : CommunityCurrency.usd,
          description: description.value,
        );

        if (context.mounted) {
          CommunityModel? params;

          params = community.copyWith(
            title: title.value,
            color: selectedColor.value,
            visibility: selectedVisibility.value == 'public',
            currency: selectedCurrency.value == 'KRW'
                ? CommunityCurrency.krw
                : CommunityCurrency.usd,
            description: description.value,
          );

          extra?.onUpdate?.call(
            CommunityEditResult(
              action: CommunityActions.edit,
              community: params,
            ),
          );

          context.canPop() ? context.pop() : null;

          snackbar.alert(
            context,
            t.communityEdited,
            backgroundColor: AppColors.role.primary,
            textColor: AppColors.text.contrast,
          );
        }
      } catch (e) {
        logger.e(e);

        if (context.mounted) {
          snackbar.alert(
            context,
            t.errorOccurred,
            backgroundColor: AppColors.role.danger,
            textColor: AppColors.text.contrast,
          );
        }
      } finally {
        if (context.mounted) {
          loading.value = false;
        }
      }
    }

    Future<void> deleteCommunity() async {
      alertDialog.confirm(
        context,
        title: t.deleteCommunity,
        content: t.deleteCommunityDesc,
        onPress: () async {
          loading.value = true;

          var result = await CommunityRepository.instance.delete(community);

          if (context.mounted) {
            if (result) {
              while (context.canPop()) {
                context.pop();
              }
            }

            snackbar.alert(
              context,
              t.errorOccurred,
              backgroundColor: AppColors.role.danger,
              textColor: AppColors.text.contrast,
            );
          }
        },
        confirmButtonBackgroundColor: AppColors.role.danger,
        confirmTextColor: AppColors.text.contrast,
        showCancelButton: true,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg.paper,
      appBar: AppBarBack(
        actions: [
          IconButton(
            onPressed: deleteCommunity,
            icon: const Icon(
              Icons.delete_forever,
              size: 28,
            ),
            color: AppColors.role.danger,
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                t.createYourCommunity,
                style: Heading3TextStyle(),
              ),
            ),
            // Carousel
            Padding(
              padding: const EdgeInsets.only(top: 22, bottom: 18),
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.25,
                  height: isMobile ? 210 : 330,
                  onPageChanged: (index, reason) =>
                      selectedColor.value = colors.value[index],
                  viewportFraction:
                      isMobile ? 0.7 : 520 / MediaQuery.of(context).size.width,
                ),
                items: colors.value.map((e) {
                  return CommunityCard(
                    userDisplayNameMaxWidth: 120,
                    hideAmount: true,
                    hideUser: selectedColor.value != e,
                    onUploadPicture: updateImages,
                    community: community.copyWith(
                      color: e,
                      title: title.value,
                      thumbUrl: photoUrl.value,
                      photoUrl: photoUrl.value,
                      description: description.value,
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: selectedColor.value,
                    border: Border.all(
                      color: AppColors.bg.basic,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: 16,
                  height: 16,
                ),
              ],
            ),
            // Inputs
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.bg.basic,
                border: Border.all(
                  color: AppColors.bg.disabled,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: AppColors.bg.paper,
                    ),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: currencyInputDecoration,
                      style: Body2TextStyle(),
                      value: selectedVisibility.value,
                      onChanged: (str) => selectedVisibility.value = str,
                      items: visibilityItems,
                      dropdownColor: AppColors.bg.paper,
                    ),
                  ),
                  EditFormText(
                    initialValue: community.title,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    label: t.nameOfCommunity,
                    textHint: t.nameOfCommunityHint,
                    onChanged: (str) => title.value = str,
                  ),
                  EditFormText(
                    initialValue: community.description,
                    margin: const EdgeInsets.only(bottom: 20),
                    label: t.descriptionOfCommunity,
                    textHint: t.descriptionOfCommunityHint,
                    onChanged: (str) => description.value = str,
                    maxLines: 6,
                    minLines: 6,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: AppColors.bg.paper,
                    ),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: currencyInputDecoration,
                      style: Body2TextStyle(),
                      value: selectedCurrency.value,
                      onChanged: (str) => selectedCurrency.value = str,
                      items: currencyItems,
                      dropdownColor: AppColors.bg.paper,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Button(
              loading: loading.value,
              disabled: shouldDisableButton,
              onPress: editCommunity,
              maximumSize: const Size(300, 52),
              text: t.editCommunity,
              textStyle: const TextStyle(fontSize: 16),
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
