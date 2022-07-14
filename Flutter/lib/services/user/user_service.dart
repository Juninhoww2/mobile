import 'dart:convert';
import 'package:asuka/asuka.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:learnplay/config.dart';
import 'package:learnplay/controller/image_controller.dart';
import 'package:learnplay/modules/dashboard/core/auth_controller.dart';
import 'package:learnplay/services/api_config.dart';
import 'package:learnplay/services/storage/storage.dart';
import 'package:learnplay/types/user.dart';

import '../../routes.dart';

class UserService {
  static const String _webservice = "$apiUrl/user";

  static Future<String?> login(User user) async {
    try {
      final request =
          await Dio().post("$_webservice/login", data: user.toJson());
      final response = Token.fromJson(request.data);

      Storage.save(Storages.Token, value: response.token!);

      print(await Storage.get(Storages.Token));
    } on DioError catch (err) {
      throw Exception(err.response);
    }
  }

  static Future refresh() async {
    try {
      var token = await Storage.get(Storages.Token);

      print("CHECKING USER DATA.............");

      final response = await Dio().get("$_webservice/refresh",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      return response;
    } on DioError catch (err) {
      throw Exception(err.response);
    }
  }

  static getProfilePicture({required String uuid}) {
    return "$_webservice/get-profile-picture/$uuid";
  }

  static logout(BuildContext context) {
    AuthController.setUserLoggedIn(context, user: null);
    Storage.remove(Storages.Token);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RouteEnum.main.name, (route) => false);
  }

  static Future<User?> checkUserLoggedIn(BuildContext context) async {
    try {
      var request = await UserService.refresh();
      var response = User.fromJson(request.data);

      return response;
    } catch (err) {
      Storage.remove(Storages.Token);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RouteEnum.main.name, (route) => false);
    }
  }

  Future changeProfilePicture(BuildContext context) async {
    try {
      var token = await Storage.get(Storages.Token);

      //! upload image from desktop
      if (Display.isDesktop()) {
        final file = await ImageController.uploadByDesktop();
        if(file == null) return; 
        final response = await Dio().post("$_webservice/set-profile-picture",
            options: Options(headers: {"Authorization": "Bearer $token"}),
            data: file);
      }

      //! upload image from mobile device
      if (Display.isCellphone()) {
        final file = await ImageController.uploadByCellphone();
        if (file == null) return;
          final response = await Dio().post("$_webservice/set-profile-picture",
            options: Options(headers: {"Authorization": "Bearer $token"}),
            data: file);

          print(response.data);
      }

      AsukaSnackbar.success("Foto de perfil alterada!").show();
      AuthController.reloadProfilePhoto(context);
    } on DioError catch (err) {
      print(err);
    }
  }

  static Future<List<User>?> getAllMembers() async {
    try {
      var token = await Storage.get(Storages.Token);

      final request = await Dio().get("$_webservice/members",  options: Options(headers: {"Authorization": "Bearer $token"}));

      final res = request.data as List;
      final response = res.map((user) => User.fromJson(user)).toList();

      return response;

    } on DioError catch(err) {
      print(err);
    }
  }

  static Future<User?> getMember({required String uuid}) async {
    try {

      var token = await Storage.get(Storages.Token);
      
      final request = await Dio().get("$_webservice/profile/${uuid}",  options: Options(headers: {"Authorization": "Bearer $token"}));
      final response = User.fromJson(request.data);

      return response;
      
    } on DioError catch(err) {
      print(err);
    }
  }
  
}
