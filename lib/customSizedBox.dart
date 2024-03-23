import 'package:flutter/material.dart';

class H extends StatelessWidget {
  final double height;

  const H(this.height, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => SizedBox(height: height);
}

class W extends StatelessWidget {
  final double width;

  const W(this.width, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => SizedBox(width: width);
}
