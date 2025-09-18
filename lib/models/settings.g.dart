// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
  isDarkMode: json['isDarkMode'] as bool,
  language: json['language'] as String,
  notificationsEnabled: json['notificationsEnabled'] as bool,
  soundEnabled: json['soundEnabled'] as bool,
  vibrationEnabled: json['vibrationEnabled'] as bool,
  currency: json['currency'] as String,
  timezone: json['timezone'] as String,
  preferences: json['preferences'] as Map<String, dynamic>,
);

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  'isDarkMode': instance.isDarkMode,
  'language': instance.language,
  'notificationsEnabled': instance.notificationsEnabled,
  'soundEnabled': instance.soundEnabled,
  'vibrationEnabled': instance.vibrationEnabled,
  'currency': instance.currency,
  'timezone': instance.timezone,
  'preferences': instance.preferences,
};
