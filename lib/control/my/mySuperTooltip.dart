import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:retailapp/control/my/myColor.dart' as myColor;
import 'package:retailapp/control/my/myStyle.dart' as myStyle;


void show1(BuildContext bc, String text) {
  SuperTooltip(
      popupDirection: TooltipDirection.up,
      arrowLength: 0,
      showCloseButton: ShowCloseButton.inside,
      closeButtonSize: 16,
      closeButtonColor: myColor.color1,
      borderColor: myColor.color1,
      borderWidth: 1,
      content: Material(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 18, 8),
        child: Text(
          text,
          style: myStyle.style16Color1(),
          softWrap: true,
        ),
      )))
    ..show(bc);
}

void show4(BuildContext bc, String text) {
  SuperTooltip(
      popupDirection: TooltipDirection.up,
      arrowLength: 0,
      showCloseButton: ShowCloseButton.inside,
      closeButtonSize: 16,
      closeButtonColor: myColor.color4,
      borderColor: myColor.color4,
      borderWidth: 1,
      content: Material(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 18, 8),
        child: Text(
          text,
          style: myStyle.style16Color4(),
          softWrap: true,
        ),
      )))
    ..show(bc);
}

