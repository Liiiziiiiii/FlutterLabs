import 'package:flutter/material.dart';

AppBar buildAppBar({
  required BuildContext context,
  required VoidCallback onLogoutPressed,
  required VoidCallback onSensorPressed,
  required VoidCallback onProfilePressed,
  required VoidCallback onButtonPressed,
  required VoidCallback onQrPressed,
}) {
  return AppBar(
    // title: const Text('Головна'),
    // backgroundColor: const Color(0xFFDFB6B2),
    // elevation: 0,
    actions: [
      IconButton(
        icon: const Icon(Icons.sensors),
        tooltip: 'Сенсори',
        onPressed: onSensorPressed,
      ),
      IconButton(
        icon: const Icon(Icons.logout),
        tooltip: 'Вийти',
        onPressed: onLogoutPressed,
      ),
      IconButton(
        icon: const Icon(Icons.person),
        tooltip: 'Профіль',
        onPressed: onProfilePressed,
      ),
      IconButton(
        icon: const Icon(Icons.account_box),
        tooltip: 'Кнопки',
        onPressed: onButtonPressed,
      ),
      IconButton(
        icon: const Icon(Icons.qr_code),
        tooltip: 'QR',
        onPressed: onQrPressed,
      ),
    ],
  );
}
