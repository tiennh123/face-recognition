import 'dart:convert';
import 'dart:io';
import 'package:face_net_authentication/pages/models/authentication.model.dart';
import 'package:face_net_authentication/pages/models/sync_session.model.dart';
import 'package:face_net_authentication/utils/constant.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart' as log;

class CouchSessionService {
  authHeaders(String token) {
    return {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.acceptLanguageHeader: "vi-VN",
      "x-latitude": "10.7916142",
      "x-longitude": "106.6276637",
      "x-package-name": "7.0.0-dev (4563)",
      "x-device": "vsmart Joy 3 casuarina_open",
      "x-location": "eyJ1dWlkIjoiY2Y0MjAwYjMtZjI2NS00OGJkLTg3YjYtNmQ3ZGEyMTBhYTEzIiwidGltZSI6IjIwMjEtMDYtMTFUMDI6MzQ6MDEuMTc3WiIsImFjY3VyYWN5IjoxNC40LCJhbHRpdHVkZSI6My4wLCJzcGVlZCI6MC4yNCwiYWx0aXR1ZGVBY2N1cmFjeSI6My4wLCJoZWFkaW5nIjoxNTYuNzksImJhdHRlcnkiOjAuNTcsImlzQ2hhcmdpbmciOnRydWUsImFjdGl2aXR5VHlwZSI6InN0aWxsIiwiYWN0aXZpdHlDb25maWRlbmNlIjoxMDAsImlzTW92aW5nIjp0cnVlLCJvZG9tZXRlciI6MC4wLCJtb2NrIjpmYWxzZX0=",
      "x-device-id": "243d6ddf-13e6-4b1d-9867-9d49b11dd2bf",
    };
  }

  get preAuthHeaders {
    return {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptLanguageHeader: "vi-VN",
      "x-latitude": "10.7916142",
      "x-longitude": "106.6276637",
      "x-package-name": "7.0.0-dev (4563)",
      "x-device": "vsmart Joy 3 casuarina_open",
      "x-location": "eyJ1dWlkIjoiY2Y0MjAwYjMtZjI2NS00OGJkLTg3YjYtNmQ3ZGEyMTBhYTEzIiwidGltZSI6IjIwMjEtMDYtMTFUMDI6MzQ6MDEuMTc3WiIsImFjY3VyYWN5IjoxNC40LCJhbHRpdHVkZSI6My4wLCJzcGVlZCI6MC4yNCwiYWx0aXR1ZGVBY2N1cmFjeSI6My4wLCJoZWFkaW5nIjoxNTYuNzksImJhdHRlcnkiOjAuNTcsImlzQ2hhcmdpbmciOnRydWUsImFjdGl2aXR5VHlwZSI6InN0aWxsIiwiYWN0aXZpdHlDb25maWRlbmNlIjoxMDAsImlzTW92aW5nIjp0cnVlLCJvZG9tZXRlciI6MC4wLCJtb2NrIjpmYWxzZX0=",
      "x-device-id": "243d6ddf-13e6-4b1d-9867-9d49b11dd2bf",
    };
  }

  Future<JWTModel> login() async {
    var authenState = new JWTModel();
    var rawResponse = await postAuthen(
      userName: 'thang.td@katsuma.asia', 
      password: 'Thang123#', 
      deviceId: '',
    );
    if (rawResponse.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(rawResponse.bodyBytes));
      authenState = JWTModel.fromJson(responseJson);
      log.Logger().v('[KatHttp] [backgroundLogin] success: ${rawResponse.statusCode}');
    }
    return authenState;
  }

  Future<Response> postAuthen({userName: String, context, password: String, deviceId: String}) async {
    try {
      var data = {
        'UserName': userName,
        'Password': password,
        'DeviceId': deviceId
      };
      String postBody = json.encode(data);
      var rawResponse = await http.post(
        Uri.https(FlavorConfig.HOST_NAME, UrlContant.AUTH_LOGIN),
        headers: await preAuthHeaders, body: postBody,
      );
      return rawResponse;
    } catch (err) {
      throw (err);
    }
  }

  Future<SyncSessionModel> getSessionId(Map<String, String> authHeaders) async {
    try {
      http.Response rawResponse = await http.post(
        Uri.https(FlavorConfig.HOST_NAME, UrlContant.SYNC_GATEWAY_SESSION), 
        headers: authHeaders,
      );
      var responseJson = json.decode(utf8.decode(rawResponse.bodyBytes));
      return SyncSessionModel.fromJson(responseJson['Session']);
    } catch (err) {
      log.Logger().e('Error: $err', 'CouchSessionService: getSessionId');
      return null;
    }
  }

  Future<SyncSessionModel> refreshSessionId(String oldSessionId, Map<String, String> authHeaders) async {
    try {
      http.Response rawResponse = await http.post(
        Uri.https(FlavorConfig.HOST_NAME, UrlContant.REFRESH_SYNC_GATEWAY_SESSION),
        headers: authHeaders,
        body: {'OldSessionId': oldSessionId},
      );
      var responseJson = json.decode(utf8.decode(rawResponse.bodyBytes));
      return SyncSessionModel.fromJson(responseJson['Session']);
    } catch (err) {
      log.Logger().e('Error: $err', 'CouchSessionService: refreshSessionId');
      return null;
    }
  }
}