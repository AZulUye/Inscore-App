import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings extends Equatable {
  final bool isDarkMode;
  final String language;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final String currency;
  final String timezone;
  final Map<String, dynamic> preferences;

  const Settings({
    required this.isDarkMode,
    required this.language,
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.currency,
    required this.timezone,
    required this.preferences,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  Settings copyWith({
    bool? isDarkMode,
    String? language,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    String? currency,
    String? timezone,
    Map<String, dynamic>? preferences,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      currency: currency ?? this.currency,
      timezone: timezone ?? this.timezone,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        isDarkMode,
        language,
        notificationsEnabled,
        soundEnabled,
        vibrationEnabled,
        currency,
        timezone,
        preferences,
      ];

  @override
  String toString() {
    return 'Settings{isDarkMode: $isDarkMode, language: $language, notificationsEnabled: $notificationsEnabled, soundEnabled: $soundEnabled, vibrationEnabled: $vibrationEnabled, currency: $currency, timezone: $timezone, preferences: $preferences}';
  }

  // Static factory methods
  static Settings defaultSettings() {
    return const Settings(
      isDarkMode: false,
      language: 'en',
      notificationsEnabled: true,
      soundEnabled: true,
      vibrationEnabled: true,
      currency: 'USD',
      timezone: 'UTC',
      preferences: {},
    );
  }

  static Settings fromLocalStorage(Map<String, dynamic> data) {
    return Settings(
      isDarkMode: data['isDarkMode'] ?? false,
      language: data['language'] ?? 'en',
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      soundEnabled: data['soundEnabled'] ?? true,
      vibrationEnabled: data['vibrationEnabled'] ?? true,
      currency: data['currency'] ?? 'USD',
      timezone: data['timezone'] ?? 'UTC',
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
    );
  }

  Map<String, dynamic> toLocalStorage() {
    return {
      'isDarkMode': isDarkMode,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'currency': currency,
      'timezone': timezone,
      'preferences': preferences,
    };
  }
}
