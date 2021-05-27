import 'package:flutter/material.dart';

Widget buildSetupPage(
    {required int themeMode,
    required Function(int mode) changeThemeMode,
    required Function(int mode) changeNotificationMode,
    required int notificatioMode}) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SwitchListTile(
            title: Text("Tema escuro"),
            subtitle: Text("Utilize o tema escuro no aplicativo"),
            value: themeMode == 0,
            onChanged: (_) => changeThemeMode(0),
          ),
          SwitchListTile(
            title: Text("Tema claro"),
            subtitle: Text("Utilize o tema escuro no aplicativo"),
            value: themeMode == 1,
            onChanged: (_) => changeThemeMode(1),
          ),
          SwitchListTile(
            title: Text("Tema do sistema"),
            subtitle: Text("Utilize o mesmo tema que o sistema"),
            value: themeMode == 2,
            onChanged: (_) => changeThemeMode(2),
          ),
          SwitchListTile(
            title: Text("Ativar todas as notificatificações"),
            subtitle: Text("Receba notificações em todos os eventos"),
            value: notificatioMode == 0,
            onChanged: (_) => changeNotificationMode(0),
          ),
          SwitchListTile(
            title: Text("Ativar notificações parcialmente"),
            subtitle: Text("Receber notificações apenas nos ultimos eventos"),
            value: notificatioMode == 1,
            onChanged: (_) => changeNotificationMode(1),
          ),
          SwitchListTile(
            title: Text("Desativar notificações"),
            subtitle: Text("Não receber notificações"),
            value: notificatioMode == 2,
            onChanged: (_) => changeNotificationMode(2),
          ),
        ],
      ),
    ),
  );
}
