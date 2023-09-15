import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

navigatePush(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

navigatePushReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

navigatePushRemoveUntil(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false);
}

navigatePushReplacementNamed(BuildContext context, String routeName) {
  Navigator.of(context).pushReplacementNamed(routeName);
}

navigatePop(
  BuildContext context,
) {
  Navigator.pop(context);
}

Color getStatusColour(String status) {
  if (status == 'submitted') {
    return CupertinoColors.systemPink;
  } else if (status == 'in_progress') {
    return CupertinoColors.systemOrange;
  } else if (status == 'completed') {
    return CupertinoColors.activeGreen;
  } else if (status == 'assigned') {
    return CupertinoColors.systemYellow;
  } else if (status == 'reassigned') {
    return Colors.red;
  } else if (status == 'approved') {
    return Colors.blueAccent;
  }
  return CupertinoColors.black;
}

String prettyJson(dynamic json) {
  var spaces = ' ' * 4;
  var encoder = JsonEncoder.withIndent(spaces);
  return encoder.convert(json);
}

SnackBar getSnackbar(Color backgroundColor, String text) {
  return SnackBar(
    backgroundColor: backgroundColor,
    content: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
