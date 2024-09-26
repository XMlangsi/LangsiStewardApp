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

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgot_password {
    return Intl.message(
      'Forgot Password',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter Password`
  String get enter_your_password {
    return Intl.message(
      'Enter Password',
      name: 'enter_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Username and password cannot be empty`
  String get login_error {
    return Intl.message(
      'Username and password cannot be empty',
      name: 'login_error',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get email_error {
    return Intl.message(
      'Email cannot be empty',
      name: 'email_error',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect email format`
  String get email_error2 {
    return Intl.message(
      'Incorrect email format',
      name: 'email_error2',
      desc: '',
      args: [],
    );
  }

  /// `Login successful`
  String get login_success {
    return Intl.message(
      'Login successful',
      name: 'login_success',
      desc: '',
      args: [],
    );
  }

  /// `Login failed. Incorrect account or password`
  String get login_out {
    return Intl.message(
      'Login failed. Incorrect account or password',
      name: 'login_out',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations`
  String get congratulation {
    return Intl.message(
      'Congratulations',
      name: 'congratulation',
      desc: '',
      args: [],
    );
  }

  /// `Lock Message`
  String get lock_msg {
    return Intl.message(
      'Lock Message',
      name: 'lock_msg',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get index {
    return Intl.message(
      'Home',
      name: 'index',
      desc: '',
      args: [],
    );
  }

  /// `My`
  String get my {
    return Intl.message(
      'My',
      name: 'my',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get change_password_success {
    return Intl.message(
      'Password changed successfully',
      name: 'change_password_success',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get old_password {
    return Intl.message(
      'Old Password',
      name: 'old_password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get change_password_error {
    return Intl.message(
      'Passwords do not match',
      name: 'change_password_error',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get switch_language {
    return Intl.message(
      'Language',
      name: 'switch_language',
      desc: '',
      args: [],
    );
  }

  /// `Building`
  String get house {
    return Intl.message(
      'Building',
      name: 'house',
      desc: '',
      args: [],
    );
  }

  /// `Room`
  String get room {
    return Intl.message(
      'Room',
      name: 'room',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floor {
    return Intl.message(
      'Floor',
      name: 'floor',
      desc: '',
      args: [],
    );
  }

  /// `Add Password`
  String get add_lock_password {
    return Intl.message(
      'Add Password',
      name: 'add_lock_password',
      desc: '',
      args: [],
    );
  }

  /// `Permission List`
  String get lock_password_list {
    return Intl.message(
      'Permission List',
      name: 'lock_password_list',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this permission?`
  String get delete_password_qr {
    return Intl.message(
      'Are you sure you want to delete this permission?',
      name: 'delete_password_qr',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `search`
  String get sel_msg {
    return Intl.message(
      'search',
      name: 'sel_msg',
      desc: '',
      args: [],
    );
  }

  /// `Check-in`
  String get checkin {
    return Intl.message(
      'Check-in',
      name: 'checkin',
      desc: '',
      args: [],
    );
  }

  /// `Contract Information`
  String get contract_info {
    return Intl.message(
      'Contract Information',
      name: 'contract_info',
      desc: '',
      args: [],
    );
  }

  /// `Occupied Tenant`
  String get Occupied_tenant {
    return Intl.message(
      'Occupied Tenant',
      name: 'Occupied_tenant',
      desc: '',
      args: [],
    );
  }

  /// `Work Order Details`
  String get work_order {
    return Intl.message(
      'Work Order Details',
      name: 'work_order',
      desc: '',
      args: [],
    );
  }

  /// `Lock Management`
  String get lockmsg {
    return Intl.message(
      'Lock Management',
      name: 'lockmsg',
      desc: '',
      args: [],
    );
  }

  /// `Gateway List`
  String get gatewaylist {
    return Intl.message(
      'Gateway List',
      name: 'gatewaylist',
      desc: '',
      args: [],
    );
  }

  /// `Property Management`
  String get houseadministration {
    return Intl.message(
      'Property Management',
      name: 'houseadministration',
      desc: '',
      args: [],
    );
  }

  /// `Low Battery Lock`
  String get low_battery_lock {
    return Intl.message(
      'Low Battery Lock',
      name: 'low_battery_lock',
      desc: '',
      args: [],
    );
  }

  /// `Vacant Room Management`
  String get null_room_administration {
    return Intl.message(
      'Vacant Room Management',
      name: 'null_room_administration',
      desc: '',
      args: [],
    );
  }

  /// `Tenant List`
  String get tenantlist {
    return Intl.message(
      'Tenant List',
      name: 'tenantlist',
      desc: '',
      args: [],
    );
  }

  /// `Check-in Records`
  String get check_record {
    return Intl.message(
      'Check-in Records',
      name: 'check_record',
      desc: '',
      args: [],
    );
  }

  /// `Bill Selection`
  String get select_bill {
    return Intl.message(
      'Bill Selection',
      name: 'select_bill',
      desc: '',
      args: [],
    );
  }

  /// `Water Meter Management`
  String get water_meter_management {
    return Intl.message(
      'Water Meter Management',
      name: 'water_meter_management',
      desc: '',
      args: [],
    );
  }

  /// `Electricity Meter Management`
  String get electricity_meter_management {
    return Intl.message(
      'Electricity Meter Management',
      name: 'electricity_meter_management',
      desc: '',
      args: [],
    );
  }

  /// `Gas Meter Management`
  String get gas_meter_management {
    return Intl.message(
      'Gas Meter Management',
      name: 'gas_meter_management',
      desc: '',
      args: [],
    );
  }

  /// `Water Tank Management`
  String get water_tank_management {
    return Intl.message(
      'Water Tank Management',
      name: 'water_tank_management',
      desc: '',
      args: [],
    );
  }

  /// `Alarm Management`
  String get alarm_management {
    return Intl.message(
      'Alarm Management',
      name: 'alarm_management',
      desc: '',
      args: [],
    );
  }

  /// `collector`
  String get collector {
    return Intl.message(
      'collector',
      name: 'collector',
      desc: '',
      args: [],
    );
  }

  /// `Add Fingerprint`
  String get add_fingerprint {
    return Intl.message(
      'Add Fingerprint',
      name: 'add_fingerprint',
      desc: '',
      args: [],
    );
  }

  /// `Set time`
  String get set_Time {
    return Intl.message(
      'Set time',
      name: 'set_Time',
      desc: '',
      args: [],
    );
  }

  /// `Temporary password`
  String get temporary_password {
    return Intl.message(
      'Temporary password',
      name: 'temporary_password',
      desc: '',
      args: [],
    );
  }

  /// `Remote door opening`
  String get remote_door {
    return Intl.message(
      'Remote door opening',
      name: 'remote_door',
      desc: '',
      args: [],
    );
  }

  /// `Add card`
  String get add_card {
    return Intl.message(
      'Add card',
      name: 'add_card',
      desc: '',
      args: [],
    );
  }

  /// `Lock information`
  String get lock_information {
    return Intl.message(
      'Lock information',
      name: 'lock_information',
      desc: '',
      args: [],
    );
  }

  /// `No door lock`
  String get unlock {
    return Intl.message(
      'No door lock',
      name: 'unlock',
      desc: '',
      args: [],
    );
  }

  /// `蓝牙开门`
  String get bluopendoor {
    return Intl.message(
      '蓝牙开门',
      name: 'bluopendoor',
      desc: '',
      args: [],
    );
  }

  /// `accredit`
  String get accredit {
    return Intl.message(
      'accredit',
      name: 'accredit',
      desc: '',
      args: [],
    );
  }

  /// `Processing list`
  String get Processing_list {
    return Intl.message(
      'Processing list',
      name: 'Processing_list',
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
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'pr'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
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
