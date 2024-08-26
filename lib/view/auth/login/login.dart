import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/app_string_service.dart';
import 'package:qixer_seller/services/language_dropdown_helper.dart';
import 'package:qixer_seller/utils/common_helper.dart';
import 'package:qixer_seller/utils/constant_colors.dart';
import 'package:qixer_seller/utils/constant_styles.dart';
import 'package:qixer_seller/utils/custom_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/auth_services/login_service.dart';
import '../reset_password/reset_pass_email_page.dart';
import '../signup/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    initPassword();
  }

  initPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    keepLoggedIn = prefs.getBool('keepLoggedIn') ?? true;
    String? email;
    String? pass;
    if (keepLoggedIn) {
      email = prefs.getString('email');
      pass = prefs.getString("pass");
    }
    emailController.text = email ?? "";
    passwordController.text = pass ?? "";
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool keepLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: SingleChildScrollView(
          physics: physicsCommon,
          child: Consumer<AppStringService>(
            builder: (context, ln, child) => Column(
              children: [
                ClipRRect(
                  child: Container(
                    height: 230.0,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/login-slider.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: AutofillGroup(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 33,
                          ),
                          CommonHelper()
                              .titleCommon(ln.getString("Welcome back! Login")),

                          const SizedBox(
                            height: 33,
                          ),

                          //Name ============>
                          CommonHelper()
                              .labelCommon(ln.getString("Email or username")),

                          CustomInput(
                            controller: emailController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln.getString(
                                    'Please enter your email or username');
                              }
                              return null;
                            },
                            autofillHints: const [
                              AutofillHints.username,
                              AutofillHints.email
                            ],
                            hintText: ln.getString("Email"),
                            icon: 'assets/icons/user.png',
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          //password ===========>
                          CommonHelper().labelCommon(ln.getString("Password")),

                          Container(
                              margin: const EdgeInsets.only(bottom: 19),
                              decoration: BoxDecoration(
                                  // color: const Color(0xfff2f2f2),
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: passwordController,
                                autofillHints: const [AutofillHints.password],
                                textInputAction: TextInputAction.next,
                                obscureText: !_passwordVisible,
                                style: const TextStyle(fontSize: 14),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return ln.getString(
                                        'Please enter your password');
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 22.0,
                                          width: 40.0,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/icons/lock.png'),
                                                fit: BoxFit.fitHeight),
                                          ),
                                        ),
                                      ],
                                    ),
                                    suffixIcon: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      icon: Icon(
                                        // Based on passwordVisible state choose the icon
                                        _passwordVisible
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.grey,
                                        size: 22,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toogle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ConstantColors().greyFive),
                                        borderRadius: BorderRadius.circular(9)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                ConstantColors().primaryColor)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                ConstantColors().warningColor)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                ConstantColors().primaryColor)),
                                    hintText: ln.getString('Enter password'),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 18)),
                              )),

                          // =================>
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //keep logged in checkbox
                              Expanded(
                                child: CheckboxListTile(
                                  checkColor: Colors.white,
                                  activeColor: ConstantColors().primaryColor,
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      ln.getString("Remember me"),
                                      style: TextStyle(
                                          color: ConstantColors().greyFour,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                  ),
                                  value: keepLoggedIn,
                                  onChanged: (newValue) {
                                    setState(() {
                                      keepLoggedIn = !keepLoggedIn;
                                    });
                                  },
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const ResetPassEmailPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 122,
                                  height: 40,
                                  child: Text(
                                    ln.getString("Forgot Password?"),
                                    style: TextStyle(
                                        color: cc.primaryColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ],
                          ),

                          
                        const SizedBox(
                          height: 15,
                        ),
                        //dropdown for language
                        LanguageDropdownHelper().languageDropdown(cc, context),

                          //Login button ==================>
                          const SizedBox(
                            height: 18,
                          ),

                          Consumer<LoginService>(
                            builder: (context, provider, child) =>
                                CommonHelper()
                                    .buttonPrimary(ln.getString("Login"), () {
                              if (provider.isloading == false) {
                                if (_formKey.currentState!.validate()) {
                                  provider.login(
                                      emailController.text.trim(),
                                      passwordController.text,
                                      context,
                                      keepLoggedIn);
                                  // Navigator.pushReplacement<void, void>(
                                  //   context,
                                  //   MaterialPageRoute<void>(
                                  //     builder: (BuildContext context) =>
                                  //         const Homepage(),
                                  //   ),
                                  // );
                                }
                              }
                            },
                                        isloading: provider.isloading == false
                                            ? false
                                            : true),
                          ),

                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: ln.getString('Do not have an account') +
                                      ' ',
                                  style: const TextStyle(
                                      color: Color(0xff646464), fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SignupPage()));
                                          },
                                        text: ln.getString('Register'),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: cc.primaryColor,
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                // }
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
