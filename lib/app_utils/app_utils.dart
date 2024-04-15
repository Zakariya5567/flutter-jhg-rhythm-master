import 'package:flutter/material.dart';
import 'package:flutter_jhg_elements/jhg_elements.dart';

class AppUtils {
  AppUtils._();
  static void showPopup(
    BuildContext context,
    String chordName,
    String details,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            useMaterial3: false,
            // Set the background color of the AlertDialog
            dialogBackgroundColor: JHGColors.charcolGray,
            // Set the text color
          ),
          child: Container(
            height: 100,
            width: 100,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20.0), // Set circular border radius for content
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(chordName,
                      style: JHGTextStyles.lrlabelStyle.copyWith(
                          fontSize: 21)),
                  JHGIconButton(
                    iconData: Icons.close,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: Container(
                width: 100,
                child: Text(
                  details,
                  style: JHGTextStyles.bodyStyle.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
