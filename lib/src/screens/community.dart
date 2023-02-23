import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/community_model.dart';
import '../repositories/community_repository.dart';
import '../widgets/loading_indicator.dart';
import 'feeds.dart';

class Community extends HookWidget {
  const Community({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive(wantKeepAlive: true);
    var community = useState<CommunityModel?>(null);

    useEffect(() {
      Future<void> fetchCommunity() async {
        var result = await CommunityRepository.instance.getWithId(id);

        if (context.mounted) {
          community.value = result;
        }
      }

      fetchCommunity();
      return null;
    }, []);

    if (community.value == null) {
      return const LoadingIndicator();
    }

    return Feeds(initialCommunity: community.value);
  }
}
