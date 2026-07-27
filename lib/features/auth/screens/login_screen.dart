import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _error = null);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      await auth.loginWithEmail(email: _emailController.text.trim(), password: _passwordController.text);
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(gradient: AppColors.goldGradient, shape: BoxShape.circle),
                  child: const Icon(Icons.palette, size: 40, color: AppColors.primaryBlack),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text("Welcome Back", style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryWhite)),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text("Sign in to continue your art journey", style: GoogleFonts.poppins(fontSize: 14, color: AppColors.mediumGrey)),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.primaryWhite),
                      decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryGold), hintText: 'artist@donlee.art'),
                      validator: (v) => v != null && v.contains('@') ? null : 'Enter valid email',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      style: const TextStyle(color: AppColors.primaryWhite),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryGold),
                        suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.mediumGrey), onPressed: () => setState(() => _obscure = !_obscure)),
                      ),
                      validator: (v) => v != null && v.length >= 6 ? null : 'Min 6 characters',
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: () {}, child: Text("Forgot Password?", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontSize: 13))),
                    ),
                    if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.error)),
                        child: Row(children: [const Icon(Icons.error_outline, color: AppColors.error, size: 16), const SizedBox(width: 8), Expanded(child: Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13)))]),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: auth.isLoading ? null : _login,
                        child: auth.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBlack)) : const Text("LOGIN"),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.mediumGrey.withOpacity(0.3))),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text("OR", style: GoogleFonts.poppins(color: AppColors.mediumGrey, fontSize: 12))),
                        Expanded(child: Divider(color: AppColors.mediumGrey.withOpacity(0.3))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: const Text("Continue with Google"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: GoogleFonts.poppins(color: AppColors.mediumGrey)),
                  GestureDetector(onTap: () => Navigator.pushNamed(context, '/register'), child: Text("Sign Up", style: GoogleFonts.poppins(color: AppColors.primaryGold, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 20),
              Center(child: Text(AppConstants.version, style: GoogleFonts.poppins(color: AppColors.darkGrey, fontSize: 11))),
            ],
          ),
        ),
      ),
    );
  }
}
