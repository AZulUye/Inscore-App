import 'package:inscore_app/core/base_viewmodel.dart';
import 'package:inscore_app/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileProvider extends BaseViewModel {
  User? _currentUser;
  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  File? _profileImage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  User? get currentUser => _currentUser;
  String get username => _username;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  File? get profileImage => _profileImage;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  void initProfile(User user) {
    _currentUser = user;
    _username = user.name;
    notifyListeners();
  }

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
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
      print('Error picking image: $e');
    }
  }

  Future<void> updateProfile() async {
    if (_username.isEmpty) {
      throw Exception('Username tidak boleh kosong');
    }

    if (_password.isNotEmpty && _password != _confirmPassword) {
      throw Exception('Password tidak sama');
    }

    if (_password.isNotEmpty && _password.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }

    setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Update user data
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          name: _username,
          updatedAt: DateTime.now(),
        );
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Gagal mengupdate profile: $e');
    } finally {
      setLoading(false);
    }
  }

  void resetForm() {
    _username = _currentUser?.name ?? '';
    _password = '';
    _confirmPassword = '';
    _profileImage = null;
    _obscurePassword = true;
    _obscureConfirmPassword = true;
    notifyListeners();
  }
}
