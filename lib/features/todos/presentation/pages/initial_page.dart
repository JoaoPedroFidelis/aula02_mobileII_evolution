import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/dummyjson_auth_service.dart';
import '../../../../core/session/auth_session.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authSessionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _usernameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Usuário',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o usuário.' : null,
                      enabled: !session.isSubmitting,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a senha.' : null,
                      enabled: !session.isSubmitting,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: session.isSubmitting ? null : _submit,
                      child: session.isSubmitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Entrar'),
                    ),
                    if (session.errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        session.errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final session = ref.read(authSessionProvider);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    try {
      await session.login(
        username: _usernameCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
    } on InvalidCredentialsException {
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Credenciais inválidas.')));
    } catch (_) {
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Falha ao realizar login.')));
    }
  }
}
