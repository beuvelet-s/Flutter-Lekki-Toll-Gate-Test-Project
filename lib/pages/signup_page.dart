import 'package:country_code_picker/country_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_paul_test/pages/account_created_page.dart';
import 'package:flutter_app_paul_test/services/authentication.dart';
import 'package:flutter_app_paul_test/services/country_service.dart';
import 'package:flutter_app_paul_test/services/input_formatters.dart';
import 'package:flutter_app_paul_test/services/payment_card.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
//  SignupPage({this.auth, this.loginCallback});
//
//  final BaseAuth auth;
//  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  String _errorMessage = "";
  bool _isLoading = false;
  String _countrycode = '';
  String _name = '';
  String _email = '';
  String _password = '';
  String _phone = '';
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);

    // Check if form is valid before perform login or signup
    bool validateAndSave() {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      } else {
        setState(() {
          _autoValidate = true;
        });
        return false;
      }
    }

    void validateAndSubmit() async {
      setState(() {
        _errorMessage = "";
      });
      if (validateAndSave()) {
        String userId = "";
        User user;
        setState(() {
          _isLoading = true;
        });
        try {
          userId = await auth.createUserWithEmailAndPassword(
              _email.trim(), _password.trim());
          auth.sendEmailVerification();
// Update Display Name in authentication Firebase user
          auth.getCurrentUser().then((val) {
            UserUpdateInfo updateUser = UserUpdateInfo();
            updateUser.displayName = _name;
//            updateUser.photoUrl = picURL;
            val.updateProfile(updateUser);
          });
          print('Signed up user: $userId');
          setState(() {
            _isLoading = false;
          });
          Navigator.pushNamed(context, '/accountcreated');
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
            _errorMessage = e.message;
            //         _formKey.currentState.reset();
          });
        }
      } else {
        //If all data are not valid then start auto validation.
        setState(() {
          _autoValidate = true;
        });
      }
    }

    String validateName(String value) {
      if (value.length < 3)
        return 'Name must be more than 2 charater';
      else
        return null;
    }

    String validateEmail(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value))
        return 'Enter Valid Email';
      else
        return null;
    }

    String validatePhone(String value) {
// TODO Check digits number required for all other countries
      if (value.length != 18 && _countrycode == '+234')
        return 'Phone Number must be of 11 digit including leading (0)';
      else
        return null;
    }

    String validatePassword(String value) {
// PAssword are of minimum 6 digit only
      if (value.length < 6)
        return 'Password must be of minimum 6 digit';
      else {
        print('PAssword = $value');
        return null;
      }
    }

//  void resetForm() {
//    _formKey.currentState.reset();
//    _errorMessage = "";
//  }
//
//  void toggleFormMode() {
//    resetForm();
//  }

    Widget _showCircularProgress() {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      }
      return Container(
        height: 0.0,
        width: 0.0,
      );
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
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
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
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Center(
          child: Container(
              child: new Text('Create Account',
                  style:
                      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
        ),
      );
      //  onPressed: () {});
    }

    Widget showNameInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            labelText: 'Name',
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
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
//            icon: new Icon(
//              Icons.mail,
//              color: Colors.grey,
//            ),
          ),
//        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          validator: validateName,
//        inputFormatters: [
//          BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
//        ],
          onSaved: (value) => _name = value.trim(),
        ),
      );
    }

    Widget showEmailInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            labelText: 'Email',
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
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
//            icon: new Icon(
//              Icons.mail,
//              color: Colors.grey,
//            ),
          ),
          validator: validateEmail,
          inputFormatters: [
            BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
          ],
          onSaved: (value) => _email = value.trim(),
        ),
      );
    }

    Widget showPhoneInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Row(
          children: <Widget>[
            SizedBox(width: 30),
            Expanded(
              flex: 1,
              child: CountryCodePickerCustom(
                textStyle: TextStyle(fontSize: 16),
                onChanged: (CountryCode code) => {_countrycode = code.dialCode},
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: 'NG',
                favorite: ['+234', 'NG'],
                // optional. Shows only country name and flag
                showCountryOnly: true,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
              ),
            ),
            Expanded(
              flex: 3,
              child: new TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.phone,
                autofocus: false,
                decoration: new InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  labelText: 'Phone',
                  hintText: '(0)## ## ## ## ##',
                  alignLabelWithHint: false,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFFD97A00), width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
//            icon: new Icon(
//              Icons.mail,
//              color: Colors.grey,
//            ),
                ),
//        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                validator: validatePhone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  new LengthLimitingTextInputFormatter(11),
                  PhoneInputFormatter()
                  //                 BlacklistingTextInputFormatter(new RegExp(r"\s  \b|\b\s"))
                ],
                onSaved: (value) {
                  _phone = _countrycode + CardUtils.getCleanedNumber(value);
                },
              ),
            ),
            SizedBox(width: 30),
          ],
        ),
      );
    }

    Widget showPasswordInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
        child: new TextFormField(
          controller: _pass,
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
//          icon: new Icon(
//            Icons.lock,
//            color: Colors.grey,
//          ),
          ),
//        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
          validator: validatePassword,
//          validator: (val) {
//            if (val.isEmpty) return 'Empty';
//            return null;
//          },
          inputFormatters: [
            BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
          ],
          onSaved: (value) => _password = value.trim(),
        ),
      );
    }

    Widget showConfirmationPasswordInput() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
        child: new TextFormField(
          controller: _confirmPass,
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            labelText: 'Confirm Password',
            alignLabelWithHint: false,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFD97A00), width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            labelStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
//          icon: new Icon(
//            Icons.lock,
//            color: Colors.grey,
//          ),
          ),
//        validator: (value) =>
//            (value != _password) ? 'Password need to be the same!' : null,
          validator: (val) {
            if (val.isEmpty) return 'Empty';
            if (val != _pass.text) return 'Not Match';
            return null;
          },
          inputFormatters: [
            BlacklistingTextInputFormatter(new RegExp(r"\s\b|\b\s"))
          ],
//        onSaved: (value) => _password = value.trim(),
        ),
      );
    }

    Widget showCreateAccountButton() {
      return new Padding(
          padding: EdgeInsets.fromLTRB(80.0, 20.0, 80.0, 5.0),
          child: SizedBox(
            height: 66.0,
            child: RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(33.0),
              ),
              color: Color(0xFFD97A00),
              child: Text('Create account',
                  style: new TextStyle(
                      fontSize: 23.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                FocusScope.of(context).unfocus();
                validateAndSubmit();
              },
            ),
          ));
    }

    Widget showSignInButton(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account? ',
            style: new TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: Color(0xAFD97A00),
            ),
          ),
          new FlatButton(
            child: Text(
              'Sign In',
              style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xAFD97A00),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    }

    Widget showErrorMessage() {
      if (_errorMessage.length > 0 && _errorMessage != null) {
        return new Text(
          _errorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16.0,
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

    Widget _showForm(BuildContext context) {
      return new Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                showLogo(),
                showExplanation(),
                showNameInput(),
                showEmailInput(),
                showPhoneInput(),
                showPasswordInput(),
                showConfirmationPasswordInput(),
                showCreateAccountButton(),
                showSignInButton(context),
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
        _showForm(context),
        _showCircularProgress(),
      ],
    ));
  }
}
