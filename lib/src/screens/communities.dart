import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../routes.dart';
import '../models/community_model.dart';
import '../repositories/community_repository.dart';
import '../utils/colors.dart';
import '../utils/localization.dart';
import '../widgets/app_bar.dart';
import '../widgets/community_list_item.dart';

class Communities extends HookWidget {
  const Communities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = localization(context);
    var loading = useState(false);
    var communities = useState<List<CommunityModel>>([]);
    var count = useState(0);
    var searchText = useState('');
    var lastListId = useState<dynamic>(null);

    Future<void> fetchCommunities(String text) async {
      loading.value = true;
      communities.value = [];

      var result = await CommunityRepository.instance.getMany(searchText: text);

      if (context.mounted) {
        communities.value = result;
        count.value = result.length;
      }
    }

    Future<void> fetchNext({
      startAfter,
      text,
    }) async {
      if (lastListId.value == startAfter) return;

      lastListId.value = startAfter;
      loading.value = true;

      var nextCommunities = await CommunityRepository.instance
          .getMany(startAfter: startAfter, searchText: text.value);

      if (context.mounted) {
        communities.value += nextCommunities;
        loading.value = false;
        count.value = communities.value.length;
      }
    }

    useEffect(() {
      fetchCommunities(searchText.value);

      return null;
    }, [searchText.value]);

    var filteredCommunities =
        communities.value.where((e) => e.isOwner || e.visibility).toList();

    return Scaffold(
      backgroundColor: AppColors.bg.paper,
      appBar: AppBarBack(
        title: Container(
          margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
          child: TextField(
            style: TextStyle(color: AppColors.text.basic),
            cursorColor: AppColors.text.basic,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 9),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.text.placeholder,
              ),
              hintText: t.searchCommunity,
              hintStyle: TextStyle(color: AppColors.text.placeholder),
              filled: true,
              fillColor: AppColors.bg.paper,
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                borderSide: BorderSide(
                  color: AppColors.role.primary,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                borderSide: BorderSide(
                  color: AppColors.text.placeholder,
                  width: 1,
                ),
              ),
            ),
            onChanged: (value) => searchText.value = value,
          ),
        ),
      ),
      body: SafeArea(
        child: FlatList(
          onRefresh: () => fetchCommunities(searchText.value),
          data: filteredCommunities,
          buildItem: (item, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CommunityListItem(
                community: item,
                onPress: () => context.pushNamed(
                  AppRoutes.community.name,
                  queryParams: {'id': item.id},
                ),
              ),
            );
          },
          onEndReached: () => fetchNext(
            startAfter: searchText.value.isEmpty
                ? communities.value.last.createdAt
                : communities.value.last.title,
            text: searchText,
          ),
          itemSeparatorWidget: const SizedBox(height: 12),
          listFooterWidget: const SizedBox(height: 28),
        ),
      ),
    );
  }
}
