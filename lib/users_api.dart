import 'dart:convert';
import 'package:flutter/material.dart';
import 'user_model.dart';
import 'package:http/http.dart' as http;

class UsersAPI {
  //local json
  static Future<List<UserModel>> getUsersLocally(BuildContext context) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString('users.json');
    final body = json.decode(data);

    List<UserModel> users = body.map<UserModel>((json) => UserModel.fromJson(json)).toList();

    users.sort((a, b) => a.username!.toLowerCase().compareTo(b.username!.toLowerCase()));

    return users;
  }

  //remote json
  static Future<List<UserModel>> getUsersRemotely(BuildContext context) async {
    String url =
        'https://www.sideprojects.metrolifetech.com/v1/storage/buckets/62be2beb9cf3cf06c1ce/files/62be2c3f1c3aec9e8a42/view?project=football-vidz&mode=admin';
    final response = await http.get(Uri.parse(url));
    final body = json.decode(response.body);

    return body.map<UserModel>((json) => UserModel.fromJson(json)).toList();
  }
}
