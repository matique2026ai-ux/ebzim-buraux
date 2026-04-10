import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple provider to hold the current app locale state
final localeProvider = StateProvider<Locale>((ref) => const Locale('ar'));
