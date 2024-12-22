import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextWithActionWidget extends StatefulWidget{

  final TextEditingController controllerField;
  final Function? action;
  final double sizeContainerTop;
  final double sizeContainerBottom;
  final double sizeContainerLeft;
  final double sizeContainerRigth;
  final String hintTextField;
  final Icon? iconButton;
  final String typeValidate;
  final List<dynamic>? emailsUserLogged;

  const TextWithActionWidget(
      {Key? key,
        required this.controllerField,
        this.action,
        required this.sizeContainerTop,
        required this.sizeContainerBottom,
        required this.sizeContainerLeft,
        required this.sizeContainerRigth,
        required this.hintTextField,
        this.iconButton,
        required this.typeValidate,
        this.emailsUserLogged
      }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextWithActionWidgetState();
  }

}

class TextWithActionWidgetState extends State<TextWithActionWidget>{

  final maskCpf = MaskTextInputFormatter(mask: "###.###.###-##", type: MaskAutoCompletionType.eager);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onChanged: (value) {
            widget.controllerField.value =
                TextEditingValue(
                    text: value.trim(),
                    selection: widget.controllerField.selection,
                );
          },
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: widget.typeValidate == "password" ? true : false,
          // inputFormatters: widget.typeValidate == 'cpf' ? [maskCpf] : [],
          controller: widget.controllerField..text,
          decoration: InputDecoration(
              hintText: widget.hintTextField,
              hintStyle: const TextStyle(color: Colors.grey),
              // hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.grey3, fontSize: 14),
              labelStyle: const TextStyle(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
              // suffixIcon: ElevatedButton(
              //   onPressed: (){
              //     widget.action();
              //   },
              //   style: ButtonStyle(
              //     shape: MaterialStateProperty.all(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(16.0),
              //       ),
              //     ),
              //     padding: MaterialStateProperty.all(
              //       EdgeInsets.only(
              //         top: widget.sizeContainerTop,
              //         bottom: widget.sizeContainerBottom,
              //         left: widget.sizeContainerLeft,
              //         right: widget.sizeContainerRigth,
              //       ),
              //     ),
              //     backgroundColor: MaterialStateProperty.all(Colors.black),
              //   ),
              //   child: widget.iconButton,
              // )
          ),
          keyboardType: widget.typeValidate == 'cpf' ? TextInputType.number : TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Preencha este campo';
            }
            return null;
          },
        ),
      ],
    );
  }

}