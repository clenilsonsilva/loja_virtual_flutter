import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/gradient.dart';
import '../../helpers/validators.dart';
import '../../models/user.dart';
import '../../models/user_manager.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final user = Userr();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final cpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          const Gradientt(),
          Center(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: formKey,
                child: Consumer<UserManager>(
                  builder: (_, userManager, __) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      shrinkWrap: true,
                      children: [
                        TextFormField(
                          controller: nameController,
                          enabled: !userManager.loading,
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
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          enabled: !userManager.loading,
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
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passController,
                          enabled: !userManager.loading,
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
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: cpassController,
                          enabled: !userManager.loading,
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
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              disabledBackgroundColor: Colors.grey,
                              backgroundColor: Theme.of(context).primaryColor),
                          onPressed: userManager.loading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();

                                    if (passController.text !=
                                        cpassController.text) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Senhas nao coincidem'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    } else {
                                      userManager.singUp(
                                        Userr(
                                            name: nameController.text,
                                            email: emailController.text,
                                            pass: passController.text,
                                            confirmPassword:
                                                cpassController.text),
                                        (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Falha ao cadastrar: $e'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        },
                                        () {
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    }
                                  }
                                },
                          child: userManager.loading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Criar Conta',
                                  style: TextStyle(fontSize: 15),
                                ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
