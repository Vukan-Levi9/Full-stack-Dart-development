class AuthenticationValidator {
  bool isEmailValid(String? value) =>
      value != null &&
      RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(value) &&
      !value.contains(' ');

  bool isPasswordValid(String? value) =>
      value != null &&
      RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\W]{8,}$',
      ).hasMatch(value) &&
      !value.contains(' ');

  bool isFirstNameAndLastNameValid(String? value) =>
      value != null && value.length > 4;
}
