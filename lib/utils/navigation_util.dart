import 'package:flutter/material.dart';

Future<void> navigateNext(BuildContext context, Widget screen) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

void navigatePop(BuildContext context) => Navigator.pop(
      context,
    );
