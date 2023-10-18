import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:nyoba/constant/global_url.dart';
import 'package:nyoba/models/blog_model.dart';
import 'package:nyoba/provider/blog_provider.dart';
import 'package:nyoba/services/session.dart';
import 'package:nyoba/utils/share_link.dart';
import 'package:nyoba/utils/utility.dart';
import 'package:nyoba/widgets/blog/blog_detail_shimmer.dart';

import '../../app_localizations.dart';
import '../../provider/app_provider.dart';
import '../../provider/home_provider.dart';

class BlogDetail extends StatefulWidget {
  final String? id;
  final int? index;
  final String? slug;
  final BlogModel? blog;

  BlogDetail({
    Key? key,
    this.id,
    this.index,
    this.slug,
    this.blog,
  }) : super(key: key);

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  TextEditingController commentController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  BlogModel? blogModel;
  bool blogCommentFeature = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    printLog(widget.blog.toString(), name: "WIDGET BLOG");

    if (widget.blog == null) {
      loadDetail();
    } else {
      loadComment(widget.id);
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  loadDetail() async {
    if (widget.slug == null) {
      await Provider.of<BlogProvider>(context, listen: false)
          .fetchBlogDetailById(int.parse(widget.id!))
          .then((value) {
        setState(() {
          blogModel = value;
        });
        loadComment(blogModel!.id);
      });
    } else {
      // await Provider.of<BlogProvider>(context, listen: false)
      //     .fetchBlogDetailBySlug(widget.slug)
      //     .then((value) {
      //   setState(() {
      //     blogModel = value;
      //   });
      // });
      loadComment(blogModel!.id);
    }
    setState(() async {
      blogCommentFeature =
          await Provider.of<HomeProvider>(context, listen: false)
              .fetchBlogComment();
      printLog(blogCommentFeature.toString(), name: 'fitur komen');
    });
  }

  loadComment(postId) async {
    await Provider.of<BlogProvider>(context, listen: false)
        .fetchBlogComment(postId, true);
  }

  refresh() {
    loadDetail();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<AppNotifier>(context, listen: false).appLocal;
    final blog = Provider.of<BlogProvider>(context, listen: false);
    Widget buildComments = Container(
      child: ListenableProvider.value(
        value: blog,
        child: Consumer<BlogProvider>(builder: (context, value, child) {
          if (value.loadingComment) {
            return customLoading();
          }
          return blog.blogComment.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "${blog.blogComment.length} ${AppLocalizations.of(context)!.translate('comments')} :",
                        style: TextStyle(fontSize: responsiveFont(12)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListView.separated(
                        primary: false,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 15,
                          );
                        },
                        shrinkWrap: true,
                        itemCount: blog.blogComment.length,
                        itemBuilder: (context, i) {
                          return comment(blog.blogComment[i]);
                        })
                  ],
                )
              : Center(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 48,
                          color: primaryColor,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('comment_empty')!,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );
        }),
      ),
    );

    var postComment = () async {
      if (commentController.text.isNotEmpty) {
        print('Start Commenting...');
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        final Future<Map<String, dynamic>?> postResponse = blog.postComment(
            blogModel == null ? widget.blog!.id : blogModel!.id,
            comment: commentController.text);

        postResponse.then((value) {
          commentController.clear();
          if (value!['data']['status'] == 200) {
            // UserModel user = UserModel.fromJson(value['user']);
            if (_scrollController.hasClients) {
              _scrollController
                  .jumpTo(_scrollController.position.minScrollExtent);
            }
            loadComment(blogModel == null ? widget.blog!.id : blogModel!.id);
            //blog.blogs[widget.index!].blogCommentaries = blog.blogComment;
          } else {
            snackBar(context, message: value['message'], color: Colors.red);
          }
        });
      } else {
        snackBar(context,
            message: AppLocalizations.of(context)!
                .translate('snackbar_login_required')!);
      }
    };

    return ColorfulSafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Blog Detail",
                style: TextStyle(
                  fontSize: responsiveFont(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
              // backgroundColor: Colors.white,
              leading: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_back,
                    // color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              actions: [
                IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.share,
                      // color: Colors.black,
                    ),
                    onPressed: () {
                      shareLinks('blog', blogModel!.link, context, locale);
                    })
              ],
            ),
            body: blog.loadingDetail
                ? BlogDetailShimmer()
                : SmartRefresher(
                    controller: _refreshController,
                    onRefresh: refresh,
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.blog != null
                              ? Container(
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      enableInfiniteScroll: false,
                                      autoPlay: true,
                                      viewportFraction: 1,
                                      aspectRatio: 16 / 9,
                                    ),
                                    items: [
                                      for (var i = 0;
                                          i < widget.blog!.blogImages!.length;
                                          i++)
                                        AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: CachedNetworkImage(
                                            imageUrl: widget
                                                .blog!.blogImages![i].srcImg!,
                                            fit: BoxFit.fitHeight,
                                            placeholder: (context, url) =>
                                                customLoading(),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.image_not_supported_rounded,
                                              size: 25,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              : blogModel!.blogImages != null
                                  ? Container(
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                          enableInfiniteScroll: false,
                                          autoPlay: true,
                                          viewportFraction: 1,
                                          aspectRatio: 16 / 9,
                                        ),
                                        items: [
                                          for (var i = 0;
                                              i < blogModel!.blogImages!.length;
                                              i++)
                                            AspectRatio(
                                              aspectRatio: 16 / 9,
                                              child: CachedNetworkImage(
                                                imageUrl: blogModel!
                                                    .blogImages![i].srcImg!,
                                                fit: BoxFit.fitHeight,
                                                placeholder: (context, url) =>
                                                    customLoading(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(
                                                  Icons
                                                      .image_not_supported_rounded,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                          // Container(
                          //   padding: EdgeInsets.only(top: 10),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //     topLeft: Radius.circular(15),
                          //     topRight: Radius.circular(15),
                          //   )),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Container(
                          //         margin: EdgeInsets.symmetric(
                          //           horizontal: 15,
                          //         ),
                          //         child: Text(
                          //           blogModel!.title!,
                          //           style: TextStyle(
                          //               fontSize: responsiveFont(18),
                          //               fontWeight: FontWeight.w500),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.symmetric(
                          //           horizontal: 15,
                          //         ),
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Row(
                          //               children: [
                          //                 Container(
                          //                     padding: EdgeInsets.all(2),
                          //                     width: 40.w,
                          //                     height: 40.h,
                          //                     decoration: BoxDecoration(
                          //                       shape: BoxShape.circle,
                          //                       border: Border.all(
                          //                           color: HexColor("c4c4c4")),
                          //                     ),
                          //                     child:
                          //                         // ClipOval(
                          //                         //   child:
                          //                         //       // Image.asset("images/lobby/laptop.png")
                          //                         //       Icon(
                          //                         //     Icons.person,
                          //                         //     size: 30,
                          //                         //   ),
                          //                         // ),
                          //                         CircleAvatar(
                          //                       radius: 30.0,
                          //                       backgroundColor:
                          //                           Colors.transparent,
                          //                       child: Icon(
                          //                         Icons.person,
                          //                         size: 40,
                          //                       ),
                          //                     )),
                          //                 Container(
                          //                   width: 12,
                          //                 ),
                          //                 Text(
                          //                   blogModel!.author!,
                          //                   style: TextStyle(
                          //                       fontSize: responsiveFont(12),
                          //                       fontWeight: FontWeight.w500),
                          //                 )
                          //               ],
                          //             ),
                          //             Text(
                          //               convertDateFormatSlash(
                          //                   DateTime.parse(blogModel!.date!)),
                          //               style: TextStyle(
                          //                   fontSize: responsiveFont(10)),
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //       Container(
                          //           margin: EdgeInsets.symmetric(
                          //             horizontal: 15,
                          //           ),
                          //           child: HtmlWidget(
                          //             blogModel!.content!,
                          //             textStyle: TextStyle(
                          //                 fontSize: responsiveFont(13)),
                          //           )),
                          //       Container(
                          //         height: 10,
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.symmetric(
                          //           horizontal: 15,
                          //         ),
                          //         child: Row(
                          //           children: [
                          //             GestureDetector(
                          //                 onTap: () {},
                          //                 child: Container(
                          //                     child: Icon(
                          //                   Icons.local_offer,
                          //                   color: secondaryColor,
                          //                 ))),
                          //             SizedBox(
                          //               width: 10,
                          //             ),
                          //             Expanded(
                          //               child: Wrap(
                          //                 children: [
                          //                   for (var i = 0;
                          //                       i <
                          //                           blogModel!
                          //                               .blogCategories!.length;
                          //                       i++)
                          //                     Row(
                          //                       mainAxisSize: MainAxisSize.min,
                          //                       children: [
                          //                         tag(blogModel!
                          //                             .blogCategories![i]
                          //                             .categoryName!),
                          //                         SizedBox(
                          //                           width: 5,
                          //                         ),
                          //                       ],
                          //                     )
                          //                 ],
                          //               ),
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.symmetric(vertical: 15),
                          //         color: HexColor("c4c4c4"),
                          //         height: 1,
                          //         width: double.infinity,
                          //       ),
                          //       buildComments,
                          //       SizedBox(
                          //         height: 15,
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.symmetric(
                          //           horizontal: 15,
                          //         ),
                          //         child: Text(
                          //           AppLocalizations.of(context)!
                          //               .translate('leave_comment')!,
                          //           style: TextStyle(
                          //               fontSize: responsiveFont(12),
                          //               color: secondaryColor,
                          //               fontWeight: FontWeight.w500),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 5,
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsets.only(
                          //             bottom: MediaQuery.of(context)
                          //                 .viewInsets
                          //                 .bottom),
                          //         child: Column(
                          //           children: [
                          //             Container(
                          //               margin: EdgeInsets.symmetric(
                          //                 horizontal: 15,
                          //               ),
                          //               child: TextField(
                          //                   controller: commentController,
                          //                   maxLines: 5,
                          //                   textInputAction:
                          //                       TextInputAction.done,
                          //                   decoration: InputDecoration(
                          //                       hintText: AppLocalizations.of(
                          //                               context)!
                          //                           .translate('hint_comment'),
                          //                       hintStyle: TextStyle(
                          //                           fontSize:
                          //                               responsiveFont(12)),
                          //                       filled: true)),
                          //             ),
                          //             SizedBox(
                          //               height: 15,
                          //             ),
                          //             Visibility(
                          //               visible: Session.data
                          //                           .getBool('isLogin') ==
                          //                       null ||
                          //                   !Session.data.getBool('isLogin')!,
                          //               child: Center(
                          //                 child: Column(
                          //                   crossAxisAlignment:
                          //                       CrossAxisAlignment.center,
                          //                   children: [
                          //                     Icon(
                          //                       Icons.info_outline,
                          //                       size: 48,
                          //                       color: primaryColor,
                          //                     ),
                          //                     Text(AppLocalizations.of(context)!
                          //                         .translate('logged_comment')!)
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //             Visibility(
                          //                 visible: Session.data
                          //                             .getBool('isLogin') !=
                          //                         null &&
                          //                     Session.data.getBool('isLogin')!,
                          //                 child: Container(
                          //                   margin: EdgeInsets.symmetric(
                          //                     horizontal: 15,
                          //                   ),
                          //                   width: double.infinity,
                          //                   alignment: Alignment.centerRight,
                          //                   child: TextButton(
                          //                     onPressed: postComment,
                          //                     style: TextButton.styleFrom(
                          //                         backgroundColor:
                          //                             secondaryColor,
                          //                         padding: EdgeInsets.symmetric(
                          //                             horizontal: 18,
                          //                             vertical: 6)),
                          //                     child: Text(
                          //                       AppLocalizations.of(context)!
                          //                           .translate('comment')!,
                          //                       style: TextStyle(
                          //                           color: Colors.white),
                          //                     ),
                          //                   ),
                          //                 ))
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // )
                          Consumer<HomeProvider>(
                              builder: (context, value, child) {
                            return Container(
                              padding: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Text(
                                      widget.blog == null
                                          ? blogModel!.title!
                                          : widget.blog!.title!,
                                      style: TextStyle(
                                          fontSize: responsiveFont(18),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(2),
                                                width: 40.w,
                                                height: 40.h,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color:
                                                          HexColor("c4c4c4")),
                                                ),
                                                child:
                                                    // ClipOval(
                                                    //   child:
                                                    //       // Image.asset("images/lobby/laptop.png")
                                                    //       Icon(
                                                    //     Icons.person,
                                                    //     size: 30,
                                                    //   ),
                                                    // ),
                                                    CircleAvatar(
                                                  radius: 30.0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 40,
                                                  ),
                                                )),
                                            Container(
                                              width: 12,
                                            ),
                                            Text(
                                              widget.blog == null
                                                  ? blogModel!.author!
                                                  : widget.blog!.author!,
                                              style: TextStyle(
                                                  fontSize: responsiveFont(12),
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                        Text(
                                          convertDateFormatSlash(DateTime.parse(
                                              widget.blog == null
                                                  ? blogModel!.date!
                                                  : widget.blog!.date!)),
                                          style: TextStyle(
                                              fontSize: responsiveFont(10)),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      child: HtmlWidget(
                                        widget.blog == null
                                            ? blogModel!.content!
                                            : widget.blog!.content!,
                                        textStyle: TextStyle(
                                            fontSize: responsiveFont(13)),
                                      )),
                                  Container(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                                child: Icon(
                                              Icons.local_offer,
                                              color: secondaryColor,
                                            ))),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        widget.blog == null
                                            ? Expanded(
                                                child: Wrap(
                                                  children: [
                                                    for (var i = 0;
                                                        i <
                                                            blogModel!
                                                                .blogCategories!
                                                                .length;
                                                        i++)
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          tag(blogModel!
                                                              .blogCategories![
                                                                  i]
                                                              .categoryName!),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                        ],
                                                      )
                                                  ],
                                                ),
                                              )
                                            : Expanded(
                                                child: Wrap(
                                                  children: [
                                                    for (var i = 0;
                                                        i <
                                                            widget
                                                                .blog!
                                                                .blogCategories!
                                                                .length;
                                                        i++)
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          tag(widget
                                                              .blog!
                                                              .blogCategories![
                                                                  i]
                                                              .categoryName!),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                        ],
                                                      )
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 15),
                                    color: HexColor("c4c4c4"),
                                    height: 1,
                                    width: double.infinity,
                                  ),
                                  value.loading
                                      ? Container()
                                      : value.blogCommentFeature
                                          ? buildComments
                                          : Container(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  value.loading
                                      ? Container()
                                      : value.blogCommentFeature
                                          ? Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .translate(
                                                        'leave_comment')!,
                                                style: TextStyle(
                                                    fontSize:
                                                        responsiveFont(12),
                                                    color: secondaryColor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          : Container(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  value.loading
                                      ? Container()
                                      : value.blogCommentFeature
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                    ),
                                                    child: TextField(
                                                        controller:
                                                            commentController,
                                                        maxLines: 5,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        decoration: InputDecoration(
                                                            hintText: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .translate(
                                                                    'hint_comment'),
                                                            hintStyle: TextStyle(
                                                                fontSize:
                                                                    responsiveFont(
                                                                        12)),
                                                            filled: true)),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Visibility(
                                                    visible: Session.data
                                                                .getBool(
                                                                    'isLogin') ==
                                                            null ||
                                                        !Session.data.getBool(
                                                            'isLogin')!,
                                                    child: Center(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.info_outline,
                                                            size: 48,
                                                            color: primaryColor,
                                                          ),
                                                          Text(AppLocalizations
                                                                  .of(context)!
                                                              .translate(
                                                                  'logged_comment')!)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                      visible: Session.data
                                                                  .getBool(
                                                                      'isLogin') !=
                                                              null &&
                                                          Session.data.getBool(
                                                              'isLogin')!,
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 15,
                                                        ),
                                                        width: double.infinity,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: TextButton(
                                                          onPressed:
                                                              postComment,
                                                          style: TextButton.styleFrom(
                                                              backgroundColor:
                                                                  secondaryColor,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          18,
                                                                      vertical:
                                                                          6)),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    'comment')!,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            )
                                          : Container()
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  )));
  }

  Widget comment(BlogCommentModel blogComment) {
    bool _isNumeric(String? str) {
      if (str == null) {
        return false;
      }
      return double.tryParse(str) != null;
    }

    List _phoneNumberName = blogComment.authorName!.split("");

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(2),
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: HexColor("c4c4c4")),
              ),
              child:
                  // ClipOval(
                  //     child:
                  //         // Image.asset("images/lobby/laptop.png")
                  //         Icon(
                  //   Icons.person,
                  //   size: 30,
                  // )),
                  CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.person,
                  size: 40,
                ),
              )),
          Container(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isNumeric(blogComment.authorName!)
                          ? '${_phoneNumberName[0]}${_phoneNumberName[1]}${_phoneNumberName[2]}*****${_phoneNumberName[_phoneNumberName.length - 3]}${_phoneNumberName[_phoneNumberName.length - 2]}${_phoneNumberName[_phoneNumberName.length - 1]}'
                          : blogComment.authorName!,
                      style: TextStyle(
                          fontSize: responsiveFont(10),
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      convertDateFormatFull(DateTime.parse(blogComment.date!)),
                      style: TextStyle(
                          fontSize: responsiveFont(10),
                          fontWeight: FontWeight.w400,
                          color: primaryColor),
                    )
                  ],
                ),
                Container(
                  height: 5,
                ),
                HtmlWidget(
                  blogComment.content!,
                  textStyle: TextStyle(fontSize: responsiveFont(10)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget tag(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: secondaryColor)),
      child: Text(
        title,
        style: TextStyle(color: primaryColor),
      ),
    );
  }

  Widget appBar() {
    return Material(
      color: Colors.white,
      elevation: 5,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          })),
                  SizedBox(
                    width: 15.w,
                  ),
                  IconButton(icon: Icon(Icons.share), onPressed: () {}),
                ],
              ))),
    );
  }
}
