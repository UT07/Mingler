
import 'package:flutter/cupertino.dart';

Widget iconWidget(icon, onTap, size, color){
  return GestureDetector(
    onTap: onTap,
    child: Icon(
      icon,
      size: size,
      color: color,
    )
  );
}