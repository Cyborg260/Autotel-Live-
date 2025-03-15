import 'package:flutter/material.dart';
import 'package:trackerapp/res/colors.dart';

class SubmitButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPresse;
  const SubmitButton(
      {super.key,
      required this.title,
      this.loading = false,
      required this.onPresse});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPresse,
      color: AppColors.buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Color(0xff808080),
          width: 0,
        ),
      ),
      padding: const EdgeInsets.all(16),
      textColor: const Color(0xff000000),
      height: 40,
      minWidth: MediaQuery.of(context).size.width,
      elevation: 0,
      child: loading
          ? const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ),
    );
  }
}
