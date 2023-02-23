import '../models/feed_model.dart';
import '../utils/firestore_config.dart';
import '../utils/general.dart';
import '../utils/tools.dart';

abstract class IReportRepository {
  Future<bool> report({
    FeedModel? feed,
  });
}

class ReportRepository implements IReportRepository {
  const ReportRepository._();
  static ReportRepository instance = const ReportRepository._();

  @override
  Future<bool> report({FeedModel? feed}) async {
    var hasContent = feed != null;

    assert(hasContent, 'No content to report');

    if (!hasContent) return false;

    var user = General.instance.checkAuth();

    try {
      await FirestoreConfig.rootDoc.collection('reports').doc(feed.id).set({
        'userRef': FirestoreConfig.userColRef.doc(user.uid),
        'feedRef': FirestoreConfig.feedColRef.doc(feed.id),
        'createdAt': DateTime.now(),
      });

      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }
}
