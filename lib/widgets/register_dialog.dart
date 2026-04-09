import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/providers.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_size.dart';
import 'login_dialog.dart';

class RegisterDialog extends ConsumerStatefulWidget {
  const RegisterDialog({super.key});

  @override
  ConsumerState<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends ConsumerState<RegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    //Form eksiksiz mi
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await ref.read(userProvider.notifier).signUp(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result.success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showLoginDialog() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoginDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: r.wp(30),
                  height: r.wp(30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryPurple.withOpacity(0.2),
                        AppTheme.secondaryPurple.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.person_add_outlined,
                    size: r.wp(12),
                    color: AppTheme.primaryPurple,
                  ),
                ),
                r.verticalSpaceMedium,
                Text(
                  'Kayıt Ol',
                  style: TextStyle(
                    fontSize: r.sp(26),
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                r.verticalSpaceSmall,
                Text(
                  'Yeni hesap oluşturun',
                  style: TextStyle(
                    fontSize: r.sp(16),
                    color: AppTheme.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                r.verticalSpaceMedium,
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Ad Soyad',
                    prefixIcon:
                        Icon(Icons.person, color: AppTheme.primaryPurple),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lütfen adınızı girin';
                    }
                    if (value.trim().length < 3) {
                      return 'Ad en az 3 karakter olmalıdır';
                    }
                    return null;
                  },
                ),
                r.verticalSpaceSmall,
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    prefixIcon:
                        Icon(Icons.email, color: AppTheme.primaryPurple),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Lütfen e-posta adresinizi girin';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Geçerli bir e-posta adresi girin';
                    }
                    return null;
                  },
                ),
                r.verticalSpaceSmall,
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon:
                        const Icon(Icons.lock, color: AppTheme.primaryPurple),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppTheme.primaryPurple,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şifrenizi girin';
                    }
                    if (value.length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır';
                    }
                    return null;
                  },
                ),
                r.verticalSpaceSmall,
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Şifre Tekrar',
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: AppTheme.primaryPurple),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppTheme.primaryPurple,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen şifrenizi tekrar girin';
                    }
                    if (value != _passwordController.text) {
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                ),
                r.verticalSpaceMedium,
                SizedBox(
                  width: double.infinity,
                  height: r.wp(10),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: r.wp(10),
                            height: r.wp(10),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Kayıt Ol',
                            style: TextStyle(
                              fontSize: r.sp(16),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                r.verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Zaten hesabınız var mı? ',
                      style: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: r.sp(16),
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading ? null : _showLoginDialog,
                      child: Text(
                        'Giriş Yap',
                        style: TextStyle(
                          color: AppTheme.primaryPurple,
                          fontSize: r.sp(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
