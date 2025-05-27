import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lab1/model/user.dart';
import 'package:lab1/repositories/date_repository.dart';
import 'package:lab1/repositories/hive_date_repository.dart';
import 'package:lab1/repositories/hive_network_repository.dart';
//import 'package:lab1/repositories/hive_date_repository.dart';
import 'package:lab1/repositories/hive_registration_repository.dart';
import 'package:lab1/repositories/network_repository.dart';
import 'package:lab1/utils/user_preferences.dart';
import 'package:lab1/widget/home.dart';
import 'package:lab1/widget/registration.dart';
//import 'package:lab1/repositories/hive_network_repository.dart';

class LoginPage extends StatefulWidget {
  final NetworkService networkService;
  const LoginPage({required this.networkService, super.key});

  @override
  LoginPageState createState() => LoginPageState();
} 

class LoginPageState extends State<LoginPage> {
  final _repo = HiveAuthRepository();
  final IdeaRepository ideasRepository = HiveIdeaRepository();
  final NetworkService networkService = HiveNetworkService();

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //_repo.init();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    //перевірка на з'єднання до інтернету
    final connected = await widget.networkService.isConnected();
    if (!connected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Немає з’єднання з Інтернетом')),
        );
      }
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    final User? user = await _repo.login(_email, _password);

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    if (user != null) {
      UserPreferences.myUser = user;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<MyHomePage>(
          builder: (_) => MyHomePage(
            title: 'Ідеї для побачень',
            ideasRepository: ideasRepository,
            networkService: networkService
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_header(), _inputField(), _signup(context)],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return const Column(
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text('Enter your credentials to login'),
      ],
    );
  }

  Widget _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withAlpha((0.1 * 255).round()),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
          validator: (v) => v == null || v.isEmpty ? 'Enter email' : null,
          onSaved: (v) => _email = v!.trim(),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.purple.withAlpha((0.1 * 255).round()),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
          validator: (v) => v == null || v.length < 6 ? 'Min 6 chars' : null,
          onSaved: (v) => _password = v!,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _isLoading ? null : _login,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Login', style: TextStyle(fontSize: 20)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<AllUsersPage>(
                builder: (_) => const AllUsersPage(),
              ),
            );
          },
          child: const Text('Show All Users'),
        ),
      ],
    );
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<SignupPage>(
                builder: (context) => const SignupPage(),
              ),
            );
          },
          child: const Text('Sign Up', style: TextStyle(color: Colors.purple)),
        ),
      ],
    );
  }
}

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<User>('users');
    final users = box.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('All Users')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(user.username),
            subtitle: Text(
              'Username: ${user.username}, Email: ${user.email},'
              'Password:${user.password}, Photo: ${user.photo}',
            ),
          );
        },
      ),
    );
  }
}
