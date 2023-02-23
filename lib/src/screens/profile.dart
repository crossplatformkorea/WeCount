import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../routes.dart';
import '../models/user_model.dart';
import '../providers/app_provider.dart';
import '../repositories/notification_repository.dart';
import '../repositories/user_repository.dart';
import '../services/fcm_service.dart';
import '../utils/alert_dialog/alert_dialog.dart';
import '../utils/assets.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';
import '../utils/snackbar.dart';
import '../utils/storage.dart';
import '../utils/tools.dart';
import '../widgets/app_bar.dart';
import '../widgets/button.dart';
import '../widgets/edit_text.dart';

class Profile extends HookWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    var t = localization(context);
    var appState = Provider.of<AppProvider>(context, listen: false);
    var displayNameController = useTextEditingController();
    var descriptionController = useTextEditingController();
    var updateButtonEnabled = useState(false);
    var loading = useState(false);
    var userState = useState<UserModel?>(null);

    useEffect(() {
      void fetchUser() async {
        var currentUser = await UserRepository.instance.getCurrent();

        if (context.mounted && currentUser != null) {
          userState.value = currentUser;
          displayNameController.text = userState.value!.displayName;
          descriptionController.text = userState.value!.description ?? '';
        }
      }

      fetchUser();
      return null;
    }, []);

    void enableUpdateButton() {
      if (displayNameController.text.isEmpty ||
          descriptionController.text.isEmpty) {
        updateButtonEnabled.value = false;
        return;
      }

      updateButtonEnabled.value = true;
    }

    void signOut() {
      alertDialog.confirm(
        context,
        title: t.logout,
        content: t.askLogout,
        onPress: () async {
          if (FcmService.instance.token != null) {
            await NotificationRepository.instance
                .removeToken(token: FcmService.instance.token!);
          }
          await FirebaseAuth.instance.signOut();

          if (context.mounted) {
            snackbar.alert(
              context,
              t.youHaveSignedOut,
              backgroundColor: AppColors.role.danger,
              textColor: AppColors.text.contrast,
            );

            appState.showFeedsInIntro = true;
            context.canPop() ? context.pop() : null;
          }
        },
        confirmButtonBackgroundColor: AppColors.role.danger,
        confirmTextColor: AppColors.text.contrast,
        showCancelButton: true,
      );
    }

    Future<void> uploadUserImages({
      ImageSource imageSource = ImageSource.gallery,
    }) async {
      if (userState.value == null) return;

      loading.value = true;

      try {
        var userImages = await Storage.instance.uploadImageSets(
          imageSource: imageSource,
          context: context,
          photoRef: Storage.instance.getUserPhotoRef(userState.value!.id),
          thumbRef: Storage.instance.getUserThumbRef(userState.value!.id),
        );

        if (userImages == null) {
          if (context.mounted) {
            loading.value = false;
          }

          return;
        }

        if (userImages.photoUrl.isNotEmpty) {
          await UserRepository.instance.updateProfile(
            displayName: displayNameController.text,
            description: descriptionController.text,
            photoUrl: userImages.photoUrl,
            thumbUrl: userImages.thumbUrl,
          );
        }

        if (context.mounted) {
          userState.value = userState.value?.copyWith(
            photoUrl: userImages.photoUrl,
            thumbUrl: userImages.thumbUrl,
          );
        }
      } finally {
        loading.value = false;
      }
    }

    Future<void> updateProfile() async {
      if (FirebaseAuth.instance.currentUser == null) {
        snackbar.alert(
          context,
          t.errorOccurred,
          backgroundColor: AppColors.role.danger,
          textColor: AppColors.text.basic,
        );
        return;
      }

      loading.value = true;

      try {
        await UserRepository.instance.updateProfile(
          displayName: displayNameController.text,
          description: descriptionController.text,
          photoUrl: userState.value?.photoUrl ?? '',
          thumbUrl: userState.value?.thumbUrl ?? '',
        );

        if (context.mounted) {
          snackbar.alert(
            context,
            t.updatedProfile,
            backgroundColor: AppColors.role.primary,
            textColor: AppColors.text.contrast,
          );
          context.canPop() ? context.pop() : null;
        }
      } catch (e) {
        logger.e(e);
      } finally {
        loading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bg.basic,
      appBar: AppBarBack(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          t.myProfile,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            color: AppColors.role.info,
            icon: const Icon(Icons.block),
            onPressed: () => context.pushNamed(AppRoutes.bannedUsers.name),
          ),
          IconButton(
            color: AppColors.role.danger,
            icon: const Icon(Icons.exit_to_app_outlined),
            onPressed: signOut,
            iconSize: 26,
          ),
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    left: 16, top: 36, right: 16, bottom: 36),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: AppColors.bg.basic.withOpacity(0.16),
                    offset: const Offset(4, 4),
                    blurRadius: 16,
                  )
                ], borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(70),
                              onTap: uploadUserImages,
                              child: ClipOval(
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: AppColors.bg.border),
                                    borderRadius: BorderRadius.circular(70),
                                    color: AppColors.bg.paper,
                                    image: (userState.value?.thumbUrl ?? '')
                                                .isEmpty ||
                                            (userState.value?.photoUrl ?? '')
                                                .isEmpty
                                        ? DecorationImage(
                                            fit: BoxFit.none,
                                            image: Assets.icCoin,
                                            scale: 0.8,
                                          )
                                        : DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage((userState
                                                            .value?.thumbUrl ??
                                                        '')
                                                    .isNotEmpty
                                                ? userState.value?.thumbUrl ??
                                                    ''
                                                : userState.value?.photoUrl ??
                                                    ''),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.bg.basic.withOpacity(0.5),
                                  border: Border.all(
                                    color: AppColors.text.primary,
                                    width: 0.5,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24)),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () => uploadUserImages(
                                    imageSource: ImageSource.camera,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: AppColors.text.basic,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      EditText(
                        textEditingController: displayNameController,
                        margin: const EdgeInsets.only(top: 48),
                        onChanged: (str) {
                          var trimmed = str.trim();

                          displayNameController.value = TextEditingValue(
                            text: trimmed,
                            selection: TextSelection.collapsed(
                              offset: trimmed.length,
                            ),
                          );

                          enableUpdateButton();
                        },
                        textHint: t.displayNameHint,
                      ),
                      EditText(
                        textEditingController: descriptionController,
                        margin: const EdgeInsets.only(top: 24),
                        onChanged: (txt) {
                          descriptionController.value = TextEditingValue(
                            text: txt,
                            selection: TextSelection.collapsed(
                              offset: txt.length,
                            ),
                          );

                          enableUpdateButton();
                        },
                        textHint: t.descriptionHint,
                      ),
                      Button(
                        disabled: !updateButtonEnabled.value,
                        loading: loading.value,
                        onPress: updateProfile,
                        color: AppColors.role.primary,
                        textStyle: TextStyle(color: AppColors.bg.basic),
                        margin: const EdgeInsets.only(top: 24),
                        text: t.update,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
