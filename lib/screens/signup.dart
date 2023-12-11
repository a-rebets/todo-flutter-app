import 'package:entry/entry.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/providers/logged_user.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  var _name = '';
  var _email = '';
  var _password = '';
  var _isSignIn = true;
  var _isNameFieldVisible = false;
  var _isLoading = false;
  var _failedAuth = false;
  final _formKey = GlobalKey<FormState>();
  final _welcomeSnackBar = const SnackBar(
      content: Text("Thanks for signing up!"),
      duration: Duration(milliseconds: 1000));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
          centerTitle: true,
        ),
        body: Center(
            child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!_isSignIn)
                  Entry.all(
                      scale: 1,
                      yOffset: 50.h,
                      visible: _isNameFieldVisible,
                      child: _nameField()),
                _emailField(),
                _passwordField(),
                _submitButton(context),
                if (!_isLoading) _modeSwitcher(),
                const Divider(height: 30),
              ],
            ),
          ),
        )));
  }

  Widget _nameField() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.h),
        child: TextFormField(
          key: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            prefixIcon: const Icon(Icons.person),
            labelText: 'Name',
          ),
          autocorrect: false,
          onChanged: (value) {
            _name = value;
          },
          validator: (value) {
            if (value != null && value.length <= 4) {
              return "Name is too short";
            }
            return null;
          },
        ));
  }

  Widget _emailField() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 18.w),
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            prefixIcon: const Icon(Icons.email),
            labelText: 'Email',
          ),
          autocorrect: false,
          onChanged: (value) {
            _email = value;
          },
          validator: (value) {
            if (value != null && !value.contains('@')) {
              return "Email does not have @";
            }
            return null;
          },
        ));
  }

  Widget _passwordField() {
    return Container(
        margin: EdgeInsets.only(top: 15.h, left: 18.w, right: 18.w),
        child: TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            prefixIcon: const Icon(Icons.lock),
            labelText: 'Password',
          ),
          autocorrect: false,
          obscureText: true,
          onChanged: (value) {
            _password = value;
          },
          validator: (value) {
            if (value != null && value.length < 6) {
              return "Password is too short";
            } else if (value != null && _failedAuth) {
              return "Email or password is incorrect";
            }
            return null;
          },
        ));
  }

  Widget _modeSwitcher() {
    return Center(
        child: RichText(
      text: TextSpan(style: Theme.of(context).textTheme.labelLarge, children: [
        TextSpan(
            text: _isSignIn ? "I'm a new user, " : "I'm already a member, "),
        TextSpan(
          text: _isSignIn ? 'Sign Up' : 'Sign In',
          style: TextStyle(
            color: Theme.of(context).colorScheme.surfaceTint,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              setState(() {
                _isNameFieldVisible = !_isNameFieldVisible;
              });
              if (!_isSignIn) {
                await Future.delayed(const Duration(milliseconds: 350));
              }
              setState(() {
                _isSignIn = !_isSignIn;
              });
            },
        ),
      ]),
    ));
  }

  Widget _submitButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 50.h),
        width: 300.w,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 15.h)),
          icon: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Text(
                _isSignIn ? 'Sign in' : 'Sign up',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w300, fontSize: 18.sp),
              )),
          label: _isLoading
              ? SizedBox(
                  width: 14.w,
                  height: 14.h,
                  child: const CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.login),
          onPressed: _isLoading
              ? null
              : () async {
                  _failedAuth = false;
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (await _saveForm()) {
                    await Future.delayed(const Duration(milliseconds: 250))
                        .then(onCorrectAuth);
                  }
                },
        ));
  }

  void onCorrectAuth(_) {
    if (!_isSignIn) {
      ScaffoldMessenger.of(context).showSnackBar(_welcomeSnackBar);
    }
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  Future<bool> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      await ref
          .read(loggedUserProvider.notifier)
          .authenticateUser(_email, _password, name: _isSignIn ? '' : _name);
      return true;
    } catch (_) {
      _failedAuth = true;
      await Future.delayed(const Duration(milliseconds: 250));
      setState(() {
        _isLoading = false;
      });
      _formKey.currentState!.validate();
      return false;
    }
  }
}
