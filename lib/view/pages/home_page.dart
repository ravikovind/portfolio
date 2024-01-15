import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    Future.delayed(const Duration(seconds: 5), () {
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
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
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
                        height: 8.0,
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
                          } else {
                            showMessage(
                              context,
                              'Error!',
                              'Please enter valid details!',
                            );
                          }
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
    // print(
    //   'context.read<MessageCubit>().state: ${context.read<MessageCubit>().state}',
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Portfolio',
                applicationVersion: '2.0.0',
                applicationIcon: const FlutterLogo(),
                applicationLegalese: 'Ravi Kovind © 2024',
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text('About'),
                    subtitle: const Text(
                      'This is a simple Portfolio web application made with Flutter & GSheet.',
                    ),
                    leading: const Icon(FontAwesomeIcons.github),
                    trailing: const Icon(Icons.launch),
                    onTap: () {
                      launchURL(
                        context,
                        'https://github.com/ravikovind/portfolio',
                      );
                    },
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.email),
            onPressed: () {
              welcome(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              context.read<ThemeBloc>().add(const ToggleTheme());
            },
          ),
        ],
      ),
      body: ListView(
        primary: true,
        children: [
          Stack(
            children: [
              isDeviceDesktop(context)
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Lottie.asset(
                        'assets/animations/json_2.json',
                        fit: BoxFit.contain,
                        reverse: true,
                        height: MediaQuery.of(context).size.width * 0.5,
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
                      'Hey there! I am ',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                wordSpacing: 2.0,
                              ),
                    ),
                    Text(
                      'Ravi Kovind',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: isDeviceDesktop(context) ? 72.0 : 48.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Lead Dev || Flutter Dev || NIT Allahabad',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w200,
                          ),
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
                            letterSpacing: 2.4,
                            wordSpacing: 2.4,
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
                      onPressed: () {
                        launchURL(context, 'mailto:$kEmail');
                      },
                      icon: const Icon(
                        Icons.mail,
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Get In Touch',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontSize:
                                    isDeviceDesktop(context) ? 20.0 : 18.0,
                              ),
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
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: 2.4,
                        wordSpacing: 2.4,
                      ),
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
                if (projects.isEmpty) {
                  return const SizedBox.shrink();
                }
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
                                    letterSpacing: 2.4,
                                    wordSpacing: 1.2,
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
                          return ExpansionTile(
                            title: Text(
                              '${project.name}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    fontSize:
                                        isDeviceDesktop(context) ? 18.0 : 16.0,
                                    letterSpacing: 2.4,
                                    wordSpacing: 2.4,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            initiallyExpanded: true,
                            subtitle: Text('${project.description}'),
                            childrenPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            expandedAlignment: Alignment.topLeft,
                            children: [
                              /// tags
                              Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runAlignment: WrapAlignment.start,
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: [
                                  ...project.tags?.map(
                                        (e) => Chip(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          label: Text(
                                            e,
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
                              Builder(
                                builder: (context) {
                                  if (project.appUrl.isNullOrEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return ListTile(
                                    title: Text(
                                      'Try Application Now',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            fontSize: isDeviceDesktop(context)
                                                ? 20.0
                                                : 18.0,
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                    ),
                                    trailing: const Icon(
                                      Icons.android,
                                      color: Colors.green,
                                    ),
                                    onTap: () {
                                      launchURL(context, '${project.appUrl}');
                                    },
                                  );
                                },
                              ),
                              Builder(
                                builder: (context) {
                                  if (project.webUrl.isNullOrEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  final webUrl = project.webUrl.notNullValue;

                                  /// load this url in webview sized box media query 0.5
                                  return Column(
                                    children: [
                                      /// list tile to copy url
                                      ListTile(
                                        title: Text(
                                          webUrl,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                letterSpacing: 2.4,
                                                wordSpacing: 2.4,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                        ),
                                        trailing: const Icon(
                                          Icons.copy,
                                        ),
                                        onTap: () {
                                          /// copy url to clipboard
                                          Clipboard.setData(
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
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height * 0.75,
                                        child: WebViewWidget(
                                          controller: WebViewController()
                                            ..loadRequest(
                                              Uri.parse(webUrl),
                                            ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(
                  height: 16.0,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                      'Simple Portfolio web application made with Flutter & GSheet. Check out the code on Github.'),
                  subtitle: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.4,
                            wordSpacing: 1.2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      children: const [
                        /// if you clone this then please make sure leave a star on github
                        /// and follow me on github(if you like my work)
                        TextSpan(
                          text: ' If you are going to clone code repository then please make sure leave a star on github and follow me on github(if you like my work), Thank you! Please change the GSheet link in the lib/core/utils/constants.dart file. and GSheet cose is available in the backend folder.',
                         
                        ),
                      ],
                    ),
                  ),
                  leading: const Icon(FontAwesomeIcons.github),
                  trailing: const Icon(Icons.launch),
                  onTap: () {
                    launchURL(
                      context,
                      'https://github.com/ravikovind/portfolio',
                    );
                  },
                ),
                const SizedBox(
                  height: 16.0,
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
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 2.4,
                        wordSpacing: 2.4,
                      ),
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
                      width: 1.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () {
                    launchURL(context, 'mailto:$kEmail');
                  },
                  icon: const Icon(
                    Icons.mail,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      kEmail,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
