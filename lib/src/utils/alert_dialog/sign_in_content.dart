import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../models/user_model.dart';
import '../../providers/app_provider.dart';
import '../../repositories/user_repository.dart';
import '../../widgets/button.dart';
import '../../widgets/edit_text.dart';
import '../assets.dart';
import '../colors.dart';
import '../config.dart';
import '../general.dart';
import '../localization.dart';
import '../snackbar.dart';
import '../styles.dart';
import '../tools.dart';
import '../utils.dart';
import '../validator.dart';
import 'alert_dialog.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInContent extends HookWidget {
  const SignInContent({super.key});

  @override
  Widget build(BuildContext context) {
    var t = localization(context);
    var emailController = useTextEditingController();
    var passwordController = useTextEditingController();
    var appState = Provider.of<AppProvider>(context, listen: true);

    // Note: the following two lines are added separately to enable the button
    // when the form fields are valid.
    var email = useState('');
    var password = useState('');
    var error = useState('');
    var loadingEmail = useState(false);
    var loadingGoogle = useState(false);

    void signIn() async {
      loadingEmail.value = true;

      try {
        var currentUser = (await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        ))
            .user;

        if (context.mounted && currentUser != null) {
          if (!currentUser.emailVerified) {
            error.value = t.emailIsNotVerified;
            unawaited(FirebaseAuth.instance.signOut());
            return;
          }

          var user = UserModel(
            id: currentUser.uid,
            email: emailController.text,
            displayName: currentUser.displayName ?? '',
            birthday: null,
            followerCount: 0,
            photoUrl: currentUser.photoURL,
            name: currentUser.displayName,
            phoneNumber: currentUser.phoneNumber,
            createdAt: DateTime.now(),
            deletedAt: null,
          );

          await UserRepository.instance.registerIfNewUser(user);
          appState.showFeedsInIntro = false;

          if (context.mounted) {
            snackbar.alert(context, t.welcome,
                duration: const Duration(seconds: 3),
                backgroundColor: AppColors.role.primary,
                textStyle: TextStyle(color: AppColors.text.contrast));

            context.canPop() ? context.pop() : null;
          }
        }
      } on FirebaseAuthException catch (e) {
        error.value = t.authenticationFailed;
        logger.e(e);
      } finally {
        if (context.mounted) {
          loadingEmail.value = false;
        }
      }
    }

    Future<void> signInWithGoogle() async {
      var googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
        clientId: !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS
            ? null
            : Config().googleWebClientId,
      );

      General.instance.showDialogSpinner(
        context,
        text: localization(context).signingInWithSocialProvider(t.google),
      );

      try {
        var googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          if (context.mounted) {
            context.canPop() ? context.pop() : null;
          }
          return;
        }

        var googleAuth = await googleUser.authentication;

        var credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        var auth = await FirebaseAuth.instance.signInWithCredential(credential);
        var currentUser = auth.user!;

        var user = UserModel(
          id: currentUser.uid,
          email: emailController.text,
          displayName: currentUser.displayName ?? '',
          birthday: null,
          followerCount: 0,
          photoUrl: currentUser.photoURL,
          name: currentUser.displayName,
          phoneNumber: currentUser.phoneNumber,
          createdAt: DateTime.now(),
          deletedAt: null,
        );

        await UserRepository.instance.registerIfNewUser(user);
        unawaited(googleSignIn.signOut());
        appState.showFeedsInIntro = false;

        if (context.mounted) {
          // Pop twice
          context.canPop() ? context.pop() : null;
          context.canPop() ? context.pop() : null;
        }
      } catch (err) {
        logger.e(err);
      }
    }

    Future<void> signInWithApple() async {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        var rawNonce = generateNonce();
        var nonce = sha256ofString(rawNonce);

        try {
          General.instance.showDialogSpinner(
            context,
            text: localization(context).signingInWithSocialProvider(t.apple),
          );

          var appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: nonce,
          );

          var oauthCredential = OAuthProvider('apple.com').credential(
            idToken: appleCredential.identityToken,
            rawNonce: rawNonce,
          );

          var auth =
              await FirebaseAuth.instance.signInWithCredential(oauthCredential);
          var currentUser = auth.user!;

          var user = UserModel(
            id: currentUser.uid,
            email: emailController.text,
            displayName: currentUser.displayName ?? '',
            birthday: null,
            followerCount: 0,
            photoUrl: currentUser.photoURL,
            name: currentUser.displayName,
            phoneNumber: currentUser.phoneNumber,
            createdAt: DateTime.now(),
            deletedAt: null,
          );

          await UserRepository.instance.registerIfNewUser(user);
          appState.showFeedsInIntro = false;

          if (context.mounted) {
            // Pop twice
            context.canPop() ? context.pop() : null;
            context.canPop() ? context.pop() : null;
          }
        } catch (e) {
          logger.e(e);
          if (context.mounted) {
            context.canPop() ? context.pop() : null;
          }
        }
      } else if (kIsWeb) {
        var provider = OAuthProvider('apple.com')
          ..addScope('email')
          ..addScope('name');

        try {
          var auth = await FirebaseAuth.instance.signInWithPopup(provider);
          var currentUser = auth.user!;

          var user = UserModel(
            id: currentUser.uid,
            email: emailController.text,
            displayName: currentUser.displayName ?? '',
            birthday: null,
            followerCount: 0,
            photoUrl: currentUser.photoURL,
            name: currentUser.displayName,
            phoneNumber: currentUser.phoneNumber,
            createdAt: DateTime.now(),
            deletedAt: null,
          );

          await UserRepository.instance.registerIfNewUser(user);
          appState.showFeedsInIntro = false;

          if (context.mounted) {
            // Pop twice
            context.canPop() ? context.pop() : null;
            context.canPop() ? context.pop() : null;
          }
        } catch (err) {
          logger.e(err);
          rethrow;
        }
      }
      // Not supported
      return;
    }

    var isMobile = MediaQuery.of(context).size.width <= 480;

    return Container(
      height: defaultTargetPlatform == TargetPlatform.android ? 440 : 468,
      width: MediaQuery.of(context).size.width - 80,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 28),
      child: ListView(
        children: [
          EditText(
            prefixIcon: const Icon(Icons.email_outlined),
            margin: const EdgeInsets.only(top: 58, bottom: 10),
            textHint: t.email,
            fontSize: 14,
            textEditingController: emailController,
            onSubmitted: (str) => signIn(),
            onChanged: (str) {
              var trimmed = str.trim();

              error.value = '';
              email.value = trimmed;
              emailController.value = TextEditingValue(
                text: trimmed,
                selection: TextSelection.collapsed(
                  offset: trimmed.length,
                ),
              );
            },
          ),
          EditText(
            prefixIcon: const Icon(Icons.lock_outline),
            isSecret: true,
            margin: const EdgeInsets.only(bottom: 6),
            textHint: t.password,
            fontSize: 14,
            textEditingController: passwordController,
            errorText: error.value,
            onSubmitted: (str) => signIn(),
            onChanged: (str) {
              var trimmed = str.trim();

              error.value = '';
              password.value = trimmed;
              passwordController.value = TextEditingValue(
                text: trimmed,
                selection: TextSelection.collapsed(
                  offset: trimmed.length,
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => alertDialog.findPw(context),
                child: Text(
                  t.forgotPassword,
                  style: Body2TextStyle().merge(
                    TextStyle(
                      color: AppColors.text.link,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Text(
                ' ${t.or} ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.text.placeholder,
                ),
              ),
              TextButton(
                onPressed: () => alertDialog.signUp(context),
                child: Text(
                  t.register,
                  style: Body2TextStyle().merge(
                    TextStyle(
                      color: AppColors.text.link,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Button(
            loading: loadingEmail.value,
            disabled: email.value.isEmpty ||
                !Validator.instance.validateEmail(email.value) ||
                password.value.isEmpty,
            margin: const EdgeInsets.only(top: 40, bottom: 12),
            text: t.signIn,
            backgroundColor: AppColors.role.primary,
            textStyle: TextStyle(color: AppColors.text.contrast),
            onPress: signIn,
          ),
          Button(
            loading: loadingGoogle.value,
            backgroundColor: StaticColors.googleBg,
            textStyle: const TextStyle(color: Colors.black),
            borderWidth: 1,
            borderColor: AppColors.bg.border,
            leftWidget: Image(
              image: Assets.icGoogle,
              width: 24,
              height: 24,
            ),
            text: t.signInWithGoogle,
            onPress: signInWithGoogle,
          ),
          // Apple sign in is not supported on Android
          // https://github.com/firebase/flutterfire/issues/2691
          defaultTargetPlatform == TargetPlatform.android
              ? const SizedBox()
              : Button(
                  margin: const EdgeInsets.only(top: 12, bottom: 40),
                  loading: loadingGoogle.value,
                  backgroundColor: Colors.black,
                  textStyle: const TextStyle(color: Colors.white),
                  borderWidth: 1,
                  borderColor: AppColors.bg.border,
                  leftWidget: const Icon(Icons.apple, color: Colors.white),
                  text: t.signInWithApple,
                  onPress: signInWithApple,
                ),
        ],
      ),
    );
  }
}
