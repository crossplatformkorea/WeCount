import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/button.dart';
import '../../widgets/edit_text.dart';
import '../colors.dart';
import '../localization.dart';
import '../snackbar.dart';
import '../validator.dart';

class FindPwContent extends HookWidget {
  const FindPwContent({super.key});

  @override
  Widget build(BuildContext context) {
    var t = localization(context);
    var emailController = useTextEditingController();
    var email = useState('');
    var loading = useState(false);

    Future<void> sendLinkToEmail() async {
      loading.value = true;

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email.value,
        );
      } finally {
        if (context.mounted) {
          loading.value = false;
          snackbar.alert(context, t.passwordResetEmailSent,
              duration: const Duration(seconds: 3),
              backgroundColor: AppColors.role.primary,
              textStyle: TextStyle(color: AppColors.text.contrast));
          context.canPop() ? context.pop() : null;
        }
      }
    }

    return Container(
      height: 280,
      width: MediaQuery.of(context).size.width - 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: ListView(
        children: [
          EditText(
            label: t.email,
            textEditingController: emailController,
            prefixIcon: const Icon(Icons.email_outlined),
            margin: const EdgeInsets.only(top: 58, bottom: 10),
            textHint: 'youremail@email.com',
            fontSize: 14,
            onChanged: (str) {
              var trimmed = str.trim();

              email.value = trimmed;
              emailController.value = TextEditingValue(
                text: trimmed,
                selection: TextSelection.collapsed(
                  offset: trimmed.length,
                ),
              );
            },
          ),
          Button(
            loading: loading.value,
            disabled: email.value.isEmpty ||
                !Validator.instance.validateEmail(email.value),
            margin: const EdgeInsets.only(top: 40, bottom: 12),
            text: t.findPw,
            backgroundColor: AppColors.role.primary,
            textStyle: TextStyle(color: AppColors.text.contrast),
            onPress: sendLinkToEmail,
          ),
        ],
      ),
    );
  }
}
