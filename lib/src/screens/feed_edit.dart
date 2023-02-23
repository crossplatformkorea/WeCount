import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../models/community_model.dart';
import '../models/feed_model.dart';
import '../repositories/community_repository.dart';
import '../repositories/feed_repository.dart';
import '../utils/alert_dialog/alert_dialog.dart';
import '../utils/colors.dart';
import '../utils/firestore_config.dart';
import '../utils/localization.dart';
import '../utils/snackbar.dart';
import '../utils/storage.dart';
import '../utils/styles.dart';
import '../utils/tools.dart';
import '../utils/utils.dart';
import '../utils/validator.dart';
import '../widgets/app_bar.dart';
import '../widgets/button.dart';
import '../widgets/edit_text.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/photo_card_item.dart';
import '../widgets/radio_group.dart';

var _dropdownInputDecoration = InputDecoration(
  contentPadding:
      const EdgeInsets.only(top: 20, bottom: 18, right: 10, left: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: BorderSide(
      color: AppColors.bg.border,
      width: 1,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(4),
    borderSide: BorderSide(
      color: AppColors.text.placeholder,
      width: 1,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.role.primary,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(4),
  ),
);

enum FeedActions {
  add,
  edit,
  delete,
}

/// Specify result of the router
class FeedEditResult {
  const FeedEditResult({
    this.action,
    this.feed,
  });

  final FeedActions? action;
  final FeedModel? feed;
}

/// Used for extra params in go router
class FeedEditArguments {
  FeedEditArguments({
    this.onUpdate,
  });

  final Function(FeedEditResult)? onUpdate;
}

class FeedEdit extends HookWidget {
  const FeedEdit({
    super.key,
    this.extra,

    /// For creating feed
    this.communityId,

    /// For editing feed
    this.feedId,
  }) : assert(
          feedId != null || communityId != null,
          'One of [feedId] or [communityId] should be provided.',
        );

  final FeedEditArguments? extra;
  final String? communityId;
  final String? feedId;

  @override
  Widget build(BuildContext context) {
    var community = useState<CommunityModel?>(null);
    var feed = useState<FeedModel?>(null);

    useEffect(() {
      Future<void> getCommunity() async {
        var result = await CommunityRepository.instance.getWithId(communityId!);

        if (context.mounted && result != null) {
          community.value = result;
        }
      }

      Future<void> getFeed() async {
        var feedResult = await FeedRepository.instance.getWithId(feedId!);

        if (context.mounted && feedResult != null) {
          feed.value = feedResult;

          var communityResult = await CommunityRepository.instance
              .getFromRef(feedResult.communityRef);

          if (context.mounted) {
            community.value = communityResult;
          }
        }
      }

      if (communityId != null) {
        getCommunity();
      } else if (feedId != null) {
        getFeed();
      }

      return null;
    }, const []);

    if (communityId != null && community.value == null) {
      return const LoadingIndicator();
    }

    if (feedId != null && feed.value == null) {
      return const LoadingIndicator();
    }

    return _FeedEdit(
      community: community.value,
      feed: feed.value,
      extra: extra,
    );
  }
}

class _FeedEdit extends HookWidget {
  const _FeedEdit({this.community, this.feed, this.extra});

  final FeedEditArguments? extra;
  final CommunityModel? community;
  final FeedModel? feed;

  @override
  Widget build(BuildContext context) {
    var isEditing = feed != null;
    var t = localization(context);
    var loadingEdit = useState(false);
    var loadingDelete = useState(false);
    var price = useState(feed?.amount ?? 0.0);
    var type = useState(feed?.type ?? FeedType.none);
    var description = useState(feed?.description ?? '');
    var picture = useState<List<String>>(feed?.picture ?? []);

    var visibilityItems = [
      DropdownMenuItem(value: 'public', child: Text(t.public)),
      DropdownMenuItem(value: 'private', child: Text(t.private)),
    ];

    var currencyItems = const [
      DropdownMenuItem(value: 'KRW', child: Text('KRW (₩)')),
      DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
    ];

    var priceController =
        useTextEditingController(text: numFormat.format(price.value));

    var selectedVisibility = useState(
      visibilityItems[feed == null
              ? community?.visibility == false
                  ? 1
                  : 0
              : feed!.visibility == false
                  ? 0
                  : 1]
          .value,
    );

    var selectedCurrency = useState(
      currencyItems[feed == null
              ? community?.currency == CommunityCurrency.krw
                  ? 0
                  : 1
              : feed!.currency == CommunityCurrency.krw
                  ? 0
                  : 1]
          .value,
    );

    useEffect(() {
      if (type.value == FeedType.none) return;

      var newPrice = price.value.abs();
      price.value = newPrice;
      return null;
    }, [type]);

    Future<void> editFeed() async {
      assert(
        community != null,
        'Community should not be null when editing feed.',
      );

      loadingEdit.value = true;
      var feedRef = FirestoreConfig.feedColRef.doc(feed?.id);

      // 1. Upload pictures
      // 1-1. Check deleted pictures
      var deletedPicture = feed?.picture
          .where((element) =>
              Validator.instance.validateURL(element) &&
              !picture.value.contains(element))
          .toList();
      deletedPicture?.forEach((url) => Storage.instance.deleteFromURL(url));

      // 1-2. Add pictures
      var addedPicture =
          picture.value.where((el) => !el.startsWith('http')).toList();

      var downloadURLs = await Storage.instance
          .uploadFeedImages(context, feedRef.id, addedPicture);

      // 2. Feed inputs
      var currency = selectedCurrency.value == currencyItems[1].value
          ? CommunityCurrency.usd
          : CommunityCurrency.krw;

      try {
        var editedFeed = await FeedRepository.instance.edit(
          id: feed?.id,
          // Specify the reference to save at the same path as picture directory
          ref: feed?.id != null ? feedRef : null,
          initialFeedType: feed?.type,
          initialAmount: feed?.amount ?? 0.0,
          visibility: selectedVisibility.value == 'public',
          currency: currency,
          community: community!,
          amount: price.value,
          type: type.value,
          description: description.value,
          picture: [
            ...?feed?.picture
                .where((element) =>
                    Validator.instance.validateURL(element) &&
                    picture.value.contains(element))
                .toList(),
            ...downloadURLs
          ],
        );

        if (context.mounted) {
          extra?.onUpdate?.call(FeedEditResult(
            action: FeedActions.edit,
            feed: editedFeed,
          ));

          context.canPop() ? context.pop() : null;

          snackbar.alert(
            context,
            isEditing ? t.feedEdited : t.feedCreated,
            backgroundColor: AppColors.role.primary,
            textColor: AppColors.text.contrast,
          );
        }
      } catch (e) {
        logger.e(e);

        if (context.mounted) {
          snackbar.alert(
            context,
            t.errorOccurred,
            backgroundColor: AppColors.role.danger,
            textColor: AppColors.text.contrast,
          );
        }
      } finally {
        if (context.mounted) {
          loadingEdit.value = false;
        }
      }
    }

    Future<void> deleteFeed() async {
      alertDialog.confirm(
        context,
        title: t.deleteFeed,
        content: t.deleteFeedDesc,
        onPress: () async {
          if (feed == null) {
            return;
          }

          loadingDelete.value = true;

          try {
            var result = await FeedRepository.instance.delete(feed!);

            if (context.mounted) {
              loadingDelete.value = false;

              if (result) {
                extra?.onUpdate?.call(
                  FeedEditResult(action: FeedActions.delete, feed: feed),
                );
                context.pop();
                return;
              }

              snackbar.alert(
                context,
                t.errorOccurred,
                backgroundColor: AppColors.role.danger,
                textColor: AppColors.text.contrast,
              );
            }
          } catch (err) {
            logger.e(err);
          }
        },
        confirmButtonBackgroundColor: AppColors.role.danger,
        confirmTextColor: AppColors.text.contrast,
        showCancelButton: true,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg.paper,
      appBar: AppBarBack(
        title: Text(
          feed?.description ?? t.newFeed,
          overflow: TextOverflow.ellipsis,
          style: Heading4TextStyle(),
          maxLines: 1,
        ),
        actions: !isEditing
            ? [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Button(
                    loading: loadingEdit.value,
                    disabled: description.value.isEmpty ||
                        (type.value != FeedType.none && price.value <= 0),
                    text: t.post,
                    height: 28,
                    onPress: editFeed,
                    backgroundColor: AppColors.role.primaryLight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    margin: const EdgeInsets.only(right: 12),
                  ),
                ),
              ]
            : isEditing && feed!.isWriter
                ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Button(
                        loading: loadingDelete.value,
                        onPress: deleteFeed,
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        margin: const EdgeInsets.only(right: 6),
                        text: t.delete,
                        color: AppColors.text.contrast,
                        backgroundColor: AppColors.role.danger,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Button(
                        loading: loadingEdit.value,
                        disabled: description.value.isEmpty ||
                            (type.value != FeedType.none && price.value <= 0),
                        text: t.update,
                        height: 28,
                        onPress: editFeed,
                        backgroundColor: AppColors.role.primaryLight,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        margin: const EdgeInsets.only(right: 12),
                      ),
                    ),
                  ]
                : null,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20, bottom: 60),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: AppColors.bg.border),
          color: AppColors.bg.basic,
        ),
        // Note: Without wrapping with [Card], the [RadioGroup] will not show it's border color.
        // This looks like a bug in Flutter.
        child: Card(
          elevation: 0,
          color: AppColors.bg.basic,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 28),
            children: [
              RadioGroup<FeedType>(
                padding: const EdgeInsets.symmetric(vertical: 16),
                label: t.type,
                selected: type.value,
                borderRadius: 8,
                values: const [
                  FeedType.none,
                  FeedType.income,
                  FeedType.consume
                ],
                names: [t.none, t.income, t.consume],
                strokeColor: AppColors.bg.border,
                strokeWidth: 1,
                onChanged: (value) => type.value = value ?? FeedType.none,
              ),

              EditFormText(
                label: '${t.contents} *',
                textHint: t.contentsHint,
                keyboardType: TextInputType.multiline,
                maxLines: 20,
                initialValue: description.value,
                onChanged: (str) => description.value = str,
                margin: const EdgeInsets.only(top: 8, bottom: 20),
                borderRadius: 4,
              ),

              type.value == FeedType.none
                  ? const SizedBox()
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: EditFormText(
                            prefixIcon: type.value == FeedType.consume
                                ? Icon(
                                    Icons.remove,
                                    color: AppColors.role.danger,
                                    size: 16,
                                  )
                                : Icon(
                                    Icons.add,
                                    color: AppColors.role.primary,
                                    size: 16,
                                  ),
                            label: '${t.price} (${t.currency}) *',
                            textHint: t.priceHint,
                            textEditingController: priceController,
                            maxLines: 1,
                            onChanged: (str) {
                              var priceString = str.isEmpty
                                  ? '0'
                                  : str.trim().replaceAll(',', '');

                              try {
                                if (str.isEmpty) return;
                                price.value = double.parse(priceString);
                                var val = numFormat.format(price.value);

                                priceController.value = TextEditingValue(
                                  text: val,
                                  selection: TextSelection.collapsed(
                                      offset: val.length),
                                );
                              } catch (e) {
                                logger.e(e);
                              }
                            },
                            margin: const EdgeInsets.only(bottom: 20),
                            keyboardType: TextInputType.number,
                            borderRadius: 4,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          width: 100,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: AppColors.bg.paper,
                            ),
                            child: DropdownButtonFormField(
                              style: TextStyle(color: AppColors.text.primary),
                              decoration: _dropdownInputDecoration,
                              isExpanded: true,
                              items: currencyItems,
                              value: selectedCurrency.value,
                              onChanged: (str) => selectedCurrency.value = str,
                            ),
                          ),
                        ),
                      ],
                    ),

              // Picture
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.picture, style: Body3TextStyle()),
                  Container(
                    height: 72,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bg.basic,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        PhotoCardAddItem(
                          margin: const EdgeInsets.only(right: 6),
                          onSelectImage: (imageFile) {
                            picture.value = [...picture.value, imageFile.path];
                          },
                        ),
                        ...picture.value
                            .map(
                              (e) => PhotoCardItem(
                                margin: const EdgeInsets.only(right: 6),
                                uri: e,
                                onTap: () => logger.d('onTap $e'),
                                onDelete: () {
                                  if (context.mounted) {
                                    picture.value = picture.value
                                        .where(
                                          (element) =>
                                              element != picture.value.last,
                                        )
                                        .toList();
                                  }
                                },
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: AppColors.bg.paper,
                  ),
                  child: DropdownButtonFormField(
                    style: TextStyle(color: AppColors.text.primary),
                    decoration: _dropdownInputDecoration,
                    isExpanded: true,
                    items: visibilityItems,
                    value: selectedVisibility.value,
                    onChanged: (str) => selectedVisibility.value = str,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
