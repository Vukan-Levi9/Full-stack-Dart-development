import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.disableValidation = false,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool disableValidation;
  final void Function(String _)? onFieldSubmitted;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
          child: TextFormField(
            onFieldSubmitted: widget.onFieldSubmitted,
            maxLines: 1,
            textInputAction: widget.textInputAction,
            controller: widget.controller,
            obscureText: widget.obscureText,
            autovalidateMode: !widget.disableValidation
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            validator: widget.validator,
            autofillHints: widget.disableValidation
                ? widget.keyboardType == TextInputType.emailAddress
                    ? const [AutofillHints.email]
                    : const [AutofillHints.password]
                : null,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.digitsOnly]
                : null,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 10),
              errorStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.red, fontWeight: FontWeight.w500),
              border: InputBorder.none,
              labelText: widget.labelText,
              errorMaxLines: 3,
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
