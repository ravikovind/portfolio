import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showMessage(
  BuildContext context,
  String title,
  String message, [
  void Function()? onPressed,
]) async => await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actions: <Widget>[
        ElevatedButton(
          onPressed: onPressed ??
              () {
                Navigator.of(context).pop();
              },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56.0),
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Text(
            'Okay!',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        )
      ],
    ),
  );

void launchURL(BuildContext context, String url) async {
  try {
    await launchUrl(
      Uri.parse(url),
    );
  } on Exception catch (_) {
    rethrow;
  }
}
