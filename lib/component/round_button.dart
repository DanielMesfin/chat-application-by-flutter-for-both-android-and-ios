import 'package:flutter/material.dart';
class ResueMatterialButton extends StatelessWidget {
  Color colorInput;
  Function()? onPressInput;
  String textLabel;
  ResueMatterialButton({this.onPressInput,required this.colorInput,required this.textLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colorInput,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressInput,
          minWidth: 200.0,
          height: 40.0,
          child: Text(
              textLabel,
            style: TextStyle(
                color:Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
