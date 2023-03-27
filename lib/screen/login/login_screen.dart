import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../models/user_manager.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
              key: formKey,
              child: Consumer<UserManager>(
                builder: (context, value, child) {
                  return ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        enabled: !value.loading,
                        controller: emailController,
                        decoration: const InputDecoration(hintText: 'E-mail'),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (email) {
                          if (email!.isNotEmpty) {
                            if (!emailValid(email)) {
                              return 'Email Invalido';
                            } else {
                              return null;
                            }
                          } else {
                            return 'Email Invalido';
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        enabled: !value.loading,
                        controller: passController,
                        decoration: const InputDecoration(hintText: 'Senha'),
                        autocorrect: false,
                        obscureText: true,
                        validator: (pass) {
                          if (pass!.isNotEmpty) {
                            if (pass.length < 6) {
                              return 'Senha invalida';
                            } else {
                              return null;
                            }
                          } else {
                            return 'Senha invalida';
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Esqueci minha senha'),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: value.loading ? Colors.grey[700] : Theme.of(context).primaryColor),
                          onPressed: value.loading ? null : () {
                            if (formKey.currentState!.validate()) {
                              value.signIn(
                                  user: Userr(emailController.text,
                                      passController.text),
                                  onFail: (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Falha ao entrar: $e'),
                                      backgroundColor: Colors.red,
                                    ));
                                  },
                                  onSucess: () {
                                    // TODO: FECHAR TELA DE LOGIN
                                  });
                            }
                          },
                          child: value.loading ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ) : const Text(
                            'Entrar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
