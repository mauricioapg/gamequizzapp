
import 'package:flutter/cupertino.dart';

class CustomLayout {

  static Padding columnSpacer(double height){
    Padding padding = Padding(padding: EdgeInsets.only(top: height));
    return padding;
  }

  static const Padding vpad_8 = Padding(padding: EdgeInsets.only(top: 8));
  static const Padding vpad_16 = Padding(padding: EdgeInsets.only(top: 16));
  static const Padding vpad_24 = Padding(padding: EdgeInsets.only(top: 24));
  static const Padding vpad_32 = Padding(padding: EdgeInsets.only(top: 32));
  static const Padding vpad_48 = Padding(padding: EdgeInsets.only(top: 48));
}
