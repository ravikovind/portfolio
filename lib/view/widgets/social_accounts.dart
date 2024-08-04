import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:me/core/utils/contants.dart';
import 'package:me/core/utils/ui_helpers.dart';

class SocialAccounts extends StatelessWidget {
  final MainAxisAlignment alignment;
  const SocialAccounts({super.key, this.alignment = MainAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: alignment, children: [
        IconButton.outlined(
            onPressed: () => launchURL(
                  context,
                  'tel://$kPhone',
                ),
            icon: Icon(
              LucideIcons.phone_call,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            )),
        const SizedBox(width: 4),
        IconButton.outlined(
            onPressed: () => launchURL(context, kGithub),
            icon: Icon(
              LucideIcons.github,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            )),
        const SizedBox(width: 4),
        IconButton.outlined(
            onPressed: () => launchURL(context, kLinkedIn),
            icon: Icon(
              LucideIcons.linkedin,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            )),
        const SizedBox(width: 4),
        IconButton.outlined(
            onPressed: () => launchURL(context, kInstagram),
            icon: Icon(
              LucideIcons.instagram,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            )),
        const SizedBox(width: 4),
      ]),
    );
  }
}
