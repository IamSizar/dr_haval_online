import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../crud/crud.dart';
import '../../../crud/linkapi.dart';
import '../../../main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  Crud _crud = new Crud();
  login() async {
    var response = await _crud.getRequest(
        '$Apilogin?username=${username.text}&password=${password.text}');
    if (response['status'] == 'success') {
      sharedPref.setString("username", response['data']['username']);
      sharedPref.setString("admin", response['data']['admin']);
      if (response['data']['admin'] == '1') {
        getscreen(true);
      } else {
        getscreen(false);
      }
    } else if (response['status'] == 'fpassword') {
      FlutterPlatformAlert.showAlert(
        windowTitle: 'Password Wrong',
        text: 'Please write real password...',
        alertStyle: AlertButtonStyle.ok,
        iconStyle: IconStyle.warning,
      );
    } else if (response['status'] == 'fuser') {
      FlutterPlatformAlert.showAlert(
        windowTitle: 'This user doesnt have',
        text: 'Please write real username...',
        alertStyle: AlertButtonStyle.ok,
        iconStyle: IconStyle.warning,
      );
    }
  }

  void getscreen(bool admin) {
    if (admin) {
      Navigator.of(context).pushNamed('/admin');
    } else {
      Navigator.of(context).pushNamed('/user');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double heights = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                  height: 435,
                  width: width,
                  child: SvgPicture.asset(
                    'assets/images/background.svg',
                    fit: BoxFit.fill,
                  )),
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 130,
                    width: 150,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SvgPicture.asset(
                          'assets/images/logo1.svg',
                          fit: BoxFit.contain,
                        ),
                        const Text(
                          'Dr. Haval’s',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontFamily: 'English3'),
                        ),
                      ],
                    )), //
                const Text(
                  'Pediatric clinic',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'English1'),
                ),
                textfild('Username...', username, width),
                textfild('Password...', password, width),

                bt(heights, width)
              ],
            ),
            SizedBox(
                height: heights,
                width: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        height: heights / 1.05,
                        width: 500,
                        child: Image.asset(
                          'assets/images/1.png',
                          fit: BoxFit.cover,
                        )),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '# K | S',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'English1'),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    ));
  }

  Padding textfild(String pl, TextEditingController text, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: SizedBox(
        height: 45,
        width: width / 4,
        child: CupertinoTextField(
            placeholderStyle: const TextStyle(color: Color(0xffbac8ACFD6)),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              login();
            },
            obscuringCharacter: '•',
            obscureText: pl == 'Password...' ? true : false,
            cursorColor: const Color(0xff0E9CAB),
            cursorWidth: 2,
            placeholder: pl,
            controller: text,
            style: const TextStyle(
              color: Color(0xff666666),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xff0E9CAB), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFE4E4E4),
                    blurRadius: 3,
                  )
                ],
                borderRadius: BorderRadius.circular(30))),
      ),
    );
  }

  InkWell bt(double heights, double widge) => InkWell(
        onTap: () => login(),
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
            height: 45,
            width: widge / 6,
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff0E9CAB),
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: const Color(0xffCEEBEE), width: 1.5)),
                child: const Center(
                    child: Text('Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'English2',
                        ))))),
      );
}
