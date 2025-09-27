import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  // ---------------- Strings ----------------

  // login page
  String get usernameOrEmailPlaceholder;
  String get pleaseEnterYourPhoneNumber;
  String get passwordMustBeAtLeast6Characters;
  String get password;
  String get loggedInSuccessfully;
  String get logInToContinueYourJourney;
  String get forgotPassword;
  String get login;



  // profile
  String get contactInformation;
  String get phoneNumber;
  String get email;
  String get address;
  String get walletAndStatistics;
  String get currentBalance;
  String get officialDocuments;
  String get idImage;
  String get certificateOfNoCriminalRecord;
  String get settings;
  String get changeLanguage;
  String get termsAndPolicies;
  String get changePassword;
  String get logout;
  String get notFound;
  String get done;
  String get select;
  String get servicesEmployee;

  //logout dialog
  String get areYouSureYouWantToLogOutOfYourAccount ;
  String get cancle;

  //change password page
  String get currentPassword;
  String get newPassword;
  String get newPasswordConfirmatio;
  String get success;
  String get failure;

  //bottom nav bar
  String get myAccount;
  String get home;
  String get calendar;

  //home page
  String get orders;
  String get tasks;
  String get sendWhatsapp;
  String get call;


  // edit profile page
  String get editProfile;
  String get pleaseEnterName;
  String get pleaseEnterEmail;
  String get invalidEmail;
  String get pleaseEnterPhone;
  String get invalidPhone;
  String get pleaseEnterAddress;
  String get profileUpdatedSuccessfully;
  String get errorOccurred;
  String get fillAllFields;
  String get saveChanges;
  String get name;
  String get phone;


 //calender
 String get calendarAndServices;
 String get donee;
 String get notDone;
 String get reports;
 

}




class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
        lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale".',
  );
}
