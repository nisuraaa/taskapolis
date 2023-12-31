import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 200,
    height: 200,
  );
}

TextField reuseableTextField(
    String text,
    IconData icon,
    bool isPasswordType,
    TextEditingController controller,
    // context
    BuildContext context) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: isPasswordType,
    autocorrect: isPasswordType,
    cursorColor: Theme.of(context).colorScheme.onBackground,
    style: TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
    ),
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: text,
      // prefixIcon: Icon(icon),
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      // filled: true,
      fillColor: Colors.white,
    ),
    keyboardType:
        isPasswordType ? TextInputType.text : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Theme.of(context).colorScheme.secondary;
                  } else {
                    return Theme.of(context).colorScheme.primary;
                  }
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          child: Text(
            isLogin ? "Sign In" : "Sign Up",
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          )));
}
