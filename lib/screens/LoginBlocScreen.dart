import 'package:flutter/material.dart';
import 'package:midastouch/blocs/AuthBloc.dart';
import 'package:midastouch/repositories/AuthRepository.dart';

class LoginBlocScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginBlocScreenState();
}

class _LoginBlocScreenState extends State<LoginBlocScreen> {
  AuthBloc _authBloc;
  final AuthRepository _repository = AuthRepository();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(this._repository);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {}

  void _onPasswordChanged() {}

  void _onSubmitPressed() {
    var data = {
      "phoneOrEmail": _emailController.text,
      "password": _passwordController.text,
      "deviceType": "ios",
      "deviceToken": "string"
    };
    _authBloc.authenticateUser(data, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: StreamBuilder<AuthState>(
          stream: _authBloc.loginUser,
          initialData: AuthInitState(),
          builder: (context, snapshot) {
            if (snapshot.data is AuthInitState) {
              return _formBody();
            }
            if (snapshot.data is AuthDataState) {
              return _formBody();
            }
            if (snapshot.data is AuthLoadingState) {
              return _buildLoading();
            }
            if (snapshot.data is AuthErrorState) {
              return _formBody();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorContent(data) {
    return Center(
      child: Text(data == null ? 'Something went wromng' : data.message),
    );
  }

  Widget _formBody() {
    return Form(
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              labelText: 'Email',
            ),
            autovalidate: true,
            validator: (_) {},
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'Password',
            ),
            obscureText: true,
            autovalidate: true,
            validator: (_) {},
          ),
          RaisedButton(
            onPressed: _onSubmitPressed,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
