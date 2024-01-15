// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Explore a world of cars and unlock your potential with us!`
  String get titleBording {
    return Intl.message(
      'Explore a world of cars and unlock your potential with us!',
      name: 'titleBording',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Your Journey`
  String get titleBording2 {
    return Intl.message(
      'Welcome to Your Journey',
      name: 'titleBording2',
      desc: '',
      args: [],
    );
  }

  /// `Sing In`
  String get SingIn {
    return Intl.message(
      'Sing In',
      name: 'SingIn',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get SignIn2 {
    return Intl.message(
      'Enter your phone number',
      name: 'SignIn2',
      desc: '',
      args: [],
    );
  }

  /// `by continuing you agree to our terms of service and privacy & legal policy`
  String get SignIn3 {
    return Intl.message(
      'by continuing you agree to our terms of service and privacy & legal policy',
      name: 'SignIn3',
      desc: '',
      args: [],
    );
  }

  /// `Country / Region`
  String get SignIn4 {
    return Intl.message(
      'Country / Region',
      name: 'SignIn4',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get SingIn5 {
    return Intl.message(
      'Phone Number',
      name: 'SingIn5',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
