
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:face_net_authentication/pages/models/sync_session.model.dart';
import 'package:face_net_authentication/services/couch_session_service.dart';
import 'package:face_net_authentication/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as log;

class CouchbaseService {
  CouchSessionService _sessionService = new CouchSessionService();
  Database _couchDatabase;
  Replicator _replicator;
  MutableDocument _document;

  CouchbaseService() {
    setupSyncCouch();
  }

  Future<Database> setupSyncCouch() async {
    try {
      var token = await _sessionService.login();
      var authHeaders = _sessionService.authHeaders(token.accessToken);
      _couchDatabase = await Database.initWithName(StorageDB.SYNC);
      SyncSessionModel session = await _sessionService.getSessionId(authHeaders);
      ReplicatorConfiguration config = ReplicatorConfiguration(_couchDatabase, UrlContant.COUCHBASE_SYNC);
      config.replicatorType = ReplicatorType.pushAndPull;
      config.continuous = true;
      config.authenticator = SessionAuthenticator(
        session.sessionId,
        cookieName: session.cookieName,
      );

      _replicator = Replicator(config);
      _replicator.addChangeListener((ReplicatorChange event) {
        if (event.status.error != null) {
          log.Logger().e('${event.status.error}', 'SyncStorageService: setupSyncCouch');
        }
        log.Logger().i('Couch status: ${event.status.activity.toString()}', 'SyncStorageService: setupSyncCouch');
      });

      _replicator.start();
      log.Logger().i('Done couch', 'SyncStorageService: setupSyncCouch');
      return _couchDatabase;
    } catch (e) {
      log.Logger()
          .e('Fail init couch $e', 'SyncStorageService: setupSyncCouch');
      return null;
    }
  }

  Future persistData(String type, String userName, dynamic data) async {
    try {
      final String documentId = type + "_" + userName.toLowerCase();
      // String documentId = type + "_1e2a3b8a-cb5c-11eb-b8bc-0242ac130003";
      Document tempDoc = await _couchDatabase.document(documentId);
      if (tempDoc == null) {
        _document = MutableDocument(id: documentId)
            .setString("type", type.toLowerCase())
            .setString("key", documentId);
      } else {
        _document = tempDoc.toMutable();
      }
      Map<String, dynamic> decodeData = data;
      for (final item in decodeData.keys) {
        _document.setString(item, decodeData[item]);
      }
      _couchDatabase.saveDocument(_document);
    } catch (err) {
      log.Logger().e('Fail init couch $err', 'SyncStorageService: persistData');
    }
  }

  Future<bool> clearPersistData(String key, String userName) async {
    try {
      var documentId = key + "_" + userName.toLowerCase();
      _document.remove(documentId);
      await _couchDatabase.saveDocument(_document);
      return true;
    } catch (e) {
      log.Logger().e('Fail init couch $e', 'SyncStorageService: clearPersistData');
      return false;
    }
  }

  Future getPersistData(
    String type, 
    String userName,
    ValueChanged onDataChange,
    {List<SelectResultProtocol> listQuery}
  ) async {
    var documentId = type + "_" + userName.toLowerCase();
    _getPersist(documentId, (Result db) {
      if (db == null) onDataChange({});
      var stringDoc = db.getValue(key: "docs");
      onDataChange(stringDoc);
    });
  }

  _getPersist(String key, ValueChanged<Result> onDataChange) {
    var query = QueryBuilder.select([SelectResult.all().from("docs")])
        .from(StorageDB.SYNC, as: "docs")
        .where(Expression.property("key")
            .from("docs")
            .equalTo(Expression.string(key)));

    final queryToken = query.addChangeListener((QueryChange qChange) {
      log.Logger().i('Query change type $key', 'SyncStorageService: getPersist');
      var a = qChange.results;
      if (a.isNotEmpty) {
        onDataChange(qChange.results.single);
      }
    });
    try {
      query.execute().then((ResultSet result) {
        if (result.isEmpty)
          onDataChange(null);
        else {
          onDataChange(result.single);
        }
      });
      return queryToken;
    } catch (e) {
      log.Logger().i('Error on callback couchbase: $e', 'SyncStorageService: getPersist');
    }
  }
}

