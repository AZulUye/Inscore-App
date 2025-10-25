import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(fromJson: _idToString)
  final String id;
  final String name;
  final String email;
  @JsonKey(name: 'avatar_url')
  final String? avatar;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  static String _idToString(dynamic id) => id.toString();

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatar, createdAt, updatedAt];

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, avatar: $avatar, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  // Static factory methods for common use cases
  static User empty() {
    return User(
      id: '',
      name: '',
      email: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static User demo() {
    return User(
      id: 'demo_user_123',
      name: 'Demo User',
      email: 'demo@example.com',
      avatar: null,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
  }

  bool get isEmpty => id.isEmpty && name.isEmpty && email.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
