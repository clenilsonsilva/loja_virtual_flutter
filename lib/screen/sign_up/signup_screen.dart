import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../models/user_manager.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final user = Userr();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (context, value, child) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      enabled: !value.loading,
                      decoration:
                          const InputDecoration(hintText: 'Nome completo'),
                      validator: (name) {
                        if (name!.isEmpty) {
                          return 'Campo Obrigatorio';
                        } else if (name.trim().split(' ').length <= 1) {
                          return 'Preencha seu nome completo';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (name) => user.name = name!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      enabled: !value.loading,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email!.isEmpty) {
                          return 'Campo Obrigatorio';
                        } else if (!emailValid(email)) {
                          return 'E-mail Invalido';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (email) => user.email = email!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      enabled: !value.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      obscureText: true,
                      validator: (pass) {
                        if (pass!.isEmpty) {
                          return 'Campo Obrigatorio';
                        } else if (pass.length < 6) {
                          return 'Muito curta';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (pass) => user.pass = pass!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      enabled: !value.loading,
                      decoration:
                          const InputDecoration(hintText: 'Repita a senha'),
                      obscureText: true,
                      validator: (pass) {
                        if (pass!.isEmpty) {
                          return 'Campo Obrigatorio';
                        } else if (pass.length < 6) {
                          return 'Muito curta';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (confirmPassword) =>
                          user.confirmPassword = confirmPassword!,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.grey,
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: value.loading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();

                                  if (user.pass != user.confirmPassword) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Senhas nao coincidem'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                }
                                value.singUp(
                                  user,
                                  (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Falha ao cadastrar: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                        child: value.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text(
                                'Criar Conta',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
