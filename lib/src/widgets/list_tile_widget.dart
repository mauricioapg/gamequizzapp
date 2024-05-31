import 'dart:ffi';

import 'package:flutter/material.dart';

class ListTileWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? locationImage;
  final Widget? trailing;
  final Function? action;
  final EdgeInsetsGeometry? padding;
  final double? titleSize;
  final Color? cardColor;
  final Color? titleColor;

  const ListTileWidget(
      {Key? key,
      required this.title,
      this.subtitle,
      this.locationImage,
      this.trailing,
      this.action,
      this.padding,
      this.titleSize,
      this.cardColor, this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 100,
          child: Card(
            color: cardColor,
            child: Center(
              child: ListTile(

                leading: locationImage != null ? Image.asset(locationImage!, width: 40) : null,
                title: Padding(
                  padding: padding != null ? padding! : EdgeInsets.zero,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: titleSize ?? 16, color: titleColor),
                  ),
                ),
                subtitle: subtitle != null ? Text(subtitle!) : null,
                onTap: () {
                  action!();
                },
              ),
            )
          ),
        ),
        // const Divider()
      ],
    );
  }
}
