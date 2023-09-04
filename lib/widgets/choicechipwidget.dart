import 'package:flutter/material.dart';
class ChoiceChipsWid extends StatefulWidget {
  const ChoiceChipsWid({super.key, required this.titleText, this.fontsize});
  final String titleText;
  final double? fontsize;
  @override
  State<ChoiceChipsWid> createState() => _ChoiceChipsWidState();
}

class _ChoiceChipsWidState extends State<ChoiceChipsWid> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
      selectedColor: Color.fromRGBO(176, 32, 102, 0.451),
      label: Container(
          margin: EdgeInsets.only(left: 1, right: 1),
          height: 40,
          width: 60,
          child: Row(
            children: [
            
              Text(
                widget.titleText,
                style: TextStyle(
                    fontSize: widget.fontsize ?? 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          alignment: Alignment.center),
      selected: isSelected,
      onSelected: (NewBoolValue) {
        setState(() {
          isSelected = NewBoolValue;
        });
     },
);
}
}