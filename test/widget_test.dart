import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_ai/providers/auth_provider.dart';
import 'package:task_ai/screens/login_screen.dart';

// AuthProvider falso que NO construye AuthService ni cliente Supabase, así el
// widget test no depende de la red ni de plugins nativos.
class FakeAuthProvider extends ChangeNotifier implements AuthProvider {
  @override
  bool get isLoading => false;
  @override
  String? get error => null;
  @override
  User? get currentUser => null;
  @override
  bool get isAuthenticated => false;
  @override
  void clearError() {}
  @override
  Future<bool> signIn(String email, String password) async => false;
  @override
  Future<bool> signUp(String email, String password) async => false;
  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets('LoginScreen muestra el formulario de inicio de sesión',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: FakeAuthProvider(),
          child: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('TaskAI'), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(
      find.text('Inicia sesión para sincronizar tus tareas en tiempo real'),
      findsOneWidget,
    );
    // Campos de correo y contraseña presentes.
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
