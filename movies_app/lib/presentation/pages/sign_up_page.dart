import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/helpers/authentication_validator.dart';
import 'package:movies_app/domain/repository/auth_repository.dart';
import 'package:movies_app/domain/repository/counter_repository.dart';
import 'package:movies_app/presentation/widgets/custom_snackbar.dart';
import 'package:movies_app/presentation/widgets/custom_textfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movies_app/routes/app_router.dart';
import 'package:movies_app_models/movies_app_models.dart';

import '../../core/constants.dart';

import '../../core/injection_container.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _firstAndLastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authenticationValidator = IC.getIt<AuthenticationValidator>();
  final _authRepository = IC.getIt<AuthRepository>();
  final _counterRepository = IC.getIt<CounterRepository>()..connect();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImagesStrings.logoMovies, width: 200, height: 200),
                Text(
                  AppLocalizations.of(context)!.registerTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _firstAndLastNameController,
                        labelText:
                            AppLocalizations.of(context)!.firstAndLastNameText,
                        validator: (value) => !_authenticationValidator
                                .isFirstNameAndLastNameValid(value)
                            ? AppLocalizations.of(context)!
                                .firstAndLastNameTextWarning
                            : null,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        labelText: AppLocalizations.of(context)!.emailText,
                        validator: (value) =>
                            !_authenticationValidator.isEmailValid(value)
                                ? AppLocalizations.of(context)!.emailTextWarning
                                : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: AppLocalizations.of(context)!.passwordText,
                        obscureText: true,
                        validator: (value) =>
                            !_authenticationValidator.isPasswordValid(value)
                                ? AppLocalizations.of(context)!
                                    .passwordTextWarningSignUp
                                : null,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          _registerUser();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(width: 10),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 450),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _registerUser();
                            FocusScope.of(context).unfocus();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.signUpBtnText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.memberText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              child: Text(
                                AppLocalizations.of(context)!.loginNowText,
                              ),
                              onPressed: () => Router.neglect(
                                context,
                                () => context.go(Routes.signIn),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final either = await _authRepository.signUp(
        User(
          password: _passwordController.text.trim(),
          email: _emailController.text.trim(),
          name: _firstAndLastNameController.text.trim(),
        ),
      );

      if (either.isLeft()) {
        CustomSnackBar.showError(
          title:
              either.getLeft().fold(() => null, (error) => error)?.statusCode ==
                      400
                  ? AppLocalizations.of(context)!.signUpEmailException
                  : AppLocalizations.of(context)!.unknownError,
          context: context,
        );
      } else {
        _counterRepository.increment();
        Router.neglect(context, () => context.go(Routes.signIn));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstAndLastNameController.dispose();
    _counterRepository.close();
    super.dispose();
  }
}
