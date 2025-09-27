import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trasport_ai/src/core/database/cache/shared_pref_helper.dart';
import 'package:trasport_ai/src/core/generated/l10n/app_localizations.dart';
import 'package:trasport_ai/src/core/go_route/go_route.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/cubit/change_lang/change_language_cubit.dart';
import 'package:trasport_ai/src/feature/profile/presentation/view_model.dart/cubit/change_lang/change_language_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageCubit>(
      create: (context) => LanguageCubit()..loadSavedLanguage(),
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return 
          MaterialApp.router(
            supportedLocales:AppLocalizations.supportedLocales,
            locale:state.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            
            routerConfig: AppRouter.router,
            title: 'Transport AI',
          );
        },
      ),
    );
  }
}
