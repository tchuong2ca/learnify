
import 'package:flutter/material.dart';
import 'package:online_learning/common/functions.dart';


class ToggleButton extends StatefulWidget {
  final String? startText;
  final String? endText;
  final ValueChanged? tapCallback;
  int? index;
   ToggleButton(
  { this.startText,
    this.endText,
    this.tapCallback,
    this.index});

  @override
  _ToggleButtonState createState() => _ToggleButtonState(this.index);
}

class _ToggleButtonState extends State<ToggleButton> {
  int? index;
  _ToggleButtonState(this.index);
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              index = index == 0 ? 1 : 0;
            });
            widget.tapCallback!(index);
          },
          child: Container(
            width: width * 0.7,
            height: height * 0.06,
            decoration: ShapeDecoration(
              color: const Color(0x33FFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.036),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildText(
                  text: widget.startText!,
                  color: const Color(0xFFFFFFFF),
                ),
                buildText(
                  text: widget.endText!,
                  color: const Color(0xFFFFFFFF),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCirc,
          width: width * 0.7,
          alignment:
          index == 0 ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            alignment: Alignment.center,
            width: width * 0.35,
            height: height * 0.06,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.036),
              ),
              color: const Color(0xFFFFFFFF),
            ),
            child: buildText(
              text: index == 0 ? widget.startText! : widget.endText!,
            ),
          ),
        ),
      ],
    );
  }

  Text buildText({String? text, Color color = const Color(0xFF000000)}) {
    return Text(
      text!,
      style: TextStyle(
        fontSize: getWidthDevice(context) * 0.04,
        color: color,
        fontWeight: FontWeight.bold,
        fontFamily: 'Varela',
      ),
    );
  }
}
