import 'package:attendance/core/extension/snackbar.dart';
import 'package:attendance/core/extension/string_validators.dart';
import 'package:attendance/core/services/local_storage.dart';
import 'package:attendance/feature/auth/provider/login_provider.dart';
import 'package:attendance/navbar_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: "sahadev@gmail.com");
  final companyCodeController = TextEditingController(text: "pa111");
  final passwordController = TextEditingController(text: "admin@admin");
  bool rememberMe = false;
  bool _obscurePassword = true;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade100, Colors.white, Colors.grey.shade50],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  _buildHeader(),
                  SizedBox(height: 50),
                  _buildLoginCard(loginProvider),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Logo/Icon Container
          // Container(
          //   width: 120,
          //   height: 120,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Colors.blue.shade600, Colors.blue.shade400],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //     shape: BoxShape.circle,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.blue.withOpacity(0.3),
          //         blurRadius: 30,
          //         spreadRadius: 5,
          //         offset: Offset(0, 10),
          //       ),
          //     ],
          //   ),
          //   child: Icon(Icons.fingerprint, size: 60, color: Colors.white),
          // ),
          SizedBox(height: 30),

          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade800,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Sign in to continue to your account',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(LoginProvider loginProvider) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: 0,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: emailController,
              label: "Email Address",
              hint: "Enter your email",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value.validateEmail(),
            ),
            SizedBox(height: 24),
            _buildTextField(
              controller: companyCodeController,
              label: "Company Code",
              hint: "Enter company code",
              icon: Icons.business_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your company code";
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            _buildTextField(
              controller: passwordController,
              label: "Password",
              hint: "Enter your password",
              icon: Icons.lock_outlined,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.green.shade600,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your password";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            _buildRememberMeRow(),
            SizedBox(height: 32),
            _buildLoginButton(loginProvider),
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
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: 14,
        //     fontWeight: FontWeight.w600,
        //     color: Colors.grey.shade700,
        //   ),
        // ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            // labelStyle: TextStyle(
            //   color: Colors.green.shade400,
            //   fontWeight: FontWeight.w400,
            // ),
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: Colors.green.shade600),
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green.shade400, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade400),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade400, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: rememberMe ? Colors.green.shade400 : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Checkbox(
            value: rememberMe,
            onChanged: (value) {
              setState(() {
                rememberMe = value ?? false;
              });
            },
            activeColor: Colors.green.shade600,
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        SizedBox(width: 12),
        Text(
          "Remember Me",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginProvider loginProvider) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: loginProvider.loginState.isLoading
              ? [Colors.grey.shade400, Colors.grey.shade300]
              : [Colors.green.shade600, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: loginProvider.loginState.isLoading
                ? Colors.grey.withOpacity(0.3)
                : Colors.green.withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loginProvider.loginState.isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loginProvider.loginState.isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    "Signing in...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    final loginProvider = context.read<LoginProvider>();

    final success = await loginProvider.loginn(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      companyCode: companyCodeController.text.trim(),
    );

    if (success) {
      await LocalStorage.setRememberMe(rememberMe);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NavBarPage()),
        (Route<dynamic> route) => false,
      );
      context.showSnackBarMessage(
        message: "Login successful!!",
        backgroundColor: Colors.green.shade600,
      );
    } else {
      context.showSnackBarMessage(
        message: loginProvider.loginState.error ?? "Login failed",
        backgroundColor: Colors.red.shade600,
      );
    }
  }
}
