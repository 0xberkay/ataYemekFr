//     final menu = menuFromJson(jsonString);

import 'dart:convert';

Menu menuFromJson(String str) => Menu.fromJson(json.decode(str));

String menuToJson(Menu data) => json.encode(data.toJson());

class Menu {
  Menu({
    required this.menu,
    required this.message,
  });

  MenuClass menu;
  String message;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menu: MenuClass.fromJson(json["menu"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "menu": menu.toJson(),
        "message": message,
      };
}

class MenuClass {
  MenuClass({
    required this.tarih,
    required this.menuler,
  });

  String tarih;
  List<Menuler> menuler;

  factory MenuClass.fromJson(Map<String, dynamic> json) => MenuClass(
        tarih: json["Tarih"],
        menuler:
            List<Menuler>.from(json["Menuler"].map((x) => Menuler.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Tarih": tarih,
        "Menuler": List<dynamic>.from(menuler.map((x) => x.toJson())),
      };
}

class Menuler {
  Menuler({
    required this.name,
    required this.gram,
  });

  String name;
  String gram;

  factory Menuler.fromJson(Map<String, dynamic> json) => Menuler(
        name: json["Name"],
        gram: json["Gram"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Gram": gram,
      };
}
