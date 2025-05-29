import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';
import 'package:urchat/butter/bfdemo.dart';
import 'package:urchat/grid.dart';
import 'package:urchat/meteor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const URChatApp());
}

class URChatApp extends StatefulWidget {
  const URChatApp({super.key});

  @override
  State<URChatApp> createState() => _URChatAppState();
}

class _URChatAppState extends State<URChatApp> {
  ThemeMode _themeMode = ThemeMode.system;
  int _selectedTheme = 0;
  bool _isDarkMode = false;

  final List<ThemeData> _lightThemes = [];
  final List<ThemeData> _darkThemes = [];
  final List<String> _themeNames = ['Elegant', 'Modern', 'Cute'];

  @override
  void initState() {
    super.initState();
    _initializeThemes();
    _loadThemePreferences().then((_) {
      if (mounted) setState(() {});
    });
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null) {
      final context = GlobalKey<NavigatorState>().currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.notification!.title ?? 'New message'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      }
    }
  }

  // Replace your _initializeThemes() method with this:

  void _initializeThemes() {
    _lightThemes.clear();
    _darkThemes.clear();

    //Cute theme
    _lightThemes.add(ThemeData(
      primaryColor: const Color(0xFFE91E63),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFE91E63),
        secondary: Color(0xFFEC407A),
        surface: Color(0xFFFFF5F7),
        background: Color(0xFFFFF9FB),
        onSurface: Color(0xFF333333),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: const Color(0xFF333333),
        displayColor: const Color(0xFF333333),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFFE91E63),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
    ));

    _darkThemes.add(ThemeData(
      primaryColor: const Color(0xFFEC407A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFEC407A),
        secondary: Color(0xFFF06292),
        surface: Color(0xFF1E1E2E),
        background: Color(0xFF121212),
        onSurface: Color(0xFFE0E0E0),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: const Color(0xFFE0E0E0),
        displayColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1E1E2E),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFFEC407A),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    ));

    // Theme 0: Elegant
    _lightThemes.add(ThemeData(
      primaryColor: const Color(0xFF2E4057),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2E4057),
        secondary: Color(0xFF4A6FA5),
        surface: Color(0xFFF8F9FA),
        background: Color(0xFFFFFFFF),
        onSurface: Color(0xFF212529),
      ),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: const Color(0xFF212529),
        displayColor: const Color(0xFF212529),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF2E4057),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
    ));

    _darkThemes.add(ThemeData(
      primaryColor: const Color(0xFF4A6FA5),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4A6FA5),
        secondary: Color(0xFF6B8CBC),
        surface: Color(0xFF1A1A2E),
        background: Color(0xFF121212),
        onSurface: Color(0xFFE0E0E0),
      ),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: const Color(0xFFE0E0E0),
        displayColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xFF1A1A2E),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF4A6FA5),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    ));

    // Elegant
    _lightThemes.add(ThemeData(
      primaryColor: const Color(0xFF5D737E),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF5D737E),
        secondary: Color(0xFF7A8B99), // Lighter slate
        surface: Color(0xFFF8F9FA), // Very light gray
        background: Color(0xFFFFFFFF), // White
        onSurface: Color(0xFF3A3A3A), // Dark gray
      ),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: const Color(0xFF3A3A3A),
        displayColor: const Color(0xFF3A3A3A),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        margin: const EdgeInsets.all(8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF5D737E),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
    ));

    _darkThemes.add(ThemeData(
      primaryColor: const Color(0xFF7A8B99),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7A8B99), // Lighter slate
        secondary: Color(0xFF5D737E), // Slate blue-gray
        surface: Color(0xFF1E2A32), // Dark slate
        background: Color(0xFF121A21), // Very dark slate
        onSurface: Color(0xFFE0E3E7), // Light gray
      ),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: const Color(0xFFE0E3E7),
        displayColor: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xFF1E2A32),
        margin: const EdgeInsets.all(8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF7A8B99),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    ));
  }

  Future<void> _loadThemePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
        _selectedTheme = prefs.getInt('selectedTheme') ?? 0;
        _isDarkMode = prefs.getBool('isDarkMode') ??
            (WidgetsBinding.instance.window.platformBrightness ==
                Brightness.dark);
      });
    }
  }

  Future<void> _changeTheme(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedTheme', index);
    if (mounted) {
      setState(() {
        _selectedTheme = index;
      });
    }
  }

  Future<void> _changeThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    await prefs.setBool('isDarkMode', mode == ThemeMode.dark);
    if (mounted) {
      setState(() {
        _themeMode = mode;
        _isDarkMode = mode == ThemeMode.dark;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URChat',
      debugShowCheckedModeBanner: false,
      theme: _lightThemes.isNotEmpty
          ? _lightThemes[_selectedTheme]
          : ThemeData.light(),
      darkTheme: _darkThemes.isNotEmpty
          ? _darkThemes[_selectedTheme]
          : ThemeData.dark(),
      themeMode: _themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          return const AuthWrapper();
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        if (snapshot.hasData) {
          return const ChatScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo with multiple effects
            Image.asset(
              'assets/img.png',
              width: 150,
              height: 150,
            )
                .animate()
                .fadeIn(delay: 100.ms, duration: 800.ms) // Fade in first
                .scale(delay: 300.ms, duration: 500.ms) // Gentle scale up
                .then(delay: 200.ms) // Brief pause
                .shake(duration: 600.ms, hz: 4) // Subtle shake
                .then() // Pause before next animation
                .tint(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2))
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                    end: const Offset(1.05, 1.05),
                    duration: 1500.ms,
                    curve: Curves.easeInOutSine), // Gentle pulsing

            const SizedBox(height: 30),

            // Text with staggered animation
            Text('URChat',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          offset: const Offset(0, 2),
                        )
                      ],
                    ))
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms)
                .slideY(begin: 0.5, end: 0, curve: Curves.easeOutBack),

            const SizedBox(height: 10),

            // Subtitle with animation
            Text('Connecting...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.7),
                        ))
                .animate()
                .fadeIn(delay: 800.ms, duration: 400.ms)
                .blurXY(begin: 5, end: 0),

            const SizedBox(height: 40),

            // Animated progress indicator
            SizedBox(
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  minHeight: 6,
                  backgroundColor:
                      Theme.of(context).colorScheme.surface.withOpacity(0.4),
                  color: Theme.of(context).colorScheme.primary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 1200.ms).scaleX(
                begin: 0, end: 1, duration: 800.ms, curve: Curves.easeOutExpo),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Update FCM token on login
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({'fcmToken': token}, SetOptions(merge: true));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Login failed'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit URChat?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, size: 60, color: Colors.pink)
                    .animate()
                    .scale(duration: 500.ms),
                const SizedBox(height: 20),
                Text('Welcome Back!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email,
                        color: Theme.of(context).colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock,
                        color: Theme.of(context).colorScheme.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.white.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Login',
                          style: Theme.of(context).textTheme.titleMedium),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isSending = false;
  int _selectedTheme = 0;
  bool _isDarkMode = false;
  final List<String> _themeNames = ['Cute', 'Modern', 'Elegant'];
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    _updateFcmToken();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIdx = prefs.getInt('selectedTheme') ?? 0;
    final modeIndex = prefs.getInt('themeMode') ?? 0;
    final isDark = prefs.getBool('isDarkMode') ?? false;

    if (mounted) {
      setState(() {
        _selectedTheme = themeIdx;
        _themeMode = ThemeMode.values[modeIndex];
        _isDarkMode = isDark;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: 300.ms,
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _updateFcmToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({'fcmToken': token}, SetOptions(merge: true));
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    _messageController.clear();

    setState(() => _isSending = true);
    try {
      await _firestore.collection('messages').add({
        'text': message,
        'senderId': _currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _scrollToBottom();
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _logout();
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      // Show loading indicator if needed
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logging out...')),
        );
      }

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear navigation stack and redirect to login
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _changeTheme(int themeIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedTheme', themeIndex);
    if (mounted) {
      setState(() {
        _selectedTheme = themeIndex;
      });

      final appState = context.findAncestorStateOfType<_URChatAppState>();
      appState?._changeTheme(themeIndex);
    }
  }

  Future<void> _changeThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
    await prefs.setBool('isDarkMode', mode == ThemeMode.dark);

    if (mounted) {
      setState(() {
        _themeMode = mode;
        _isDarkMode = mode == ThemeMode.dark;
      });

      final appState = context.findAncestorStateOfType<_URChatAppState>();
      appState?._changeThemeMode(mode);
    }
  }

  bool _shouldShowTime(DateTime? currentTime, DateTime? previousTime) {
    if (previousTime == null) return true;
    if (currentTime == null) return false;
    return currentTime.difference(previousTime).inMinutes >= 2;
  }

  void _showThemeMenu() {
    final RenderBox appBarBox = context.findRenderObject() as RenderBox;
    final Offset appBarPosition = appBarBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        screenWidth - 220,
        appBarPosition.dy + appBarBox.size.height,
        16,
        0,
      ),
      items: [
        // Theme mode toggle
        PopupMenuItem(
          onTap: () {
            _changeThemeMode(_isDarkMode ? ThemeMode.light : ThemeMode.dark);
          },
          child: ListTile(
            leading: Icon(
              _isDarkMode ? Iconsax.sun_1 : Iconsax.moon,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(_isDarkMode ? 'Light Mode' : 'Dark Mode'),
          ),
        ),

        // Theme type selector
        PopupMenuItem(
          enabled: false, // disables tap but shows content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme Style',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: List.generate(_themeNames.length, (index) {
                  return ChoiceChip(
                    label: Text(_themeNames[index]),
                    selected: _selectedTheme == index,
                    onSelected: (selected) {
                      if (selected) {
                        Navigator.pop(context);
                        _changeTheme(index);
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
    );
  }

  Widget _background(int themeIndex) {
    switch (themeIndex) {
      case 2:
        return Center(
          child: MeteorShower(
              isDark: Theme.of(context).brightness == Brightness.dark,
              numberOfMeteors: 10,
              duration: Duration(seconds: 5),
              child: Container(
                height: MediaQuery.of(context).size.height,
              )),
        );

      case 1:
        return AnimatedGridPattern(
          squares: List.generate(20, (index) => [index % 5, index ~/ 5]),
          gridSize: 40,
          skewAngle: 12,
        );
      case 0:
        return ButterflyDemo();

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarIconsColor =
        Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white;

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit URChat?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text('URChat',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              tooltip: 'Theme Settings',
              icon: Icon(Iconsax.paintbucket, color: appBarIconsColor),
              onPressed: _showThemeMenu,
            ),
            IconButton(
              tooltip: 'Logout',
              icon: Icon(Iconsax.logout, color: appBarIconsColor),
              onPressed: _showLogoutDialog,
            ),
          ],
          centerTitle: true,
        ),
        body: Stack(
          children: [
            _background(_selectedTheme),
            Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('messages')
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final messages = snapshot.data!.docs;
                      DateTime? previousTime;

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToBottom();
                      });

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message['senderId'] == _currentUser?.uid;
                          final currentTime = message['timestamp']?.toDate();
                          final showTime =
                              _shouldShowTime(currentTime, previousTime);
                          if (showTime) {
                            previousTime = currentTime;
                          }

                          return Column(
                            children: [
                              if (showTime && currentTime != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    DateFormat('h:mm a').format(currentTime),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                        ),
                                  ),
                                ),
                              MessageBubble(
                                key: ValueKey(message.id),
                                isMe: isMe,
                                text: message['text'],
                                timestamp: showTime ? currentTime : null,
                                onDelete: () => _deleteMessage(
                                    message.id, message['senderId']),
                              ).animate().fadeIn(delay: (index * 50).ms),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            suffixIcon: _isSending
                                ? const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  )
                                : null,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        onPressed: _isSending ? null : _sendMessage,
                        child: const Icon(Icons.send_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteMessage(String messageId, String senderId) async {
    if (_currentUser?.uid != senderId) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You can only delete your own messages')),
        );
      }
      return;
    }
    await _firestore.collection('messages').doc(messageId).delete();
  }
}

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String? text;
  final DateTime? timestamp;
  final VoidCallback? onDelete;

  const MessageBubble({
    super.key,
    required this.isMe,
    this.text,
    this.timestamp,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: GestureDetector(
          onLongPress: () {
            if (onDelete != null && isMe) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Message'),
                  content: const Text(
                      'Are you sure you want to delete this message?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        onDelete!();
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isMe
                  ? colorScheme.primary
                  : colorScheme.surface.withOpacity(0.9),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft:
                    isMe ? const Radius.circular(16) : const Radius.circular(4),
                bottomRight:
                    isMe ? const Radius.circular(4) : const Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (text != null)
                  Text(
                    text!,
                    style: TextStyle(
                      color: isMe ? Colors.white : colorScheme.onSurface,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
