import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamequizzapp/src/constants/custom_layout.dart';

class DialogMessageWidget extends StatelessWidget {
  final String title;
  final String content;
  final String image;
  final String textButton;
  final Function? functionSecond;
  final Function? functionFirst;
  final double? contentHeight;
  final bool? popUp;
  final bool? secondButton;
  final String? textFirstButton;
  final BoxConstraints? constraints;

  const DialogMessageWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.image,
    required this.textButton,
    this.functionSecond,
    this.functionFirst,
    this.contentHeight,
    this.popUp,
    this.secondButton,
    this.textFirstButton,
    this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomLayout.vpad_32,
            popUp != true ?
            SizedBox(
                height: 80,
                child: Image.asset(image)
            ) : Container(),
            CustomLayout.vpad_16,
            popUp != true ?
            SizedBox(
              height: 40,
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 25)),
            ) : SizedBox(
              height: 60,
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.center),
            ),
            CustomLayout.vpad_24,
            SizedBox(
              height: contentHeight ?? 40,
              child: Text(content, textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 16)),
            ),
          ],
        ),
        actions: [
          secondButton == true ?
          Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    functionFirst!();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        // side: const BorderSide(color: Colors.yellow),
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.only(
                        top: constraints!.maxHeight * 0.02,
                        bottom: constraints!.maxHeight * 0.02,
                        left: constraints!.maxWidth * 0.1,
                        right: constraints!.maxWidth * 0.1,
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Text(
                    textFirstButton!,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
              ),
              // CustomLayout.columnSpacer(constraints!.maxHeight * 0.02),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    functionSecond!();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.only(
                      top: constraints!.maxHeight * 0.02,
                      bottom: constraints!.maxHeight * 0.02,
                      left: constraints!.maxWidth * 0.22,
                      right: constraints!.maxWidth * 0.22,
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ) :
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                functionSecond!();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                padding: MaterialStateProperty.all(const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 70, right: 70)),
                backgroundColor: MaterialStateProperty.all(Colors.black),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          CustomLayout.vpad_32,
        ],
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      ),
    );
  }
}
