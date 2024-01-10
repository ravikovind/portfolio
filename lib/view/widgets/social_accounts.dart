import 'package:flutter/material.dart';
import 'package:me/core/utils/contants.dart';
import 'package:me/core/utils/ui_helpers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialAccounts extends StatelessWidget {
  final MainAxisAlignment alignment;
  const SocialAccounts({super.key, this.alignment = MainAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: alignment, children: [
        IconButton(
            onPressed: () {
              launchURL(
                context,
                'tel://$kPhone',
              );
            },
            icon: const Icon(
              FontAwesomeIcons.phone,
            )),
        IconButton(
            onPressed: () {
              launchURL(context, kGithub);
            },
            icon: const Icon(
              FontAwesomeIcons.github,
            )),
        IconButton(
            onPressed: () {
              launchURL(context, kLinkedIn);
            },
            icon: const Icon(
              FontAwesomeIcons.linkedin,
            )),
        IconButton(
            onPressed: () {
              launchURL(context, kInstagram);
            },
            icon: const Icon(
              FontAwesomeIcons.instagram,
            )),
      ]),
    );
  }
}
