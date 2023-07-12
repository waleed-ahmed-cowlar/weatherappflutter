import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:weatherapp/Presentation/Auth_screens/signup_screen.dart';
import 'package:weatherapp/Presentation/Weather_screens/weather_screen.dart';

import '../../Logic/blocs/auth/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>(); //key for form
  var passController = TextEditingController();
  var emailController = TextEditingController();
  AuthBloc authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 230,
                ),
                const Text(
                  "Weather App",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: Colors.blue),
                ),
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                              .hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return "Please enter a valid password";
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listenWhen: (previous, current) =>
                      current is AuthSuccessState,
                  listener: (context, state) {
                    if (state is AuthLoginfailedState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Login Failed")));
                    } else if (state is AuthSuccessState) {
                      Get.to(() => const WeatherScreen());
                    }
                  },
                  bloc: authBloc,
                  builder: (context, state) {
                    if (state is AuthloadingState) {
                      return const CircularProgressIndicator();
                    } else if (state is AuthErrorState) {
                      return Text(state.message);
                    }
                    return ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            authBloc.add(AuthLoginButtonEvent(
                                email: emailController.text,
                                password: passController.text));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 40),
                        ),
                        child: const Text("Login",
                            style: TextStyle(fontSize: 18)));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Get.to(const SignUpScreen());
                      },
                      child: const Text("Sign Up"),
                    )
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
