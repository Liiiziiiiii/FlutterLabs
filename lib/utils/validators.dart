bool isValidEmail(String s) => RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(s);
bool isValidUsername(String s) => RegExp(r'^[a-zA-Z]+$').hasMatch(s);
bool isValidPassword(String s) => s.length >= 6;
