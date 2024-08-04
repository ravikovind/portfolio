import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:lottie/lottie.dart';
import 'package:me/bloc/message/message_cubit.dart';
import 'package:me/bloc/project/project_cubit.dart';
import 'package:me/bloc/theme/theme_bloc.dart';
import 'package:me/data/models/message.dart';
import 'package:me/core/utils/contants.dart';
import 'package:me/core/utils/responsive.dart';
import 'package:me/core/utils/ui_helpers.dart';
import 'package:me/view/widgets/loading.dart';
import 'package:me/view/widgets/social_accounts.dart';
import 'package:me/view/widgets/text_animator.dart';
import 'package:string_contains/string_contains.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      context.read<MessageCubit>().sendMessage(
            Message(
              name: 'Unkown',
              email: 'Unkown',
              message: 'Unkown',
              dateTime: DateTime.now().toIso8601String(),
            ),
          );
    });
  }

  Future<void> welcome(BuildContext context) async => showModalBottomSheet(
        context: context,
        builder: (context) => Form(
          key: _formKey,
          child: BlocConsumer<MessageCubit, MessageState>(
            listener: (context, state) {
              if (state is MessageSent) {
                Navigator.of(context).pop();
                showMessage(context, 'Success!', state.message);
              } else if (state is MessageError) {
                Navigator.of(context).pop();
                showMessage(context, 'Error!', state.message);
              }
            },
            builder: (context, state) {
              if (state is MessageSending) {
                return const Loading();
              }
              return SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Column(
                    children: [
                      ListTile(
                          title: Text(
                            'Hey There! Welcome!',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          trailing: IconButton(
                            icon: const Icon(LucideIcons.circle_x),
                            onPressed: () => Navigator.of(context).pop(),
                          )),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (input) =>
                            input?.isEmpty == true || (input?.length ?? 0) < 3
                                ? 'Please enter your name!'
                                : null,
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (input) => input.containsEmail()
                            ? null
                            : 'Please enter valid email!',
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your message',
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            context.read<MessageCubit>().sendMessage(
                                  Message(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    message: _messageController.text,
                                    dateTime: DateTime.now().toIso8601String(),
                                  ),
                                );
                            return setState(() {
                              _nameController.clear();
                              _emailController.clear();
                            });
                          }
                          return showMessage(
                            context,
                            'Error!',
                            'Please enter valid details!',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56.0),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mobile = compact(context);
    final desktop = expanded(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton.filledTonal(
            icon: const Icon(LucideIcons.info),
            onPressed: () => showAboutDialog(
              context: context,
              applicationName: 'Portfolio',
              applicationVersion: '2.0.0',
              applicationIcon: const FlutterLogo(),
              applicationLegalese: 'Ravi Kovind © ${DateTime.now().year}',
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text('About'),
                  subtitle: const Text(
                    'This is a simple Portfolio web application made with Flutter & GSheet.',
                  ),
                  leading: const Icon(LucideIcons.github),
                  trailing: const Icon(LucideIcons.external_link),
                  onTap: () {
                    launchURL(
                      context,
                      'https://github.com/ravikovind/portfolio',
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 4.0),
          IconButton.filledTonal(
            icon: const Icon(LucideIcons.mail),
            onPressed: () {
              welcome(context);
            },
          ),
          const SizedBox(width: 4.0),
          IconButton.filledTonal(
            icon: const Icon(LucideIcons.sun),
            onPressed: () => context.read<ThemeBloc>().add(const ToggleTheme()),
          ),
          const SizedBox(width: 4.0),
        ],
      ),
      body: RawScrollbar(
        thickness: 16,
        interactive: true,
        thumbVisibility: true,
        trackVisibility: true,
        radius: const Radius.circular(2.0),
        thumbColor: Theme.of(context).colorScheme.onPrimaryContainer,
        child: ListView(
          primary: true,
          children: [
            Stack(
              children: [
                desktop
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Lottie.asset(
                          'assets/animations/json_2.json',
                          fit: BoxFit.contain,
                          reverse: true,
                          height: MediaQuery.of(context).size.width * 0.325,
                        ),
                      )
                    : const SizedBox.shrink(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      Text(
                        'Hey There! I am ',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.4,
                                  wordSpacing: 2.4,
                                ),
                      ),
                      Text(
                        'Ravi Kovind',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: mobile ? 48.0 : 72.0,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Lead Developer || Open Source Contributor || NIT Allahabad Alumnus',
                            textStyle: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            speed: const Duration(milliseconds: 60),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      const SocialAccounts(
                        alignment: MainAxisAlignment.start,
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      Text(
                        'Unleashing Limitless Potential:\nExpertly Crafting Cutting-Edge\nCross-Platform Applications,\nExceptional Websites,\nand Everything in Between\nand Redefining Digital Excellence.\nThat\'s what I do.',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          side: BorderSide(
                            width: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () => launchURL(context, 'mailto:$kEmail'),
                        icon: const Icon(
                          LucideIcons.mail,
                        ),
                        label: Text(
                          'Get In Touch',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontSize: mobile ? 16.0 : 24.0,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    kAbout,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
            BlocConsumer<ProjectCubit, ProjectState>(
              listener: (context, state) {
                if (state is ProjectError) {
                  showMessage(
                    context,
                    'Error!',
                    state.message,
                  );
                }
              },
              builder: (context, state) {
                if (state is ProjectLoading) {
                  return const Loading(
                    eventMessage: 'Loading Projects...',
                  );
                } else if (state is ProjectLoaded) {
                  final projects = state.projects;
                  if (projects.isEmpty) return const SizedBox.shrink();
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Projects\n',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            children: [
                              TextSpan(
                                text:
                                    'A few things I\'ve built(it\'s my personal work. community contribution and fun stuff)',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        ListView.builder(
                          itemCount: projects.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            final webUrl = project.webUrl.notNullValue;
                            final appUrl = project.appUrl.notNullValue;
                            return ExpansionTile(
                              title: RichText(
                                text: TextSpan(
                                  text: '${project.name}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontSize: mobile ? 16.0 : 24.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ),
                              subtitle: StringContainsWidget(
                                source: project.description ?? 'No Description',
                                linkStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                onTap: (t) {
                                  if (t.type == StringContainsElementType.url) {
                                    final value = t.value;
                                    launchURL(context, value);
                                  }
                                },
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              childrenPadding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              expandedAlignment: Alignment.topLeft,
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: [
                                    ...project.tags?.map(
                                          (tag) => Chip(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            label: Text(
                                              tag,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    letterSpacing: 2.4,
                                                    wordSpacing: 2.4,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onError,
                                                  ),
                                            ),
                                          ),
                                        ) ??
                                        [],
                                  ],
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                if (!appUrl.nullOrEmpty)
                                  ListTile(
                                    title: Text(
                                      'Try Android Application',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            fontSize: mobile ? 16.0 : 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                    ),
                                    trailing:
                                        const Icon(LucideIcons.external_link),
                                    onTap: () =>
                                        launchURL(context, '${project.appUrl}'),
                                  ),
                                if (!webUrl.nullOrEmpty)
                                  Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          webUrl,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                        ),
                                        trailing: const Icon(
                                          LucideIcons.copy,
                                        ),
                                        onTap: () => Clipboard.setData(
                                          ClipboardData(text: webUrl),
                                        ).then(
                                          (value) {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                '$webUrl copied to clipboard!',
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: WebViewWidget(
                                          controller: WebViewController()
                                            ..loadRequest(
                                              Uri.parse(webUrl),
                                            ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        )
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              title: Text(
                'Simple Portfolio web application made with Flutter & GSheet.',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  children: const [
                    /// if you clone this then please make sure leave a star on github
                    /// and follow me on github(if you like my work)
                    TextSpan(
                      text:
                          'If you are going to clone code repository then please make sure leave a star on github and follow me on github(if you like my work), Thank you! Please change the GSheet link in the lib/core/utils/constants.dart file. and GSheet code is available in the backend folder.',
                    ),
                  ],
                ),
              ),
              trailing: IconButton.filledTonal(
                tooltip: 'Check out the code on Github',
                onPressed: () => launchURL(
                  context,
                  'https://github.com/ravikovind/portfolio',
                ),
                icon: const Icon(LucideIcons.github),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Get in Touch',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Open for new Opportunities.\nI’m available for any information needed from my end.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      side: BorderSide(
                        width: 1,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () => welcome(context),
                    icon: const Icon(
                      LucideIcons.mail,
                    ),
                    label: Text(
                      'Send a Message',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Text(
                    'OR',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      side: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () => launchURL(context, 'mailto:$kEmail'),
                    icon: const Icon(
                      LucideIcons.mail,
                    ),
                    label: Text(
                      kEmail,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const SocialAccounts(),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Thank you for Visiting.',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '© ${DateTime.now().year} Ravi Kovind.\nMade with Love❤️ in India 🇮🇳',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
