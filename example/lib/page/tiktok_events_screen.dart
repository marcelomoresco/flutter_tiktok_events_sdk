import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';
import 'package:tiktok_events_sdk_example/services/tiktok_services.dart';

class TikTokEventsPage extends StatefulWidget {
  const TikTokEventsPage({super.key});

  @override
  State<TikTokEventsPage> createState() => _TikTokEventsPageState();
}

class _TikTokEventsPageState extends State<TikTokEventsPage> {
  final TextEditingController _androidAppIdController = TextEditingController();
  final TextEditingController _tikTokAndroidIdController =
      TextEditingController();
  final TextEditingController _iosAppIdController = TextEditingController();
  final TextEditingController _tiktokIosIdController = TextEditingController();
  final TextEditingController _accessTokenController = TextEditingController();
  bool _isDebugMode = true;
  bool _isAccessTokenVisible = false;

  @override
  void initState() {
    super.initState();
    // Set default test values for iOS
  }

  @override
  void dispose() {
    _androidAppIdController.dispose();
    _tikTokAndroidIdController.dispose();
    _iosAppIdController.dispose();
    _tiktokIosIdController.dispose();
    _accessTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TikTok Events SDK'),
        elevation: 0,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // SDK Initialization Card
            _buildSectionCard(
              context,
              title: 'SDK Initialization',
              icon: Icons.settings_outlined,
              children: [
                _buildPlatformIndicator(context),
                const SizedBox(height: 16),
                // Show Android fields only when on Android
                if (!Platform.isIOS) ...[
                  _buildTextField(
                    controller: _androidAppIdController,
                    label: 'Android App ID',
                    hint: 'Enter Android app ID',
                    icon: Icons.android_outlined,
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _tikTokAndroidIdController,
                    label: 'TikTok Android ID',
                    hint: 'Enter TikTok Android ID',
                    icon: Icons.account_circle_outlined,
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),
                ],
                // Show iOS fields only when on iOS
                if (Platform.isIOS) ...[
                  _buildTextField(
                    controller: _iosAppIdController,
                    label: 'iOS App ID',
                    hint: 'Enter iOS app ID',
                    icon: Icons.apple,
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _tiktokIosIdController,
                    label: 'TikTok iOS ID',
                    hint: 'Enter TikTok iOS ID',
                    icon: Icons.account_circle_outlined,
                    isRequired: true,
                  ),
                  const SizedBox(height: 12),
                ],
                _buildTextField(
                  controller: _accessTokenController,
                  label: 'Access Token (Optional)',
                  hint: 'Enter access token',
                  icon: Icons.lock_outline,
                  obscureText: !_isAccessTokenVisible,
                  showVisibilityToggle: true,
                  isVisible: _isAccessTokenVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isAccessTokenVisible = !_isAccessTokenVisible;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isDebugMode,
                      onChanged: (value) {
                        setState(() {
                          _isDebugMode = value ?? true;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text('Debug Mode'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  context,
                  icon: Icons.power_settings_new,
                  label: 'Initialize SDK',
                  description: 'Initialize TikTok Events SDK',
                  onPressed: _handleInitializeSdk,
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // SDK Status Card
            _buildSectionCard(
              context,
              title: 'SDK Status',
              icon: Icons.info_outline,
              children: [
                // ATT Permission Section
                if (Platform.isIOS)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.privacy_tip_outlined,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ATT Permission',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildActionButton(
                          context,
                          icon: Icons.verified_user_outlined,
                          label: 'ATT Permission Info',
                          description:
                              'Initialize SDK first to request ATT permission. If denied, go to Settings > Privacy & Security > Tracking',
                          onPressed: _requestATTPermission,
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
                        ),
                      ],
                    ),
                  ),
                if (Platform.isIOS) const SizedBox(height: 12),
                _buildActionButton(
                  context,
                  icon: Icons.play_circle_outline,
                  label: 'Start Track',
                  onPressed: _handleStartTrack,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // User Actions Card
            _buildSectionCard(
              context,
              title: 'User Actions',
              icon: Icons.person_outline,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.verified_user_outlined,
                  label: 'Identify User',
                  description: 'Set user identifiers (email, phone, etc.)',
                  onPressed: _handleIdentify,
                  backgroundColor: colorScheme.secondaryContainer,
                  foregroundColor: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context,
                  icon: Icons.logout,
                  label: 'Logout',
                  description: 'Clear user session',
                  onPressed: _handleLogout,
                  backgroundColor: colorScheme.errorContainer,
                  foregroundColor: colorScheme.onErrorContainer,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // E-Commerce Events Card
            _buildSectionCard(
              context,
              title: 'E-Commerce Events',
              icon: Icons.shopping_cart_outlined,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  label: 'Add to Cart',
                  description: 'Track product added to cart',
                  onPressed: () => _handleCustomEvent(
                    TTEventType.addToCart,
                    'test_product_123',
                    29.99,
                  ),
                  backgroundColor: Colors.orange.shade50,
                  foregroundColor: Colors.orange.shade900,
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context,
                  icon: Icons.favorite_border,
                  label: 'Add to Wishlist',
                  description: 'Track product wishlist',
                  onPressed: () => _handleCustomEvent(
                    TTEventType.addToWishlist,
                    'test_product_456',
                    49.99,
                  ),
                  backgroundColor: Colors.pink.shade50,
                  foregroundColor: Colors.pink.shade900,
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context,
                  icon: Icons.shopping_cart_checkout,
                  label: 'Checkout',
                  description: 'Track checkout initiation',
                  onPressed: () => _handleCustomEvent(
                    TTEventType.checkout,
                    null,
                    129.98,
                  ),
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: Colors.blue.shade900,
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context,
                  icon: Icons.check_circle_outline,
                  label: 'Purchase',
                  description: 'Track completed purchase',
                  onPressed: () => _handleCustomEvent(
                    TTEventType.purchase,
                    'order_789',
                    129.98,
                  ),
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: Colors.green.shade900,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Content Events Card
            _buildSectionCard(
              context,
              title: 'Content Events',
              icon: Icons.visibility_outlined,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.article_outlined,
                  label: 'View Content',
                  description: 'Track content view',
                  onPressed: () => _handleViewContent(),
                  backgroundColor: Colors.purple.shade50,
                  foregroundColor: Colors.purple.shade900,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Generic Events Card
            _buildSectionCard(
              context,
              title: 'Generic Events',
              icon: Icons.flash_on_outlined,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.send_outlined,
                  label: 'Send Custom Event',
                  description: 'Track custom event',
                  onPressed: _handleLogEvent,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  foregroundColor: colorScheme.onSurfaceVariant,
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool isRequired = false,
    bool showVisibilityToggle = false,
    bool isVisible = true,
    VoidCallback? onToggleVisibility,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            enableInteractiveSelection: true,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Icon(icon),
              suffixIcon: showVisibilityToggle && onToggleVisibility != null
                  ? IconButton(
                      icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: onToggleVisibility,
                      tooltip: isVisible ? 'Hide' : 'Show',
                    )
                  : null,
              suffixText: (isRequired && !showVisibilityToggle) ? '*' : null,
              suffixStyle: TextStyle(color: theme.colorScheme.error),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: isRequired
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.paste_outlined),
          tooltip: 'Paste',
          onPressed: () async {
            final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
            if (clipboardData?.text != null) {
              controller.text = clipboardData!.text!;
            }
          },
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final isIos = Platform.isIOS;
    final platformName = isIos ? 'iOS' : 'Android';
    final platformIcon = isIos ? Icons.apple : Icons.android;
    final color =
        isIos ? theme.colorScheme.primary : theme.colorScheme.tertiary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            platformIcon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'Running on $platformName',
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? description,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minimumSize: const Size(double.infinity, 70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (description != null)
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: foregroundColor.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 24),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isSuccess = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleInitializeSdk() async {
    try {
      debugPrint('🔵 Starting SDK initialization...');

      final androidAppId = _androidAppIdController.text.trim();
      final tikTokAndroidId = _tikTokAndroidIdController.text.trim();
      final iosAppId = _iosAppIdController.text.trim();
      final tiktokIosId = _tiktokIosIdController.text.trim();
      final accessToken = _accessTokenController.text.trim();

      // Detect current platform
      final isIos = Platform.isIOS;
      debugPrint('🔵 Platform: ${isIos ? "iOS" : "Android"}');

      // Only validate the platform-specific fields based on current platform
      if (isIos) {
        if (iosAppId.isEmpty || tiktokIosId.isEmpty) {
          debugPrint('❌ iOS fields validation failed');
          _showSnackBar('Please fill in iOS App ID and TikTok iOS ID',
              isSuccess: false);
          return;
        }
      } else {
        if (androidAppId.isEmpty || tikTokAndroidId.isEmpty) {
          debugPrint('❌ Android fields validation failed');
          _showSnackBar('Please fill in Android App ID and TikTok Android ID',
              isSuccess: false);
          return;
        }
      }

      debugPrint('✅ Field validation passed');

      // Set log level to verbose when debug mode is enabled
      final logLevel =
          _isDebugMode ? TikTokLogLevel.verbose : TikTokLogLevel.info;
      debugPrint('🔵 Log level: ${logLevel.name}, Debug mode: $_isDebugMode');

      debugPrint('🔵 Calling TikTokService.init...');
      await TikTokService.init(
        androidAppId: androidAppId,
        tikTokAndroidId: tikTokAndroidId,
        iosAppId: iosAppId,
        tiktokIosId: tiktokIosId,
        isDebugMode: _isDebugMode,
        accessToken: accessToken.isNotEmpty ? accessToken : null,
        logLevel: logLevel,
      );

      debugPrint('✅ TikTokService.init completed successfully');
      final platformName = isIos ? 'iOS' : 'Android';
      _showSnackBar('SDK initialized successfully for $platformName!');
    } catch (e, stackTrace) {
      debugPrint('❌ Error during SDK initialization: $e');
      debugPrint('Stack trace: $stackTrace');
      _showSnackBar('Error: $e', isSuccess: false);
    }
  }

  Future<void> _requestATTPermission() async {
    if (!Platform.isIOS) {
      _showSnackBar('ATT permission is only available on iOS',
          isSuccess: false);
      return;
    }

    try {
      debugPrint('🔵 Requesting ATT permission...');

      // Note: ATT permission is requested automatically when SDK initializes
      // This button is just for re-requesting if needed
      _showSnackBar(
          'Please initialize the SDK first. ATT will be requested automatically.',
          isSuccess: true);
    } catch (e, stackTrace) {
      debugPrint('❌ Error requesting ATT permission: $e');
      debugPrint('Stack trace: $stackTrace');
      _showSnackBar('Could not request ATT permission: $e', isSuccess: false);
    }
  }

  Future<void> _handleStartTrack() async {
    try {
      debugPrint('🔵 Starting startTrack...');
      await TikTokService.startTrack();
      debugPrint('✅ startTrack completed successfully');
      _showSnackBar('Track started successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Error in startTrack: $e');
      debugPrint('Stack trace: $stackTrace');

      // Parse the error to give a better message
      String errorMessage = 'Error: $e';
      if (e.toString().contains('CONSENT_NOT_GRANTED')) {
        errorMessage =
            'ATT permission not granted. Please check iOS Settings > Privacy & Security > Tracking and enable tracking for this app, then restart the app.';
      } else if (e
          .toString()
          .contains('ATT permission has not been requested yet')) {
        errorMessage =
            'ATT permission not requested yet. The ATT dialog should appear automatically when you initialize the SDK. If not, restart the app.';
      }

      _showSnackBar(errorMessage, isSuccess: false);
    }
  }

  Future<void> _handleIdentify() async {
    try {
      // Generate random user data
      final random = DateTime.now().millisecondsSinceEpoch.toString();
      final userId = 'user_${random.substring(random.length - 8)}';
      final username = 'user_${_generateRandomString(8)}';
      final email = '$username@example.com';
      final phone = '+1${_generateRandomDigits(10)}';

      debugPrint('🔵 Identifying user with random data...');
      debugPrint('🔵 User ID: $userId');
      debugPrint('🔵 Username: $username');
      debugPrint('🔵 Email: $email');

      await TikTokService.identify(
        externalId: userId,
        externalUserName: username,
        email: email,
        phoneNumber: phone,
      );

      _showSnackBar('User identified successfully: $username');
    } catch (e, stackTrace) {
      debugPrint('❌ Error identifying user: $e');
      debugPrint('Stack trace: $stackTrace');
      _showSnackBar('Error: $e', isSuccess: false);
    }
  }

  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      buffer.write(chars[(random + i) % chars.length]);
    }
    return buffer.toString();
  }

  String _generateRandomDigits(int length) {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    return random.substring(random.length - length).padLeft(length, '0');
  }

  Future<void> _handleLogout() async {
    try {
      await TikTokService.logout();
      _showSnackBar('User logged out successfully');
    } catch (e) {
      _showSnackBar('Error: $e', isSuccess: false);
    }
  }

  Future<void> _handleLogEvent() async {
    try {
      await TikTokService.logEvent(
        eventName: 'custom_event',
      );
      _showSnackBar('Custom event logged successfully');
    } catch (e) {
      _showSnackBar('Error: $e', isSuccess: false);
    }
  }

  Future<void> _handleViewContent() async {
    try {
      await TikTokService.logEvent(
        eventName: 'product_viewed',
        eventType: TTEventType.viewContent,
        properties: const EventProperties(
          contentId: 'product_123',
          contentType: 'product',
          contentName: 'Sample Product',
          price: 29.99,
          currency: CurrencyCode.USD,
        ),
      );
      _showSnackBar('View Content event logged successfully');
    } catch (e) {
      _showSnackBar('Error: $e', isSuccess: false);
    }
  }

  Future<void> _handleCustomEvent(
    TTEventType eventType,
    String? eventId,
    double value,
  ) async {
    try {
      final properties = EventProperties(
        value: value,
        price: value,
        currency: CurrencyCode.USD,
        quantity: 1,
      );

      await TikTokService.logEvent(
        eventName: eventType.name.toLowerCase(),
        eventType: eventType,
        eventId: eventId,
        properties: properties,
      );

      _showSnackBar('${eventType.name} event logged successfully');
    } catch (e) {
      _showSnackBar('Error: $e', isSuccess: false);
    }
  }
}
