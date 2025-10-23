import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class SocialMediaProvider extends ChangeNotifier {
  final ApiService _apiService;

  // Connection states
  bool _isInstagramConnected = false;
  bool _isFacebookConnected = false;

  // Loading states
  bool _isInstagramConnecting = false;
  bool _isFacebookConnecting = false;
  bool _isCheckingStatus = false;

  SocialMediaProvider(this._apiService);

  // Getters
  bool get isInstagramConnected => _isInstagramConnected;
  bool get isFacebookConnected => _isFacebookConnected;
  bool get isInstagramConnecting => _isInstagramConnecting;
  bool get isFacebookConnecting => _isFacebookConnecting;
  bool get isCheckingStatus => _isCheckingStatus;

  // Instagram connection methods
  Future<void> connectInstagram(BuildContext context) async {
    if (_isInstagramConnected) {
      await _disconnectInstagram(context);
      return;
    }

    _setInstagramConnecting(true);

    try {
      final response = await _apiService.connectInstagram();

      if (response['url'] != null) {
        final urlString = response['url'] as String;
        final url = Uri.parse(urlString);

        // Validate URL
        if (!url.hasScheme || (!url.scheme.startsWith('http'))) {
          throw Exception('Invalid URL received from server: $urlString');
        }

        // Try to launch URL directly
        bool launched = false;

        print('=== DEBUG INFO ===');
        print('URL String: $urlString');
        print('Parsed URL: $url');
        print('URL Scheme: ${url.scheme}');
        print('URL Host: ${url.host}');
        print('URL Path: ${url.path}');

        // Check if we can launch the URL
        final canLaunch = await canLaunchUrl(url);
        print('Can launch URL: $canLaunch');

        if (canLaunch) {
          // Try multiple launch modes
          final launchModes = [
            LaunchMode.externalApplication,
            LaunchMode.platformDefault,
            LaunchMode.inAppWebView,
          ];

          for (final mode in launchModes) {
            if (launched) break;

            try {
              print('Trying launch mode: $mode');
              launched = await launchUrl(url, mode: mode);
              print('Launch result for $mode: $launched');

              if (launched) {
                print('Successfully launched with mode: $mode');
                break;
              }
            } catch (e) {
              print('Launch failed for $mode: $e');
            }
          }
        } else {
          print('Cannot launch URL - checking alternatives...');

          // Try to launch with different URL formats
          try {
            final alternativeUrl = Uri.parse(urlString);
            print('Trying alternative URL: $alternativeUrl');

            if (await canLaunchUrl(alternativeUrl)) {
              launched = await launchUrl(
                alternativeUrl,
                mode: LaunchMode.externalApplication,
              );
              print('Alternative URL launch result: $launched');
            }
          } catch (e) {
            print('Alternative URL launch failed: $e');
          }
        }

        if (launched) {
          _showSnackBar(
            context,
            'Opening Instagram authorization...',
            backgroundColor: Colors.blue,
          );
        } else {
          // Show simple error message
          _showSnackBar(
            context,
            'Could not open browser. Please check your browser settings or try copying the URL manually.',
            backgroundColor: Colors.orange,
          );
          print('All launch attempts failed for URL: $urlString');
        }
      } else {
        throw Exception('No URL received from server');
      }
    } catch (e) {
      _showSnackBar(
        context,
        'Failed to connect Instagram: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    } finally {
      _setInstagramConnecting(false);
    }
  }

  Future<void> _disconnectInstagram(BuildContext context) async {
    try {
      await _apiService.disconnectInstagram();
      _setInstagramConnected(false);
      _showSnackBar(context, 'Instagram disconnected successfully');
    } catch (e) {
      _showSnackBar(
        context,
        'Failed to disconnect Instagram: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }

  // Facebook connection methods
  Future<void> connectFacebook(BuildContext context) async {
    if (_isFacebookConnected) {
      await _disconnectFacebook(context);
      return;
    }

    _setFacebookConnecting(true);

    try {
      final response = await _apiService.connectFacebook();

      if (response['url'] != null) {
        final urlString = response['url'] as String;
        final url = Uri.parse(urlString);

        print('=== FACEBOOK DEBUG INFO ===');
        print('URL String: $urlString');
        print('Parsed URL: $url');
        print('URL Scheme: ${url.scheme}');
        print('URL Host: ${url.host}');
        print('URL Path: ${url.path}');

        // Validate URL
        if (!url.hasScheme || (!url.scheme.startsWith('http'))) {
          throw Exception('Invalid URL received from server: $urlString');
        }

        // Try to launch URL directly
        bool launched = false;

        // Check if we can launch the URL
        final canLaunch = await canLaunchUrl(url);
        print('Can launch Facebook URL: $canLaunch');

        if (canLaunch) {
          // Try multiple launch modes
          final launchModes = [
            LaunchMode.externalApplication,
            LaunchMode.platformDefault,
            LaunchMode.inAppWebView,
          ];

          for (final mode in launchModes) {
            if (launched) break;

            try {
              print('Trying Facebook launch mode: $mode');
              launched = await launchUrl(url, mode: mode);
              print('Facebook launch result for $mode: $launched');

              if (launched) {
                print('Successfully launched Facebook with mode: $mode');
                break;
              }
            } catch (e) {
              print('Facebook launch failed for $mode: $e');
            }
          }
        } else {
          print('Cannot launch Facebook URL - checking alternatives...');

          // Try to launch with different URL formats
          try {
            final alternativeUrl = Uri.parse(urlString);
            print('Trying alternative Facebook URL: $alternativeUrl');

            if (await canLaunchUrl(alternativeUrl)) {
              launched = await launchUrl(
                alternativeUrl,
                mode: LaunchMode.externalApplication,
              );
              print('Alternative Facebook URL launch result: $launched');
            }
          } catch (e) {
            print('Alternative Facebook URL launch failed: $e');
          }
        }

        if (launched) {
          _showSnackBar(
            context,
            'Opening Facebook authorization...',
            backgroundColor: Colors.blue,
          );
        } else {
          // Show simple error message
          _showSnackBar(
            context,
            'Could not open browser. Please check your browser settings or try copying the URL manually.',
            backgroundColor: Colors.orange,
          );
          print('All Facebook launch attempts failed for URL: $urlString');
        }
      } else {
        throw Exception('No URL received from server');
      }
    } catch (e) {
      _showSnackBar(
        context,
        'Failed to connect Facebook: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    } finally {
      _setFacebookConnecting(false);
    }
  }

  Future<void> _disconnectFacebook(BuildContext context) async {
    try {
      await _apiService.disconnectFacebook();
      _setFacebookConnected(false);
      _showSnackBar(context, 'Facebook disconnected successfully');
    } catch (e) {
      _showSnackBar(
        context,
        'Failed to disconnect Facebook: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }

  // Private setters
  void _setInstagramConnected(bool value) {
    _isInstagramConnected = value;
    notifyListeners();
  }

  void _setFacebookConnected(bool value) {
    _isFacebookConnected = value;
    notifyListeners();
  }

  void _setInstagramConnecting(bool value) {
    _isInstagramConnecting = value;
    notifyListeners();
  }

  void _setFacebookConnecting(bool value) {
    _isFacebookConnecting = value;
    notifyListeners();
  }

  // Helper method for showing snackbar
  void _showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  // Method to check connection status from API
  Future<void> checkConnectionStatus() async {
    _isCheckingStatus = true;
    notifyListeners();

    try {
      // Check Instagram connection status
      final instagramStatus = await _apiService
          .checkInstagramConnectionStatus();
      _isInstagramConnected = instagramStatus['connected'] == true;

      // Check Facebook connection status
      final facebookStatus = await _apiService.checkFacebookConnectionStatus();
      _isFacebookConnected = facebookStatus['connected'] == true;
    } catch (e) {
      // Handle error silently or show appropriate message
      print('Error checking connection status: $e');
    } finally {
      _isCheckingStatus = false;
      notifyListeners();
    }
  }

  // Method to check Instagram connection status only
  Future<void> checkInstagramConnectionStatus() async {
    try {
      final status = await _apiService.checkInstagramConnectionStatus();
      _isInstagramConnected = status['connected'] == true;
      notifyListeners();
    } catch (e) {
      print('Error checking Instagram connection status: $e');
    }
  }

  // Method to check Facebook connection status only
  Future<void> checkFacebookConnectionStatus() async {
    try {
      final status = await _apiService.checkFacebookConnectionStatus();
      _isFacebookConnected = status['connected'] == true;
      notifyListeners();
    } catch (e) {
      print('Error checking Facebook connection status: $e');
    }
  }

  // Test method to debug URL launching
  Future<void> testUrlLaunch(BuildContext context, String testUrl) async {
    try {
      print('=== TESTING URL LAUNCH ===');
      print('Test URL: $testUrl');

      final url = Uri.parse(testUrl);
      print('Parsed URL: $url');

      final canLaunch = await canLaunchUrl(url);
      print('Can launch test URL: $canLaunch');

      if (canLaunch) {
        final launched = await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
        print('Test launch result: $launched');

        _showSnackBar(
          context,
          'Test launch result: $launched',
          backgroundColor: launched ? Colors.green : Colors.red,
        );
      } else {
        _showSnackBar(
          context,
          'Cannot launch test URL',
          backgroundColor: Colors.orange,
        );
      }
    } catch (e) {
      print('Test launch error: $e');
      _showSnackBar(
        context,
        'Test launch error: $e',
        backgroundColor: Colors.red,
      );
    }
  }
}
