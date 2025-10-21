import 'package:inscore_app/core/base_viewmodel.dart';
import 'package:inscore_app/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileProvider extends BaseViewModel {
  User? _currentUser;
  String _username = '';
  String _email = '';
  File? _profileImage;

  User? get currentUser => _currentUser;
  String get username => _username;
  String get email => _email;
  File? get profileImage => _profileImage;

  void initProfile(User user) {
    _currentUser = user;
    _username = user.name;
    _email = user.email;
    notifyListeners();
  }

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  Future<void> pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        _profileImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      // Error picking image - could be logged to crashlytics in production
      rethrow;
    }
  }

  Future<void> updateProfile() async {
    if (_username.trim().isEmpty) {
      throw Exception('Username tidak boleh kosong');
    }

    if (_email.trim().isEmpty) {
      throw Exception('Email tidak boleh kosong');
    }

    // Basic email validation
    if (!_email.contains('@') || !_email.contains('.')) {
      throw Exception('Format email tidak valid');
    }

    setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Update user data
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          name: _username.trim(),
          email: _email.trim(),
          updatedAt: DateTime.now(),
          // Note: In a real app, you would upload the image and get the URL
          // For now, we'll keep the existing avatar or set a placeholder
          avatar: _profileImage != null
              ? 'https://via.placeholder.com/150'
              : _currentUser!.avatar,
        );
      }

      setSuccess();
      notifyListeners();
    } catch (e) {
      setError('Gagal mengupdate profile: $e');
      throw Exception('Gagal mengupdate profile: $e');
    }
  }

  User? getUpdatedUser() {
    return _currentUser;
  }

  void resetForm() {
    _username = _currentUser?.name ?? '';
    _email = _currentUser?.email ?? '';
    _profileImage = null;
    notifyListeners();
  }
}
