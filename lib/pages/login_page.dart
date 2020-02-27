import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_paul_test/pages/signup_page.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
//LoginPage({this.context});
//final BuildContext context;
//  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
//}
}

class _LoginPageState extends State<LoginPage> {
  String _errorMessage;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    final _formKey = new GlobalKey<FormState>();
    String _email = '';
    String _password = '';

    // Check if form is valid before perform login or signup
    bool Formvalidated() {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    // Perform login or signup
    Future<bool> validateAndSubmit() async {
      _errorMessage = "";
      bool _validated = false;
      if (Formvalidated()) {
        String userId;
        _isLoading = true;
        try {
          userId = await auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
          _isLoading = false;
          _validated = true;
        } catch (e) {
          print('Error: $e');
          _isLoading = false;
          _errorMessage = e.message;
//        _formKey.currentState.reset();

        }
      }
      return _validated;
    }

    void resetForm() {
      _formKey.currentState.reset();
      _errorMessage = "";
    }

    Widget _showCircularProgress() {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return Container(
        height: 0.0,
        width: 0.0,
      );
    }

    Widget showErrorMessage() {
      if (_errorMessage.length > 0 && _errorMessage != null) {
        return new Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        );
      } else {
        return new Container(
          height: 0.0,
        );
      }
    }

    Widget showLogo() {
      return new Hero(
        tag: 'hero',
        flightShuttleBuilder: (
          BuildContext flightContext,
          Animation<double> animation,
          HeroFlightDirection flightDirection,
          BuildContext fromHeroContext,
          BuildContext toHeroContext,
        ) {
          final Hero toHero = toHeroContext.widget;
          return RotationTransition(
            turns: animation,
            child: toHero.child,
          );
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 48.0,
            child: Image.asset('assets/logoLCCLekki.png'),
            // Image.asset('assets/flutter-icon.png'),
          ),
        ),
      );
    }

    Widget showExplanation() {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: Center(
          child: Container(
              child: new Text('Login to your account',
                  style:
                      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
        ),
      );
      //  onPressed: () {});
    }

    Widget showEmailInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
            labelText: 'Toll ID',
            alignLabelWithHint: false,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFD97A00), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            labelStyle: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.grey),
//            icon: new Icon(
//              Icons.mail,
//              color: Colors.grey,
//            ),
          ),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          inputFormatters: [
            BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
          ],
          onSaved: (value) => _email = value.trim(),
        ),
      );
    }

    Widget showPasswordInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
            labelText: 'Password',
            alignLabelWithHint: false,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFD97A00), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            labelStyle: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
//          icon: new Icon(
//            Icons.lock,
//            color: Colors.grey,
//          ),
          ),
          validator: (value) =>
              value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value.trim(),
        ),
      );
    }

    Widget showIforgotmyPassword() {
      return new FlatButton(
          child: new Text('I forgot my password',
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0x8FD97A00))),
          onPressed: () {});
    }

    Widget showSecondaryButton() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account? ',
            style: new TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: Color(0xAFD97A00),
            ),
          ),
          new FlatButton(
              child: Text(
                'Sign Up',
                style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xAFD97A00),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupPage(),
                    ));
              }),
        ],
      );
    }

    Widget showGetInButton() {
      return new Padding(
          padding: EdgeInsets.fromLTRB(80.0, 45.0, 80.0, 5.0),
          child: SizedBox(
            height: 66.0,
            child: RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(33.0),
              ),
              color: Color(0xFFD97A00),
              child: new Text('Get In',
                  style: new TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              onPressed: () async {
                if (await validateAndSubmit() == true) {
                  Navigator.pushNamed(context, '/home');
                }
              },
            ),
          ));
    }

    Widget _showForm() {
      return new Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                showLogo(),
                showExplanation(),
                showEmailInput(),
                showPasswordInput(),
                showIforgotmyPassword(),
                showGetInButton(),
                showSecondaryButton(),
                showErrorMessage(),
              ],
            ),
          ));
    }

    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Flutter login demo'),
//        ),
      body: Stack(
        children: <Widget>[
          _showForm(),
          _showCircularProgress(),
        ],
      ),
    );
  }
}
