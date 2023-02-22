import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'colors.dart';

abstract class ConstantWidget {
  static Center loading(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.twoRotatingArc(
        color: tabColor,
        size: 43,
      ),
    );
  }

  static void massage({
    required BuildContext context,
    required String text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        dismissDirection: DismissDirection.endToStart,
      ),
    );
  }

  static void dialog(
      {required BuildContext context,
      required Widget title,
      required Widget content,
      List<Widget>? action,
      Color? color}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: color ?? Colors.white,
          actions: action ?? [],
          title: title,
          content: content,
        );
      },
    );
  }

  static void bottomSheet(
    BuildContext context, {
    required double size,
    required Widget widget,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: size,
          decoration: const BoxDecoration(
            color: appBarColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: widget,
        );
      },
    );
  }
}
