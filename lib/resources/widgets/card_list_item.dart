import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:sailspad/resources/widgets/sailspad_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app/networking/ar_card_api_service.dart';
import '../../bootstrap/helpers.dart';
import 'custom_icon_button.dart';

class CardListItem extends StatefulWidget {
  const CardListItem({
    Key? key,
    required this.id,
    required this.name,
    required this.title,
    required this.uniqueId,
    required this.cardImage,
    required this.switchToEdit,
  }) : super(key: key);
  final String? id;
  final String? name;
  final String? title;
  final String? uniqueId;
  final String? cardImage;
  final Function switchToEdit;

  @override
  State<CardListItem> createState() => _CardListItemState();
}

class _CardListItemState extends NyState<CardListItem> {
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();
  @override
  init() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    return super.init();
  }

  Future<dynamic> _showARBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 800,
        child: WebView(
          initialUrl:
              'https://sailspad-card-viewer-bitsbysalih.vercel.app/cards/${widget.id}/view',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
      isDismissible: true,
      barrierColor: Colors.grey,
    );
  }

  Future<dynamic> _showQRBottomSheet(BuildContext context) {
    return showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 800,
        child: WebView(
          initialUrl:
              'https://sailspad-card-viewer-bitsbysalih.vercel.app/cards/${widget.id}/qrcode',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
      isDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.size.height * 0.22,
      decoration: BoxDecoration(
        color: Color(0xFFE4E9EA).withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 1,
          color: Color(0xFFE4E9EA),
        ),
      ),
      margin: EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Card Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      width: 2,
                      color: Color(0xFFE3E3E3),
                    ),
                    color: Colors.red,
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.cardImage!,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: mediaQuery.size.width * 0.35,
                      height: mediaQuery.size.height * 0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name!,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            widget.title!,
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Text(
                  widget.uniqueId!.toUpperCase(),
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
            //Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  label: 'Edit',
                  onTap: () {
                    api<ArCardApiService>(
                      (request) => request.setCardToEdit(widget.id as String),
                    );
                    widget.switchToEdit(widget.id);
                  },
                  icon: FontAwesomeIcons.pen,
                ),
                CustomIconButton(
                  label: 'View AR',
                  onTap: () async {
                    await launchUrl(
                      Uri.parse(
                          'https://sailspad-card-viewer-bitsbysalih.vercel.app/cards/${widget.id}/view'),
                      mode: LaunchMode.inAppWebView,
                    );
                  },
                  icon: FontAwesomeIcons.solidEye,
                ),
                CustomIconButton(
                  label: 'Share',
                  onTap: () async {
                    await launchUrl(
                      Uri.parse(
                          'https://sailspad-card-viewer-bitsbysalih.vercel.app/cards/${widget.id}/qrcode'),
                      mode: LaunchMode.inAppWebView,
                    );
                  },
                  icon: SailspadIcons.sailspad_share,
                ),
                CustomIconButton(
                  label: 'Delete',
                  onTap: () {},
                  icon: FontAwesomeIcons.solidTrashCan,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}