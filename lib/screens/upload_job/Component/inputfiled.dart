import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final String title;
  final String hint;
  final TextEditingController? fieldController;
  final Widget? child;
  final double highet;
  final TextInputType keyboardType;

   const InputField(
      {Key? key,
        required this.title,
        required this.hint,
        this.fieldController,
        this.keyboardType = TextInputType.text,
        this.child, this.highet = 52,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.95,
            height: highet,
            padding: const EdgeInsets.only(left: 8.0),
            margin: const EdgeInsets.only(
              top: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                    obscureText: false,
                    autocorrect: false,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    controller: fieldController,
                    readOnly: child != null ? true : false,
                    maxLines: highet != 52 ? 5 : 1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: child ?? Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
