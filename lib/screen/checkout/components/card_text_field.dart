import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  const CardTextField({
    super.key,
    this.title = '',
    this.bold = false,
    this.hint = '',
    this.textInputType = TextInputType.text,
    this.inputFormatters = const [],
    this.validator,
    this.maxLength = 0,
    this.textAlign = TextAlign.start,
    required this.focusNode,
    required this.onSubmitted, required this.onSaved,
  }) : textInputAction =
            onSubmitted == null ? TextInputAction.done : TextInputAction.next;

  final String title, hint;
  final bool bold;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator? validator;
  final int maxLength;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final Function(String)? onSubmitted;
  final TextInputAction textInputAction;
  final FormFieldSetter<String> onSaved;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
        initialValue: '',
        validator: validator,
        onSaved: onSaved,
        builder: (state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      if (state.hasError)
                        const Text(
                          '   Inválido',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                TextFormField(
                  style: TextStyle(
                      color: title.isEmpty && state.hasError
                          ? Colors.red
                          : Colors.white,
                      fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                      fontSize: 18),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: title.isEmpty && state.hasError
                          ? Colors.red
                          : Colors.white.withAlpha(100),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                    counterText: '',
                  ),
                  keyboardType: textInputType,
                  inputFormatters: inputFormatters,
                  onChanged: (text) {
                    state.didChange(text);
                  },
                  maxLength: maxLength == 0 ? null : maxLength,
                  textAlign: textAlign,
                  cursorColor: Colors.white,
                  focusNode: focusNode,
                  onFieldSubmitted: onSubmitted,
                  textInputAction: textInputAction,
                ),
              ],
            ),
          );
        });
  }
}
