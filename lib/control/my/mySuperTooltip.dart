import 'package:flutter/material.dart';
import 'package:retailapp/control/my/myColor.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:retailapp/control/my/myStyle.dart';

class MySuperTooltip {
  static void show1(BuildContext bc, String text) {
    SuperTooltip(
        popupDirection: TooltipDirection.up,
        arrowLength: 0,
        showCloseButton: ShowCloseButton.inside,
        closeButtonSize: 16,
        closeButtonColor: MyColor.color1,
        borderColor: MyColor.color1,
        borderWidth: 1,
        content: Material(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 18, 8),
          child: Text(
            text,
            style: MyStyle.style16Color1(),
            softWrap: true,
          ),
        )))
      ..show(bc);
  }

  static void show4(BuildContext bc, String text) {
    SuperTooltip(
        popupDirection: TooltipDirection.up,
        arrowLength: 0,
        showCloseButton: ShowCloseButton.inside,
        closeButtonSize: 16,
        closeButtonColor: MyColor.color4,
        borderColor: MyColor.color4,
        borderWidth: 1,
        content: Material(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 18, 8),
          child: Text(
            text,
            style: MyStyle.style16Color4(),
            softWrap: true,
          ),
        )))
      ..show(bc);
  }
}
