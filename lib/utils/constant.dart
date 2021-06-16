class StepLiveness {
  static int stepHeadLeft = 1;
  static int stepHeadRight = 2;
  static int stepBlink = 3;
  static int stepSmile = 4;
  static int stepTakePicture = 5;
}

class UrlContant {
  static const String COUCHBASE_SYNC = 'wss://sync.letron.io/katsuma_go';
  static const String AUTH_LOGIN = '/v1/auth/login';
  static const String SYNC_GATEWAY_SESSION = '/v1/users/me/sync-gateway-session';
  static const String REFRESH_SYNC_GATEWAY_SESSION = '/v1/users/me/refresh-sync-gateway-session';
}

class StorageDB {
  static const String SYNC = 'syncDbCouch';
}

class FlavorConfig {
  static const String HOST_NAME = 'api.letron.io';
}

class Couchbase {
  static const String MOBILE_INFO = 'MOBILE_INFO'; // couchbase current only allow type mobile_info
}

class UserTest {
  static const String UserName = "son.vh@katsuma.asia";
  static const String Password = "Son123#";
}