import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../models/http_exception.dart';
import 'auth_manager.dart';
import '../share/dialog_utils.dart';

enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late AuthMode _authMode; // Đổi từ final sang late
  bool isWelcomeScreen = true;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final _isSubmitting = ValueNotifier<bool>(false);
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _isSubmitting.value = true;

    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await context.read<AuthManager>().login(
              _authData['email']!,
              _authData['password']!,
            );
      } else {
        // Sign user up
        await context.read<AuthManager>().signup(
              _authData['email']!,
              _authData['password']!,
            );
      }
    } catch (error) {
      if (context.mounted) {
        showErrorDialog(
            context,
            (error is HttpException)
                ? error.toString()
                : 'Authentication failed');
      }
    }

    _isSubmitting.value = false;
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isWelcomeScreen
        ? Expanded(child: _buildIsWelcome())
        : _buildFormAuth();
  }


  Widget _buildFormAuth() {
    final deviceSize = MediaQuery.sizeOf(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/auth-bg.png'),
                fit: BoxFit.cover)),
        height: _authMode == AuthMode.signup ? deviceSize.height : 1000,
        constraints: BoxConstraints(
            minHeight: _authMode == AuthMode.signup ? deviceSize.height : 1000),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(25)),
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                          _authMode == AuthMode.login ? 'Đăng Nhập' : 'Đăng Ký',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown)),
                      _buildEmailField(),
                      _buildPasswordField(),
                      if (_authMode == AuthMode.signup)
                        _buildPasswordConfirmField(),
                      const SizedBox(
                        height: 20,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isSubmitting,
                        builder: (context, isSubmitting, child) {
                          if (isSubmitting) {
                            return Center(
                                child: Lottie.network(
                                  height: 100,
                                    'https://lottie.host/664d5ad7-d8ba-48b7-8dca-b4b506cb8926/OrSvcDYftE.json'));
                          }
                          return _buildSubmitButton();
                        },
                      ),
                      _buildAuthModeSwitchButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      ),
      child: Text(_authMode == AuthMode.login ? 'Đăng Nhập' : 'Đăng Ký'),
    );
  }

  Widget _buildPasswordConfirmField() {
    return TextFormField(
      enabled: _authMode == AuthMode.signup,
      decoration: const InputDecoration(labelText: 'Confirm Password'),
      obscureText: true,
      validator: _authMode == AuthMode.signup
          ? (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match!';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildAuthModeSwitchButton() {
    return TextButton(
      onPressed: _switchAuthMode,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: Text(
          '${_authMode == AuthMode.login ? 'Đăng Ký' : 'Đăng Nhập'} Tại Đây'),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: _passwordController,
      validator: (value) {
        if (value == null || value.length < 5) {
          return 'Password is too short!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['password'] = value!;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'E-Mail'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty || !value.contains('@')) {
          return 'Invalid email!';
        }
        return null;
      },
      onSaved: (value) {
        _authData['email'] = value!;
      },
    );
  }

  Widget _buildIsWelcome() {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/image/background.png'),
              fit: BoxFit.cover)),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 400,
            left: 30,
            child: FilledButton.tonal(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color?>(
                      Color.fromARGB(255, 133, 74, 37)),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (Set<MaterialState> states) {
                    return Theme.of(context).colorScheme.surfaceTint;
                  }),
                  minimumSize:
                      MaterialStateProperty.all<Size?>(const Size(300, 50))),
              onPressed: () => {
                isWelcomeScreen = false,
                setState(() {
                  _authMode = AuthMode.signup;
                })
              },
              child: const Text(
                "Đăng ký",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(221, 252, 252, 252)),
              ),
            ),
          ),
          Positioned(
            top: 460,
            left: 30,
            child: OutlinedButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color?>(
                      Color.fromARGB(255, 255, 255, 255)),
                  minimumSize:
                      MaterialStateProperty.all<Size?>(const Size(300, 50))),
              onPressed: () => {
                isWelcomeScreen = false,
                setState(() {
                  _authMode = AuthMode.login;
                })
              },
              child: const Text(
                "Đăng Nhập",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(221, 132, 50, 0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
