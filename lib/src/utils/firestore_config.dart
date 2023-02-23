import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../firebase_options.dart';

import 'config.dart';

class FirebaseConfig {
  static Future<void> initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: 'WeCount',
    );

    if (useEmulator()) {
      var internalIP = getInternalIP();

      FirebaseFirestore.instance.settings = Settings(
        host: '$internalIP:8080',
        sslEnabled: false,
        persistenceEnabled: false,
      );
      await FirebaseAuth.instance.useAuthEmulator(internalIP, 9099);
      await FirebaseStorage.instance.useStorageEmulator(
        internalIP,
        9199,
      );
    }
  }

  static String getInternalIP() {
    var internalIP = Config().emulatorIpAddress;

    if (internalIP == '') {
      return '10.0.2.2';
    }

    return internalIP;
  }
}

class FirestoreConfig {
  const FirestoreConfig._();
  static FirestoreConfig instance = const FirestoreConfig._();

  static final rootDoc =
      FirebaseFirestore.instance.collection('wecount').doc('app');

  static final communityColRef = rootDoc.collection('communities');
  static final feedColRef = rootDoc.collection('feeds');
  static final userColRef = rootDoc.collection('users');
  static final replyColRef = rootDoc.collection('replies');
}

Future<List<T>> getPaginatingQuery<T>({
  required CollectionReference<T> collectionRef,
  required String orderBy,
  String searchText = '',
  String? startAfter,
  int size = 20,
}) async {
  var query = collectionRef
      .limit(size)
      .where('deletedAt', isNull: true)
      .orderBy(orderBy);

  query = searchText.isEmpty
      ? query
      : query
          .where(searchText, isGreaterThanOrEqualTo: searchText.toUpperCase())
          .where(searchText,
              isLessThanOrEqualTo: '${searchText.toUpperCase()}\uf8ff');

  query = startAfter != null ? query.startAfter([startAfter]) : query;

  var snap = startAfter != null
      ? await query.startAfter([startAfter]).get()
      : await query.get();

  if (snap.docs.isEmpty) {
    return [];
  }

  return snap.docs.map((e) => e.data()).toList();
}
