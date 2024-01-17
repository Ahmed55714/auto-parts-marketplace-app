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

  /// `Get Started`
  String get titleBording3 {
    return Intl.message(
      'Get Started',
      name: 'titleBording3',
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

  /// `Please enter your phone number`
  String get valid1 {
    return Intl.message(
      'Please enter your phone number',
      name: 'valid1',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get valid2 {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'valid2',
      desc: '',
      args: [],
    );
  }

  /// `Please select your country code`
  String get valid3 {
    return Intl.message(
      'Please select your country code',
      name: 'valid3',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get button {
    return Intl.message(
      'Next',
      name: 'button',
      desc: '',
      args: [],
    );
  }

  /// `Please Wait...`
  String get button2 {
    return Intl.message(
      'Please Wait...',
      name: 'button2',
      desc: '',
      args: [],
    );
  }

  /// `Select Country`
  String get Picker {
    return Intl.message(
      'Select Country',
      name: 'Picker',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get Search {
    return Intl.message(
      'Search',
      name: 'Search',
      desc: '',
      args: [],
    );
  }

  /// `KSA`
  String get KSA {
    return Intl.message(
      'KSA',
      name: 'KSA',
      desc: '',
      args: [],
    );
  }

  /// `New OTP sent successfully`
  String get snack {
    return Intl.message(
      'New OTP sent successfully',
      name: 'snack',
      desc: '',
      args: [],
    );
  }

  /// `Error resending OTP`
  String get snack2 {
    return Intl.message(
      'Error resending OTP',
      name: 'snack2',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get verification {
    return Intl.message(
      'Verification Code',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `We sent you the 6 digit code to  Enter the code below to confirm your phone number`
  String get verification2 {
    return Intl.message(
      'We sent you the 6 digit code to  Enter the code below to confirm your phone number',
      name: 'verification2',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get Verification3 {
    return Intl.message(
      'Verify',
      name: 'Verification3',
      desc: '',
      args: [],
    );
  }

  /// `Don’t received link? `
  String get Dont {
    return Intl.message(
      'Don’t received link? ',
      name: 'Dont',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get Resend {
    return Intl.message(
      'Resend',
      name: 'Resend',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get SignUP {
    return Intl.message(
      'Sign Up',
      name: 'SignUP',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to SLF please choose your account type to continue`
  String get SignUp2 {
    return Intl.message(
      'Welcome to SLF please choose your account type to continue',
      name: 'SignUp2',
      desc: '',
      args: [],
    );
  }

  /// `Sign up as Client`
  String get SignUP3 {
    return Intl.message(
      'Sign up as Client',
      name: 'SignUP3',
      desc: '',
      args: [],
    );
  }

  /// `Sign up as service provider`
  String get SignUP4 {
    return Intl.message(
      'Sign up as service provider',
      name: 'SignUP4',
      desc: '',
      args: [],
    );
  }

  /// `Special Client`
  String get SignUP5 {
    return Intl.message(
      'Special Client',
      name: 'SignUP5',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get MyAccount {
    return Intl.message(
      'My Account',
      name: 'MyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Edit your Profile`
  String get MyAccount2 {
    return Intl.message(
      'Edit your Profile',
      name: 'MyAccount2',
      desc: '',
      args: [],
    );
  }

  /// `Add Complain`
  String get MyAccount3 {
    return Intl.message(
      'Add Complain',
      name: 'MyAccount3',
      desc: '',
      args: [],
    );
  }

  /// `Terms and conditions`
  String get MyAccount4 {
    return Intl.message(
      'Terms and conditions',
      name: 'MyAccount4',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get MyAccount5 {
    return Intl.message(
      'Log out',
      name: 'MyAccount5',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Name {
    return Intl.message(
      'Name',
      name: 'Name',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message(
      'Profile',
      name: 'Profile',
      desc: '',
      args: [],
    );
  }

  /// `Personal data`
  String get Profile2 {
    return Intl.message(
      'Personal data',
      name: 'Profile2',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get Profile3 {
    return Intl.message(
      'Name',
      name: 'Profile3',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get Name2 {
    return Intl.message(
      'Enter',
      name: 'Name2',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get Profile4 {
    return Intl.message(
      'Phone Number',
      name: 'Profile4',
      desc: '',
      args: [],
    );
  }

  /// `Please enter`
  String get Name3 {
    return Intl.message(
      'Please enter',
      name: 'Name3',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Profile5 {
    return Intl.message(
      'Email',
      name: 'Profile5',
      desc: '',
      args: [],
    );
  }

  /// `Addresses`
  String get Profile6 {
    return Intl.message(
      'Addresses',
      name: 'Profile6',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get Profile7 {
    return Intl.message(
      'Delete',
      name: 'Profile7',
      desc: '',
      args: [],
    );
  }

  /// `+ Add address`
  String get Profile8 {
    return Intl.message(
      '+ Add address',
      name: 'Profile8',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get Profile9 {
    return Intl.message(
      'Save',
      name: 'Profile9',
      desc: '',
      args: [],
    );
  }

  /// `Please add an address in your profile.`
  String get Profile10 {
    return Intl.message(
      'Please add an address in your profile.',
      name: 'Profile10',
      desc: '',
      args: [],
    );
  }

  /// `Edit Address`
  String get Edit {
    return Intl.message(
      'Edit Address',
      name: 'Edit',
      desc: '',
      args: [],
    );
  }

  /// `Street`
  String get Edit2 {
    return Intl.message(
      'Street',
      name: 'Edit2',
      desc: '',
      args: [],
    );
  }

  /// `Building`
  String get Edit3 {
    return Intl.message(
      'Building',
      name: 'Edit3',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get Edit4 {
    return Intl.message(
      'Floor',
      name: 'Edit4',
      desc: '',
      args: [],
    );
  }

  /// `Apt`
  String get Edit5 {
    return Intl.message(
      'Apt',
      name: 'Edit5',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get Orders {
    return Intl.message(
      'Orders',
      name: 'Orders',
      desc: '',
      args: [],
    );
  }

  /// `Needed car piece`
  String get Needed {
    return Intl.message(
      'Needed car piece',
      name: 'Needed',
      desc: '',
      args: [],
    );
  }

  /// `Car Model`
  String get CarModel {
    return Intl.message(
      'Car Model',
      name: 'CarModel',
      desc: '',
      args: [],
    );
  }

  /// `Chassis number`
  String get Chassis {
    return Intl.message(
      'Chassis number',
      name: 'Chassis',
      desc: '',
      args: [],
    );
  }

  /// `Piece type`
  String get pieceType {
    return Intl.message(
      'Piece type',
      name: 'pieceType',
      desc: '',
      args: [],
    );
  }

  /// `Piece details`
  String get pieceDetails {
    return Intl.message(
      'Piece details',
      name: 'pieceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get Date {
    return Intl.message(
      'Date',
      name: 'Date',
      desc: '',
      args: [],
    );
  }

  /// `Car Licence`
  String get carLicence {
    return Intl.message(
      'Car Licence',
      name: 'carLicence',
      desc: '',
      args: [],
    );
  }

  /// `Near places`
  String get nearPlaces {
    return Intl.message(
      'Near places',
      name: 'nearPlaces',
      desc: '',
      args: [],
    );
  }

  /// `Order Status`
  String get orderStatus {
    return Intl.message(
      'Order Status',
      name: 'orderStatus',
      desc: '',
      args: [],
    );
  }

  /// `Out for delivery`
  String get Outfordelivery {
    return Intl.message(
      'Out for delivery',
      name: 'Outfordelivery',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get Delivered {
    return Intl.message(
      'Delivered',
      name: 'Delivered',
      desc: '',
      args: [],
    );
  }

  /// `Make Offer`
  String get makeoffer {
    return Intl.message(
      'Make Offer',
      name: 'makeoffer',
      desc: '',
      args: [],
    );
  }

  /// `Decline`
  String get Decline {
    return Intl.message(
      'Decline',
      name: 'Decline',
      desc: '',
      args: [],
    );
  }

  /// `Order is already delivered`
  String get DeleverdText {
    return Intl.message(
      'Order is already delivered',
      name: 'DeleverdText',
      desc: '',
      args: [],
    );
  }

  /// `Image 1`
  String get Image1 {
    return Intl.message(
      'Image 1',
      name: 'Image1',
      desc: '',
      args: [],
    );
  }

  /// `Image 2`
  String get Image2 {
    return Intl.message(
      'Image 2',
      name: 'Image2',
      desc: '',
      args: [],
    );
  }

  /// `Show Location`
  String get ShowLocation {
    return Intl.message(
      'Show Location',
      name: 'ShowLocation',
      desc: '',
      args: [],
    );
  }

  /// `Image View`
  String get ImageView {
    return Intl.message(
      'Image View',
      name: 'ImageView',
      desc: '',
      args: [],
    );
  }

  /// `Image not available`
  String get Imagenot {
    return Intl.message(
      'Image not available',
      name: 'Imagenot',
      desc: '',
      args: [],
    );
  }

  /// `Location View`
  String get LocationView {
    return Intl.message(
      'Location View',
      name: 'LocationView',
      desc: '',
      args: [],
    );
  }

  /// `try again later`
  String get Try {
    return Intl.message(
      'try again later',
      name: 'Try',
      desc: '',
      args: [],
    );
  }

  /// `Continue Registration to be able to see orders`
  String get Re {
    return Intl.message(
      'Continue Registration to be able to see orders',
      name: 'Re',
      desc: '',
      args: [],
    );
  }

  /// `Complete Registration`
  String get Re2 {
    return Intl.message(
      'Complete Registration',
      name: 'Re2',
      desc: '',
      args: [],
    );
  }

  /// `Your application is under review, please wait for the approval`
  String get Re3 {
    return Intl.message(
      'Your application is under review, please wait for the approval',
      name: 'Re3',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred while loading orders`
  String get error {
    return Intl.message(
      'Error occurred while loading orders',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get error2 {
    return Intl.message(
      'No data available',
      name: 'error2',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel Your Order?`
  String get Are {
    return Intl.message(
      'Are you sure you want to cancel Your Order?',
      name: 'Are',
      desc: '',
      args: [],
    );
  }

  /// `Can you tell us the reason?`
  String get Are2 {
    return Intl.message(
      'Can you tell us the reason?',
      name: 'Are2',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get Done {
    return Intl.message(
      'Done',
      name: 'Done',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a reason for cancellation`
  String get Please {
    return Intl.message(
      'Please provide a reason for cancellation',
      name: 'Please',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get Chat {
    return Intl.message(
      'Chat',
      name: 'Chat',
      desc: '',
      args: [],
    );
  }

  /// `Write your message`
  String get Write {
    return Intl.message(
      'Write your message',
      name: 'Write',
      desc: '',
      args: [],
    );
  }

  /// `Offer Form`
  String get Offer1 {
    return Intl.message(
      'Offer Form',
      name: 'Offer1',
      desc: '',
      args: [],
    );
  }

  /// `Piece`
  String get Offer2 {
    return Intl.message(
      'Piece',
      name: 'Offer2',
      desc: '',
      args: [],
    );
  }

  /// `Country Made in`
  String get Offer3 {
    return Intl.message(
      'Country Made in',
      name: 'Offer3',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get Offer31 {
    return Intl.message(
      'Country',
      name: 'Offer31',
      desc: '',
      args: [],
    );
  }

  /// `Year Model`
  String get Offer4 {
    return Intl.message(
      'Year Model',
      name: 'Offer4',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get Offer41 {
    return Intl.message(
      'Year',
      name: 'Offer41',
      desc: '',
      args: [],
    );
  }

  /// `New/Used`
  String get Offer5 {
    return Intl.message(
      'New/Used',
      name: 'Offer5',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get Offer6 {
    return Intl.message(
      'Price',
      name: 'Offer6',
      desc: '',
      args: [],
    );
  }

  /// `Add photos`
  String get Offer7 {
    return Intl.message(
      'Add photos',
      name: 'Offer7',
      desc: '',
      args: [],
    );
  }

  /// `please update an image for license`
  String get Offer8 {
    return Intl.message(
      'please update an image for license',
      name: 'Offer8',
      desc: '',
      args: [],
    );
  }

  /// `Extra note`
  String get Offer9 {
    return Intl.message(
      'Extra note',
      name: 'Offer9',
      desc: '',
      args: [],
    );
  }

  /// `Make an Offer`
  String get Offer10 {
    return Intl.message(
      'Make an Offer',
      name: 'Offer10',
      desc: '',
      args: [],
    );
  }

  /// `Enter Note`
  String get Offers11 {
    return Intl.message(
      'Enter Note',
      name: 'Offers11',
      desc: '',
      args: [],
    );
  }

  /// `Select Car Type`
  String get Offers12 {
    return Intl.message(
      'Select Car Type',
      name: 'Offers12',
      desc: '',
      args: [],
    );
  }

  /// `Car Type`
  String get CarType {
    return Intl.message(
      'Car Type',
      name: 'CarType',
      desc: '',
      args: [],
    );
  }

  /// `You made an Offer!`
  String get Offers13 {
    return Intl.message(
      'You made an Offer!',
      name: 'Offers13',
      desc: '',
      args: [],
    );
  }

  /// `Check your orders to see the status of your order from Order page.`
  String get Offers14 {
    return Intl.message(
      'Check your orders to see the status of your order from Order page.',
      name: 'Offers14',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get Offers15 {
    return Intl.message(
      'Orders',
      name: 'Offers15',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get Terms {
    return Intl.message(
      'Terms and Conditions',
      name: 'Terms',
      desc: '',
      args: [],
    );
  }

  /// `Complain`
  String get Com {
    return Intl.message(
      'Complain',
      name: 'Com',
      desc: '',
      args: [],
    );
  }

  /// `complaint Date`
  String get Com2 {
    return Intl.message(
      'complaint Date',
      name: 'Com2',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get Com3 {
    return Intl.message(
      'Report',
      name: 'Com3',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get Com5 {
    return Intl.message(
      'Submit',
      name: 'Com5',
      desc: '',
      args: [],
    );
  }

  /// `Complain submitted successfully`
  String get success {
    return Intl.message(
      'Complain submitted successfully',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit complaint try again later`
  String get success1 {
    return Intl.message(
      'Failed to submit complaint try again later',
      name: 'success1',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred while submitting complaint`
  String get success2 {
    return Intl.message(
      'Error occurred while submitting complaint',
      name: 'success2',
      desc: '',
      args: [],
    );
  }

  /// `YYYY-MM-DD`
  String get sucess3 {
    return Intl.message(
      'YYYY-MM-DD',
      name: 'sucess3',
      desc: '',
      args: [],
    );
  }

  /// `Order Now`
  String get Map {
    return Intl.message(
      'Order Now',
      name: 'Map',
      desc: '',
      args: [],
    );
  }

  /// `Registration Form`
  String get Registration {
    return Intl.message(
      'Registration Form',
      name: 'Registration',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get EnterYourName {
    return Intl.message(
      'Enter your name',
      name: 'EnterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get Enteryouremail {
    return Intl.message(
      'Enter your email',
      name: 'Enteryouremail',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get Location {
    return Intl.message(
      'Location',
      name: 'Location',
      desc: '',
      args: [],
    );
  }

  /// `Enter your location`
  String get EnterYourLocation {
    return Intl.message(
      'Enter your location',
      name: 'EnterYourLocation',
      desc: '',
      args: [],
    );
  }

  /// `Tax Certificate`
  String get TaxCertificate {
    return Intl.message(
      'Tax Certificate',
      name: 'TaxCertificate',
      desc: '',
      args: [],
    );
  }

  /// `Commercial Register`
  String get CommercialRegister {
    return Intl.message(
      'Commercial Register',
      name: 'CommercialRegister',
      desc: '',
      args: [],
    );
  }

  /// `Municipality Certificate`
  String get MunicipalityCertificatee {
    return Intl.message(
      'Municipality Certificate',
      name: 'MunicipalityCertificatee',
      desc: '',
      args: [],
    );
  }

  /// `Please upload your documents`
  String get Placeholder {
    return Intl.message(
      'Please upload your documents',
      name: 'Placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Please select one or more car types`
  String get Pleace4 {
    return Intl.message(
      'Please select one or more car types',
      name: 'Pleace4',
      desc: '',
      args: [],
    );
  }

  /// `Location services are disabled.`
  String get registerLocation {
    return Intl.message(
      'Location services are disabled.',
      name: 'registerLocation',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are denied`
  String get registerLocation1 {
    return Intl.message(
      'Location permissions are denied',
      name: 'registerLocation1',
      desc: '',
      args: [],
    );
  }

  /// `Location permissions are permanently denied, we cannot request permissions.`
  String get registerLocation2 {
    return Intl.message(
      'Location permissions are permanently denied, we cannot request permissions.',
      name: 'registerLocation2',
      desc: '',
      args: [],
    );
  }

  /// `By clicking on the register button, you agree to the terms and conditions of the application`
  String get Agreee {
    return Intl.message(
      'By clicking on the register button, you agree to the terms and conditions of the application',
      name: 'Agreee',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get Register {
    return Intl.message(
      'Register',
      name: 'Register',
      desc: '',
      args: [],
    );
  }

  /// `Agree to terms and conditions`
  String get Register2 {
    return Intl.message(
      'Agree to terms and conditions',
      name: 'Register2',
      desc: '',
      args: [],
    );
  }

  /// `We got your request!`
  String get TrueScreen {
    return Intl.message(
      'We got your request!',
      name: 'TrueScreen',
      desc: '',
      args: [],
    );
  }

  /// `The request is being reviewed and will be responded to as soon as possible.`
  String get TrueScreen1 {
    return Intl.message(
      'The request is being reviewed and will be responded to as soon as possible.',
      name: 'TrueScreen1',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get TrueScreen2 {
    return Intl.message(
      'Edit',
      name: 'TrueScreen2',
      desc: '',
      args: [],
    );
  }

  /// `Home page`
  String get TrueScreen3 {
    return Intl.message(
      'Home page',
      name: 'TrueScreen3',
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
