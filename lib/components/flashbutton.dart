import 'package:flutter/material.dart';

class flash_button extends StatelessWidget {
  const flash_button(
      {super.key,
      this.colorr,
    
      this.onPressed,
      this.title,
      
      
     });

  final Color? colorr;
  final String? title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colorr,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
