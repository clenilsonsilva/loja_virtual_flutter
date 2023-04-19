import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  const CardTextField({
    super.key,
    required this.title,
    this.bold = false,
    required this.hint,
    required this.textInputType,
    this.inputFormatters = const [],
    required this.validator,
  });

  final String title, hint;
  final bool bold;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator validator;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: '',
        validator: validator,
        builder: (state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    if(state.hasError)
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
                      color: Colors.white,
                      fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                      fontSize: 18),
                  decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                        color: Colors.white.withAlpha(100),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 2)),
                  keyboardType: textInputType,
                  inputFormatters: inputFormatters,
                  onChanged: (text) {
                    state.didChange(text);
                  },
                )
              ],
            ),
          );
        });
  }
}
