import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/modules/auth/blocs/sign_in/sign_in_bloc.dart';
import 'package:medicins_schedules/src/modules/auth/views/forgot_password_dialog.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  bool _showPassword = false;

  bool isLoadingForm = false;

  _handleShowPassword() => setState(() {
    _showPassword = !_showPassword;
  });

  _onSave() {
    if (_formKey.currentState!.validate()) {
      context.read<SignInBloc>().add(
        SignInRequired(emailController.text, passwordController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    openForgotPasswordDialog() {
      showDialog(
        context: context,
        builder: (context) => ForgotPasswordDialog(),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 20),
      child: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInLoading) {
            setState(() {
              isLoadingForm = true;
            });
          } else if (state is SignInFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text("Incorrect email or password")),
            );
            setState(() {
              isLoadingForm = false;
            });
          } else if (state is SignInSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: const Text("User logged in")));
            setState(() {
              isLoadingForm = false;
            });
          }
        },
        child:
            isLoadingForm
                ? CircularProgressIndicator()
                : Form(
                  key: _formKey,
                  child: Column(
                    spacing: 20,
                    children: [
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: emailController,
                        label: "Email",
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.mail_rounded),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          }
                          return null;
                        },
                      ),
                      MyTextField(
                        controller: passwordController,
                        label: "Password",
                        obscureText: !_showPassword,
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(Icons.key),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: _handleShowPassword,
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      Column(
                        spacing: 5,
                        children: [
                          Row(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Forgot your password?"),
                              TextButton(
                                onPressed: openForgotPasswordDialog,
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(2),
                                    ),
                                  ),
                                ),
                                child: Text("Click here!"),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: _onSave,
                              child: Text(
                                "Login",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
