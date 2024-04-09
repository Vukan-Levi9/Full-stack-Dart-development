import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/presentation/widgets/custom_snackbar.dart';
import 'package:movies_app/presentation/widgets/custom_textfield.dart';
import 'package:movies_app/routes/app_router.dart';
import 'package:movies_app_models/movies_app_models.dart';

import '../../../core/constants.dart';
import '../../../core/helpers/authentication_validator.dart';
import '../../../core/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/repository/auth_repository.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authenticationValidator = IC.getIt<AuthenticationValidator>();
  final _authRepository = IC.getIt<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(ImagesStrings.logoMovies, width: 200, height: 200),
                Text(
                  AppLocalizations.of(context)!.loginTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                AutofillGroup(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        labelText: AppLocalizations.of(context)!.emailText,
                        keyboardType: TextInputType.emailAddress,
                        disableValidation: true,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: AppLocalizations.of(context)!.passwordText,
                        obscureText: true,
                        disableValidation: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _loginUser();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ElevatedButton(
                    onPressed: () {
                      _loginUser();
                      FocusScope.of(context).unfocus();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.signInBtnText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.notMemberText,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.registerNowText,
                      ),
                      onPressed: () => Router.neglect(
                        context,
                        () => context.go(Routes.signUp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    if (_authenticationValidator.isPasswordValid(_passwordController.text) &&
        _authenticationValidator.isEmailValid(_emailController.text)) {
      final either = await _authRepository.signIn(
        User(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );

      if (either.isLeft()) {
        CustomSnackBar.showError(
          title:
              either.getLeft().fold(() => null, (error) => error)?.statusCode ==
                      400
                  ? AppLocalizations.of(context)!.loginError
                  : AppLocalizations.of(context)!.unknownError,
          context: context,
        );
      } else {
        Router.neglect(context, () => context.go(Routes.movies));
      }
    } else {
      CustomSnackBar.showError(
        title: AppLocalizations.of(context)!.loginError,
        context: context,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
