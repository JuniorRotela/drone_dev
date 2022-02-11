import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final double size;
  const IconContainer({Key key, this.size})
      : assert(size != null && size > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(this.size * 0.90),
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      padding: EdgeInsets.all(this.size * 0.0),
      child: Center(
        child: Image.asset(
          'assets/chem.png',
          width: this.size * 0.90,
          height: this.size * 0.90,
        ),
      ),
    );
  }
}
