import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed, {
    bool isConfirmationDialog = false,
    String buttonText2 = "",
    Function onPressed2,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: [
              new FlatButton(
                onPressed: () {
                  return onPressed();
                },
                child: new Text(
                  buttonText,
                ),
              ),
              Visibility(
                visible: isConfirmationDialog,
                child: new FlatButton(
                  onPressed: () {
                    return onPressed2();
                  },
                  child: new Text(buttonText2),
                ),
              )
            ],
          );
        });
  }
}
