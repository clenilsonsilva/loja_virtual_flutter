import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      required this.iconData,
      required this.color,
      required this.ontap});

  final IconData iconData;
  final Color color;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: ontap,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              iconData,
              color: ontap != null ? color : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}
