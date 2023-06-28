import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapd/snapd.dart';
import 'package:ubuntu_service/ubuntu_service.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'categories.dart';
import 'detail.dart';
import 'manage.dart';
import 'routes.dart';
import 'snapd.dart';

Future<void> main() async {
  await YaruWindowTitleBar.ensureInitialized();

  final snapd = SnapdService();
  await snapd.loadAuthorization();
  registerServiceInstance(snapd);

  runApp(const ProviderScope(child: StoreApp()));
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) => MaterialApp(
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        // TODO: remove Builder and FAB when implementing proper navigation
        home: Builder(builder: (context) {
          return Scaffold(
            appBar: const YaruWindowTitleBar(),
            body: const CategoryPage(category: 'featured'),
            floatingActionButton: FloatingActionButton(
                onPressed: () => Navigator.pushNamed(context, Routes.manage)),
          );
        }),
        onGenerateRoute: (settings) => switch (settings.name) {
          Routes.detail => MaterialPageRoute(
              builder: (_) => DetailPage(snap: settings.arguments as Snap)),
          Routes.manage =>
            MaterialPageRoute(builder: (_) => const ManagePage()),
          _ => null,
        },
      ),
    );
  }
}
