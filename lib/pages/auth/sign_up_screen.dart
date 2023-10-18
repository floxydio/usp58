import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import 'package:nyoba/provider/app_provider.dart';
import 'package:nyoba/provider/home_provider.dart';
import 'package:nyoba/provider/register_provider.dart';
import 'package:nyoba/widgets/webview/webview.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import '../../app_localizations.dart';
import '../../utils/utility.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isVisible = false;
  bool isVisibleRepeat = false;
  bool? checkedValue = false;

  bool isEmailValid = false;

  TextEditingController controllerFirstname = new TextEditingController();
  TextEditingController controllerLastname = new TextEditingController();
  TextEditingController controllerUsername = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  TextEditingController controllerPasswordConfirm = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final register = Provider.of<RegisterProvider>(context, listen: false);
    final generalSettings = Provider.of<HomeProvider>(context, listen: false);
    final isDarkMode = Provider.of<AppNotifier>(context).isDarkMode;

    var signUp = () async {
      if (controllerFirstname.text.isNotEmpty &&
          controllerLastname.text.isNotEmpty &&
          controllerEmail.text.isNotEmpty &&
          controllerUsername.text.isNotEmpty &&
          controllerPassword.text.isNotEmpty &&
          controllerPasswordConfirm.text.isNotEmpty) {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }

        isEmailValid = EmailValidator.validate(controllerEmail.text);

        if (!isEmailValid) {
          return snackBar(context,
              message: AppLocalizations.of(context)!
                  .translate('snackbar_email_valid')!);
        }

        if (controllerPassword.text != controllerPasswordConfirm.text) {
          snackBar(context,
              message: AppLocalizations.of(context)!
                  .translate('snackbar_password_match')!);
        } else {
          if (controllerPassword.text.length < 8) {
            return snackBar(context,
                message: AppLocalizations.of(context)!
                    .translate('snackbar_password_min')!);
          }
          if (checkedValue!) {
            setState(() {
              register.loading = true;
            });
            final Future<Map<String, dynamic>?> authResponse = register.signUp(
                username: controllerUsername.text,
                password: controllerPassword.text,
                email: controllerEmail.text,
                firstname: controllerFirstname.text,
                lastname: controllerLastname.text);

            authResponse.then((value) {
              if (value!['cookie'] != null) {
                Navigator.pop(context);
                snackBar(context,
                    message: AppLocalizations.of(context)!
                        .translate('snackbar_user_register_success')!,
                    color: Colors.green);
              } else {
                snackBar(context, message: value['message'], color: Colors.red);
              }
              setState(() {
                register.loading = false;
              });
            });
          } else {
            snackBar(context,
                message:
                    AppLocalizations.of(context)!.translate('snackbar_term')!);
          }
        }
      } else {
        snackBar(context,
            message: AppLocalizations.of(context)!.translate('required_form')!);
      }
    };

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              // color: Colors.black,
            ),
          ),
          // backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.translate('sign_up')!,
            style:
                TextStyle(fontSize: responsiveFont(16), color: secondaryColor),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate('create_account')!,
                  style: TextStyle(
                    fontSize: responsiveFont(14),
                    // color: Colors.black
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!
                      .translate('subtitle_create_account')!,
                  // style: TextStyle(color: Colors.black),
                ),
                Container(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: form(
                            AppLocalizations.of(context)!
                                .translate('enter_firstname'),
                            AppLocalizations.of(context)!
                                .translate('first_name'),
                            false,
                            controllerFirstname)),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: form(
                            AppLocalizations.of(context)!
                                .translate('enter_lastname'),
                            AppLocalizations.of(context)!
                                .translate('last_name'),
                            false,
                            controllerLastname))
                  ],
                ),
                Container(
                  height: 15,
                ),
                form(AppLocalizations.of(context)!.translate('enter_email'),
                    "Email", true, controllerEmail,
                    icon: "email"),
                Container(
                  height: 15,
                ),
                form(
                    AppLocalizations.of(context)!.translate('enter_username'),
                    AppLocalizations.of(context)!.translate('username'),
                    true,
                    controllerUsername,
                    icon: "akun"),
                Container(
                  height: 15,
                ),
                passwordForm(
                    AppLocalizations.of(context)!.translate('enter_password'),
                    AppLocalizations.of(context)!.translate('password'),
                    controllerPassword,
                    isVisible,
                    1),
                Container(
                  height: 15,
                ),
                passwordForm(
                    AppLocalizations.of(context)!.translate('enter_password'),
                    AppLocalizations.of(context)!.translate('repeat_password'),
                    controllerPasswordConfirm,
                    isVisibleRepeat,
                    2),
                Container(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 17.w,
                          height: 17.h,
                          child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: HexColor("ED625E"),
                              splashRadius: 0,
                              value: checkedValue,
                              onChanged: (value) {
                                setState(() {
                                  checkedValue = value;
                                });
                              }),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: 250.w,
                          child: Text(
                            AppLocalizations.of(context)!
                                .translate('term_condition_sign_up')!,
                            style: TextStyle(fontSize: responsiveFont(10)),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebViewScreen(
                                      url: generalSettings.privacy.description,
                                      title: generalSettings.privacy.slug!
                                          .toUpperCase(),
                                    )));
                      },
                      child: Icon(Icons.open_in_new),
                    )
                  ],
                ),
                Container(
                  height: 10,
                ),
                /*Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 6,
                  child: RecaptchaV2(
                    apiKey: '6Lei7XsaAAAAAMv_EkpWMtGbuDXrdWp0N1x9vtCZ',
                    apiSecret: '6Lei7XsaAAAAAMGbqOvMQb8Y4kS-eqTS8xFPTV2P',
                    controller: recaptchaV2Controller,
                    onVerifiedError: (err) {
                      print(err);
                    },
                    onVerifiedSuccessfully: (success) {
                      setState(() {
                        if (success) {
                          // You've been verified successfully.
                        } else {
                          // "Failed to verify.
                        }
                      });
                    },
                  ),
                ),*/
                Container(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        backgroundColor:
                            register.loading ? Colors.grey : secondaryColor),
                    onPressed: register.loading ? null : signUp,
                    child: register.loading
                        ? customLoading()
                        : Text(
                            AppLocalizations.of(context)!.translate('sign_up')!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsiveFont(10),
                            ),
                          ),
                  ),
                ),
                Container(
                  height: 15,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: isDarkMode ? null : Colors.black,
                        fontSize: responsiveFont(10),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "${AppLocalizations.of(context)!.translate('have_account')} ",
                        ),
                        TextSpan(
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () => Navigator.pop(context),
                            text: AppLocalizations.of(context)!
                                .translate('login'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget passwordForm(String? hints, String? label,
      TextEditingController controller, bool visible, int idx) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: TextField(
        controller: controller,
        obscureText: visible ? false : true,
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  if (idx == 1)
                    isVisible = !isVisible;
                  else if (idx == 2) isVisibleRepeat = !isVisibleRepeat;
                });
              },
              child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Image.asset(visible
                      ? "images/account/melek.png"
                      : "images/account/merem.png")),
            ),
            prefixIcon: Container(
                alignment: Alignment.topCenter,
                width: 24.w,
                height: 24.h,
                padding: EdgeInsets.only(right: 5),
                child: Image.asset("images/account/lock.png")),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: responsiveFont(10),
            ),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: responsiveFont(12),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: hints,
            hintText: label),
      ),
    );
  }

  Widget form(String? hints, String? label, bool prefix,
      TextEditingController controller,
      {String icon = "email"}) {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: TextField(
        controller: controller,
        keyboardType:
            icon == "email" ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
            prefixIcon: prefix
                ? Container(
                    padding: EdgeInsets.only(right: 5),
                    width: 24.w,
                    height: 24.h,
                    child: Image.asset("images/account/$icon.png"))
                : null,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: responsiveFont(10),
            ),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: responsiveFont(12),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label,
            hintText: hints),
      ),
    );
  }
}
