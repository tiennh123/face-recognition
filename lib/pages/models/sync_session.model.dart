class SyncSessionModel {
  final String cookieName;
  final String expires;
  final String sessionId;

  SyncSessionModel({this.cookieName, this.expires, this.sessionId});
  
  factory SyncSessionModel.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson == null) return null;
    return SyncSessionModel(
      cookieName: parsedJson['CookieName'],
      expires: parsedJson['Expires'],
      sessionId: parsedJson['SessionId'],
    );
  }
}