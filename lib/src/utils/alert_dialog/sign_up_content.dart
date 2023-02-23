import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/button.dart';
import '../../widgets/check_box.dart';
import '../../widgets/edit_text.dart';
import '../colors.dart';
import '../general.dart';
import '../localization.dart';
import '../snackbar.dart';
import '../styles.dart';
import '../tools.dart';
import '../validator.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUpContent extends HookWidget {
  const SignUpContent({super.key});

  @override
  Widget build(BuildContext context) {
    var t = localization(context);
    var loading = useState(false);
    var checkState = useState(false);
    var emailController = useTextEditingController();
    var displayNameController = useTextEditingController();
    var passwordController = useTextEditingController();
    var passwordConfirmController = useTextEditingController();
    var disableButton = useState(true);

    void checkButtonToDisable() {
      disableButton.value = emailController.text.isEmpty ||
          !Validator.instance.validateEmail(emailController.text) ||
          passwordController.text.isEmpty ||
          !Validator.instance.validatePassword(passwordController.text) ||
          passwordController.text != passwordConfirmController.text ||
          displayNameController.text.isEmpty ||
          !checkState.value;
    }

    void register() async {
      loading.value = true;

      try {
        var created = (await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        ))
            .user;

        if (context.mounted && created != null) {
          await created.updateDisplayName(displayNameController.text);
          await created.sendEmailVerification();
        }
      } catch (e) {
        logger.e(e);
      } finally {
        if (context.mounted) {
          unawaited(FirebaseAuth.instance.signOut());
          snackbar.alert(context, t.thanksForSigningUp,
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.role.primary,
              textStyle: TextStyle(color: AppColors.text.contrast));
          loading.value = false;
          // Pop twice
          context.canPop() ? context.pop() : null;
          context.canPop() ? context.pop() : null;
        }
      }
    }

    return Container(
      height: 600,
      width: MediaQuery.of(context).size.width - 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: ListView(
        children: [
          EditFormText(
            prefixIcon: const Icon(Icons.email_outlined),
            margin: const EdgeInsets.only(top: 48, bottom: 12),
            label: t.email,
            textHint: 'youremail@email.com',
            textEditingController: emailController,
            onChanged: (str) {
              var trimmed = str.trim();

              emailController.value = TextEditingValue(
                text: trimmed,
                selection: TextSelection.collapsed(
                  offset: trimmed.length,
                ),
              );

              checkButtonToDisable();
            },
            fontSize: 14,
          ),
          EditFormText(
            prefixIcon: const Icon(Icons.person_outline),
            margin: const EdgeInsets.only(bottom: 12),
            label: t.displayName,
            textHint: t.displayNameHint,
            textEditingController: displayNameController,
            onChanged: (str) {
              var trimmed = str.trim();

              displayNameController.value = TextEditingValue(
                text: trimmed,
                selection: TextSelection.collapsed(
                  offset: trimmed.length,
                ),
              );

              checkButtonToDisable();
            },
            fontSize: 14,
          ),
          EditFormText(
            prefixIcon: const Icon(Icons.lock_outline),
            isSecret: true,
            margin: const EdgeInsets.only(bottom: 12),
            label: t.password,
            textHint: t.passwordHint,
            textEditingController: passwordController,
            onChanged: (str) {
              var trimmed = str.trim();

              passwordController.value = TextEditingValue(
                text: trimmed,
                selection: TextSelection.collapsed(
                  offset: trimmed.length,
                ),
              );

              checkButtonToDisable();
            },
            fontSize: 14,
          ),
          EditFormText(
            prefixIcon: const Icon(Icons.lock_rounded),
            isSecret: true,
            margin: const EdgeInsets.only(bottom: 12),
            label: t.passwordConfirm,
            textHint: t.passwordConfirmHint,
            textEditingController: passwordConfirmController,
            onChanged: (str) {
              var trimmed = str.trim();

              passwordConfirmController.value = TextEditingValue(
                text: trimmed,
                selection: TextSelection.collapsed(
                  offset: trimmed.length,
                ),
              );

              checkButtonToDisable();
            },
            fontSize: 14,
          ),
          CheckBox(
            onChecked: (checked) {
              checkState.value = checked ?? false;
              checkButtonToDisable();
            },
            checked: checkState.value,
            rightWidget: RichText(
              text: TextSpan(
                text: '${t.termsOfAgreements1} ',
                style: Body3TextStyle().merge(TextStyle(
                  color: AppColors.text.placeholder,
                )),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => General.instance.launchURL(
                          'https://legacy.dooboolab.com/termsofservice'),
                    text: t.termsOfUse,
                    style: TextStyle(
                      color: AppColors.text.link,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: t.termsOfAgreements2,
                    style: Body3TextStyle().merge(
                      TextStyle(
                        color: AppColors.text.placeholder,
                      ),
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => General.instance.launchURL(
                          'https://legacy.dooboolab.com/privacyandpolicy'),
                    text: t.privacyAndPolicy,
                    style: TextStyle(
                      color: AppColors.text.link,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: t.termsOfAgreements3,
                    style: Body3TextStyle().merge(TextStyle(
                      color: AppColors.text.placeholder,
                    )),
                  ),
                ],
              ),
            ),
          ),
          Button(
            loading: loading.value,
            disabled: disableButton.value,
            margin: const EdgeInsets.only(top: 40, bottom: 12),
            text: t.register,
            backgroundColor: AppColors.role.primary,
            textStyle: TextStyle(color: AppColors.text.contrast),
            onPress: register,
          ),
        ],
      ),
    );
  }
}
