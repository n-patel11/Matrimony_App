import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class ApiService {
  String baseURL = 'https://67c955340acf98d07089cc9a.mockapi.io/student';
  ProgressDialog? pd;

  void showProgressDialog(context) {
    if (pd == null) {
      pd = ProgressDialog(context);
      pd!.style(
        message: 'Please Wait',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: SpinKitFadingCircle(
          itemBuilder: (context, index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blue[100],
              ),
            );
          },
          size: 60,
        ),
        elevation: 10.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
      );
    }
    pd!.show();
  }

  void dismissProgress() {
    if (pd != null && pd!.isShowing()) {
      pd!.hide();
    }
  }

  Future<dynamic> getUsers(context) async {
    showProgressDialog(context);
    http.Response res = await http.get(Uri.parse(baseURL));
    dismissProgress();
    return convertJSONToData(res);
  }

  Future<void> addUser({context, map}) async {
    showProgressDialog(context);
    http.Response res = await http.post(Uri.parse(baseURL), body: map);
    dismissProgress();
  }

  Future<dynamic> updateUser({Column_userid, map, context}) async {
    showProgressDialog(context);
    http.Response res =
    await http.put(Uri.parse(baseURL + '/$Column_userid'), body: map);
    dismissProgress();
    return convertJSONToData(res);
  }

  Future<dynamic> deleteUser({Column_userid, context}) async {
    showProgressDialog(context);
    http.Response res = await http.delete(Uri.parse(baseURL + '/$Column_userid'));
    dismissProgress();
    return convertJSONToData(res);
  }

  Future<bool> favoriteUser({
    required String Column_userid,
    required bool isFavorite,
    required BuildContext context,
  }) async {
    print("Favorite Toggle: $isFavorite");

    final res = await http.put(
      Uri.parse('$baseURL/$Column_userid'),
      body: jsonEncode({'Column_favorite': isFavorite ? 1 : 0}), // Send integer
      headers: {'Content-Type': 'application/json'},
    );

    print("Response: ${res.body}");
    return res.statusCode == 200;
  }



  dynamic convertJSONToData(http.Response res) {
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else if (res.statusCode == 404) {
      return 'PAGE NOT FOUND PLEAE CHECK YOUR URL';
    } else if (res.statusCode == 500) {
      return 'SERVER ERROR';
    } else {
      return 'NO DATA FOUND';
    }
  }
}