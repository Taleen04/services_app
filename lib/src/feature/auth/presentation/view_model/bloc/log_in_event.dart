import 'package:flutter/material.dart';

@immutable
abstract class LogInEvent {}

class LogInButtonPressed extends LogInEvent {
  final String userName;
  final String password;

  LogInButtonPressed(this.userName, this.password);
}

class LogInInitialEvent extends LogInEvent {}

class LogOutEvent extends LogInEvent {}


