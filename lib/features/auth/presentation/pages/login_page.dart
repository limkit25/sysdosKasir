import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../../core/widgets/max_width_container.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is AuthAuthenticated) {
            // Navigate to Dashboard
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('auth.login_success'.tr()), backgroundColor: Colors.green),
            );
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: MaxWidthContainer(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/splash.png',
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'auth.sign_in_continue'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 48),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'auth.email_phone'.tr(),
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'auth.required'.tr();
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'auth.pin_password'.tr(),
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (_) => _onLoginPressed(),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'auth.required'.tr();
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return ElevatedButton(
                            onPressed: _onLoginPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2962FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('auth.login_btn'.tr(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
