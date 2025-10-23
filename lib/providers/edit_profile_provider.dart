import 'package:inscore_app/core/base_viewmodel.dart';
import 'package:inscore_app/models/user.dart';
import 'package:inscore_app/providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileProvider extends BaseViewModel {
  User? _currentUser;
  String _username = '';
  String _email = '';
  File? _profileImage;
  final AuthProvider _authProvider;

  EditProfileProvider(this._authProvider);

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
      // Call AuthProvider updateProfile method
      await _authProvider.updateProfile(
        name: _username.trim(),
        email: _email.trim(),
        avatarPath: _profileImage?.path,
      );

      // Update current user data from AuthProvider
      _currentUser = _authProvider.user;

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
