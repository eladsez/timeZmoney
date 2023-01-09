import 'package:flutter/material.dart';

/*
 * Theme structure:
   * AppTheme - abstract class that contains all the variables that are used in the app
     * LightTheme - class that extends AppTheme and contains all the variables for the light theme
     * DarkTheme - class that extends AppTheme and contains all the variables for the dark theme
 *
 * colors are defined only in the extended classes
 */

class AppTheme {
  //variables definition

  // main colors
  final Color? accentColor; // for buttons and such
  final Color? appBarColor;
  final Color? backArrowColor;
  final Color? backgroundColor;  // background color of the app
  final Color? cardColor; // background color of the cards, lists, etc.
  final Color? appBarTitleTextStyle;

  // text and text fields colors
  final Color? textFieldBackgroundColor;
  final Color? textFieldTextColor;
  final Color? titleColor;
  final Color? nameColor;
  final Color? emailColor;
  final TextStyle? titleTextStyle;

  // icons colors
  final Color? mainIconColor; // should be the app's main accent color
  final Color? secondaryIconColor; // light gray color
  final Color? themeIconColor;
  final Color? closeIconColor;
  final Color? shareIconBackgroundColor;
  final Color? cameraIconColor;
  final Color? galleryIconColor;

  // buttons colors
  final Color? sendButtonColor;

  //constants - (elevation, etc.)
  final double? elevation;



  // chat specific colors
  final Color? replyDialogColor;
  final Color? outgoingChatBubbleColor;
  final Color? inComingChatBubbleColor;
  final Color? inComingChatBubbleTextColor;
  final Color? repliedMessageColor;
  final Color? repliedTitleTextColor;
  final Color? swipeToReplyIconColor;
  final Color? replyMessageColor;
  final Color? messageReactionBackGroundColor;
  final Color? messageTimeIconColor;
  final Color? messageTimeTextColor;
  final Color? reactionPopupColor;
  final Color? replyPopupColor;
  final Color? replyPopupButtonColor;
  final Color? replyPopupTopBorderColor;
  final Color? reactionPopupTitleColor;
  final Color? flashingCircleDarkColor;
  final Color? flashingCircleBrightColor;
  final Color? messageReactionBorderColor;
  final Color? chatHeaderColor;
  final Color? shareIconColor;
  final Color? verticalBarColor;
  final Color? linkPreviewIncomingChatColor;
  final Color? linkPreviewOutgoingChatColor;
  final TextStyle? linkPreviewIncomingTitleStyle;
  final TextStyle? linkPreviewOutgoingTitleStyle;
  final TextStyle? incomingChatLinkTitleStyle;
  final TextStyle? outgoingChatLinkTitleStyle;
  final TextStyle? outgoingChatLinkBodyStyle;
  final TextStyle? incomingChatLinkBodyStyle;

  // constructor
  AppTheme({
    // main colors
    this.accentColor,
    this.appBarColor,
    this.backArrowColor,
    this.backgroundColor,
    this.cardColor,

    // text and text fields colors
    this.textFieldTextColor,
    this.titleColor,
    this.textFieldBackgroundColor,
    this.appBarTitleTextStyle,
    this.nameColor,
    this.emailColor,
    this.titleTextStyle,

    // icons colors
    this.mainIconColor,
    this.secondaryIconColor,
    this.cameraIconColor,
    this.galleryIconColor,
    this.closeIconColor,
    this.shareIconBackgroundColor,
    this.themeIconColor,
    this.shareIconColor,

    // buttons colors
    this.sendButtonColor,

    //constants - (elevation, etc.)
    this.elevation,


    // chat specific colors
    this.flashingCircleDarkColor,
    this.flashingCircleBrightColor,
    this.outgoingChatLinkBodyStyle,
    this.incomingChatLinkBodyStyle,
    this.incomingChatLinkTitleStyle,
    this.outgoingChatLinkTitleStyle,
    this.linkPreviewOutgoingChatColor,
    this.linkPreviewIncomingChatColor,
    this.linkPreviewIncomingTitleStyle,
    this.linkPreviewOutgoingTitleStyle,
    this.repliedTitleTextColor,
    this.swipeToReplyIconColor,
    this.reactionPopupColor,
    this.replyPopupButtonColor,
    this.replyPopupTopBorderColor,
    this.reactionPopupTitleColor,
    this.replyDialogColor,
    this.outgoingChatBubbleColor,
    this.inComingChatBubbleColor,
    this.inComingChatBubbleTextColor,
    this.repliedMessageColor,
    this.replyMessageColor,
    this.messageReactionBackGroundColor,
    this.messageReactionBorderColor,
    this.verticalBarColor,
    this.chatHeaderColor,
    this.messageTimeIconColor,
    this.messageTimeTextColor,
    this.replyPopupColor,
  });
}

// Dark theme class
// build the dark theme by extending the AppTheme class and overriding the variables using the super constructor
class DarkTheme extends AppTheme {
  DarkTheme({
    // main colors
    Color accentColor = const Color(0xff9f85ff),
    Color appBarColor = const Color(0xff1d1b25),
    Color backArrowColor = Colors.white,
    Color backgroundColor = const Color(0xff272336),
    Color cardColor = const Color(0xff383152),

    // text and text fields colors
    Color textFieldTextColor = Colors.white,
    Color titleColor = Colors.white,
    Color appBarTitleTextColor = Colors.white,
    Color nameColor = Colors.white,
    Color emailColor = Colors.grey,
    TextStyle titleTextStyle = const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold),

    // icons colors
    Color mainIconColor = Colors.white,
    Color secondaryIconColor = Colors.grey,
    Color closeIconColor = Colors.white,
    Color shareIconBackgroundColor = const Color(0xff383152),
    Color cameraIconColor = const Color(0xff757575),
    Color galleryIconColor = const Color(0xff757575),
    Color themeIconColor = Colors.white,
    Color shareIconColor = Colors.white,

    // buttons colors
    Color sendButtonColor = Colors.white,

    //constants - (elevation, etc.)
    double elevation = 1,


    // chat specific colors
    Color flashingCircleDarkColor = Colors.grey,
    Color flashingCircleBrightColor = const Color(0xffeeeeee),
    TextStyle incomingChatLinkTitleStyle = const TextStyle(color: Colors.black),
    TextStyle outgoingChatLinkTitleStyle = const TextStyle(color: Colors.white),
    TextStyle outgoingChatLinkBodyStyle = const TextStyle(color: Colors.white),
    TextStyle incomingChatLinkBodyStyle = const TextStyle(color: Colors.white),
    Color repliedTitleTextColor = Colors.white,
    Color? swipeToReplyIconColor = Colors.white,
    Color replyDialogColor = const Color(0xff272336),
    Color linkPreviewOutgoingChatColor = const Color(0xff272336),
    Color linkPreviewIncomingChatColor = const Color(0xff9f85ff),
    TextStyle linkPreviewIncomingTitleStyle = const TextStyle(),
    TextStyle linkPreviewOutgoingTitleStyle = const TextStyle(),
    Color textFieldBackgroundColor = const Color(0xff383152),
    Color outgoingChatBubbleColor = const Color(0xff9f85ff),
    Color inComingChatBubbleColor = const Color(0xff383152),
    Color reactionPopupColor = const Color(0xff383152),
    Color replyPopupColor = const Color(0xff383152),
    Color replyPopupButtonColor = Colors.white,
    Color replyPopupTopBorderColor = Colors.black54,
    Color reactionPopupTitleColor = Colors.white,
    Color inComingChatBubbleTextColor = Colors.white,
    Color repliedMessageColor = const Color(0xff9f85ff),
    Color replyMessageColor = Colors.grey,
    Color messageReactionBackGroundColor = const Color(0xff383152),
    Color messageReactionBorderColor = const Color(0xff272336),
    Color verticalBarColor = const Color(0xff383152),
    Color chatHeaderColor = Colors.white,
    Color messageTimeIconColor = Colors.white,
    Color messageTimeTextColor = Colors.white,
  }) : super(
    // main colors
    accentColor: accentColor,
    appBarColor: appBarColor,
    backgroundColor: backgroundColor,
    backArrowColor: backArrowColor,
    cardColor: cardColor,

    // text and text fields colors
    textFieldBackgroundColor: textFieldBackgroundColor,
    titleColor: titleColor,
    appBarTitleTextStyle: appBarTitleTextColor,
    textFieldTextColor: textFieldTextColor,
    nameColor: nameColor,
    emailColor: emailColor,
    titleTextStyle: titleTextStyle,

    // icons colors
    mainIconColor: mainIconColor,
    secondaryIconColor: secondaryIconColor,
    closeIconColor: closeIconColor,
    shareIconBackgroundColor: shareIconBackgroundColor,
    themeIconColor: themeIconColor,
    shareIconColor: shareIconColor,
    galleryIconColor: galleryIconColor,
    cameraIconColor: cameraIconColor,

    // buttons colors
    sendButtonColor: sendButtonColor,

    // constants - (elevation, etc.)
    elevation: elevation,


    // chat specific colors
    verticalBarColor: verticalBarColor,
    replyDialogColor: replyDialogColor,
    chatHeaderColor: chatHeaderColor,
    inComingChatBubbleColor: inComingChatBubbleColor,
    inComingChatBubbleTextColor: inComingChatBubbleTextColor,
    messageReactionBackGroundColor: messageReactionBackGroundColor,
    messageReactionBorderColor: messageReactionBorderColor,
    outgoingChatBubbleColor: outgoingChatBubbleColor,
    repliedMessageColor: repliedMessageColor,
    replyMessageColor: replyMessageColor,
    messageTimeIconColor: messageTimeIconColor,
    messageTimeTextColor: messageTimeTextColor,
    repliedTitleTextColor: repliedTitleTextColor,
    swipeToReplyIconColor: swipeToReplyIconColor,
    reactionPopupColor: reactionPopupColor,
    replyPopupColor: replyPopupColor,
    replyPopupButtonColor: replyPopupButtonColor,
    replyPopupTopBorderColor: replyPopupTopBorderColor,
    reactionPopupTitleColor: reactionPopupTitleColor,
    linkPreviewOutgoingChatColor: linkPreviewOutgoingChatColor,
    linkPreviewIncomingChatColor: linkPreviewIncomingChatColor,
    linkPreviewIncomingTitleStyle: linkPreviewIncomingTitleStyle,
    linkPreviewOutgoingTitleStyle: linkPreviewOutgoingTitleStyle,
    incomingChatLinkBodyStyle: incomingChatLinkBodyStyle,
    incomingChatLinkTitleStyle: incomingChatLinkTitleStyle,
    outgoingChatLinkBodyStyle: outgoingChatLinkBodyStyle,
    outgoingChatLinkTitleStyle: outgoingChatLinkTitleStyle,
    flashingCircleDarkColor: flashingCircleDarkColor,
    flashingCircleBrightColor: flashingCircleBrightColor,
  );
}

// Light theme class
// build the light theme by extending the AppTheme class and overriding the variables using the super constructor
class LightTheme extends AppTheme {
  LightTheme({
    // main colors
    Color accentColor = const Color(0xff01b2b8),
    Color appBarColor = Colors.white,
    Color backArrowColor = const Color(0xffEE5366),
    Color backgroundColor = const Color(0xffeeeeee),
    Color cardColor = Colors.white,

    // text and text fields colors
    Color textFieldTextColor = Colors.black,
    Color titleColor = Colors.black,
    Color textFieldBackgroundColor = Colors.white,
    Color appBarTitleTextColor = Colors.black,
    Color nameColor = Colors.black,
    Color emailColor = Colors.grey,
    TextStyle titleTextStyle = const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold),


    // icons colors
    Color mainIconColor = const Color(0xffEE5366),
    Color secondaryIconColor = Colors.grey,
    Color closeIconColor = Colors.black,
    Color shareIconBackgroundColor = const Color(0xFFE0E0E0),
    Color cameraIconColor = Colors.black,
    Color galleryIconColor = Colors.black,
    Color themeIconColor = Colors.black,
    Color shareIconColor = Colors.black,

    // buttons colors
    Color sendButtonColor = const Color(0xffEE5366),

    // constants - (elevation, etc.)
    double elevation = 2,


    // chat specific colors
    Color flashingCircleDarkColor = const Color(0xffEE5366),
    Color flashingCircleBrightColor = const Color(0xffFCD8DC),
    TextStyle incomingChatLinkTitleStyle = const TextStyle(color: Colors.black),
    TextStyle outgoingChatLinkTitleStyle = const TextStyle(color: Colors.black),
    TextStyle outgoingChatLinkBodyStyle = const TextStyle(color: Colors.grey),
    TextStyle incomingChatLinkBodyStyle = const TextStyle(color: Colors.grey),
    Color repliedTitleTextColor = Colors.black,
    Color swipeToReplyIconColor = Colors.black,
    Color replyDialogColor = const Color(0xffFCD8DC),
    Color linkPreviewOutgoingChatColor = const Color(0xffFCD8DC),
    Color linkPreviewIncomingChatColor = const Color(0xFFEEEEEE),
    TextStyle linkPreviewIncomingTitleStyle = const TextStyle(),
    TextStyle linkPreviewOutgoingTitleStyle = const TextStyle(),
    Color reactionPopupColor = Colors.white,
    Color replyPopupColor = Colors.white,
    Color replyPopupButtonColor = Colors.black,
    Color replyPopupTopBorderColor = const Color(0xFFBDBDBD),
    Color reactionPopupTitleColor = Colors.grey,
    Color outgoingChatBubbleColor = const Color(0xffEE5366),
    Color inComingChatBubbleColor = Colors.white,
    Color inComingChatBubbleTextColor = Colors.black,
    Color repliedMessageColor = const Color(0xffff8aad),
    Color replyMessageColor = Colors.black,
    Color messageReactionBackGroundColor = const Color(0xFFEEEEEE),
    Color messageReactionBorderColor = Colors.white,
    Color verticalBarColor = const Color(0xffEE5366),
    Color chatHeaderColor = Colors.black,
    Color messageTimeIconColor = Colors.black,
    Color messageTimeTextColor = Colors.black,
  }) : super(
    // main colors
    accentColor: accentColor,
    backgroundColor: backgroundColor,
    appBarColor: appBarColor,
    backArrowColor: backArrowColor,
    cardColor: cardColor,

    // text and text fields colors
    titleColor: titleColor,
    textFieldBackgroundColor: textFieldBackgroundColor,
    appBarTitleTextStyle: appBarTitleTextColor,
    textFieldTextColor: textFieldTextColor,
    nameColor: nameColor,
    emailColor: emailColor,
    titleTextStyle: titleTextStyle,

    // icons colors
    mainIconColor: mainIconColor,
    secondaryIconColor: secondaryIconColor,
    closeIconColor: closeIconColor,
    shareIconBackgroundColor: shareIconBackgroundColor,
    themeIconColor: themeIconColor,
    shareIconColor: shareIconColor,
    galleryIconColor: galleryIconColor,
    cameraIconColor: cameraIconColor,

    // buttons colors
    sendButtonColor: sendButtonColor,

    // constants - (elevation, etc.)
    elevation: elevation,


    // chat specific colors
    reactionPopupColor: reactionPopupColor,
    verticalBarColor: verticalBarColor,
    replyDialogColor: replyDialogColor,
    chatHeaderColor: chatHeaderColor,
    inComingChatBubbleColor: inComingChatBubbleColor,
    inComingChatBubbleTextColor: inComingChatBubbleTextColor,
    messageReactionBackGroundColor: messageReactionBackGroundColor,
    messageReactionBorderColor: messageReactionBorderColor,
    outgoingChatBubbleColor: outgoingChatBubbleColor,
    repliedMessageColor: repliedMessageColor,
    replyMessageColor: replyMessageColor,
    messageTimeIconColor: messageTimeIconColor,
    messageTimeTextColor: messageTimeTextColor,
    repliedTitleTextColor: repliedTitleTextColor,
    swipeToReplyIconColor: swipeToReplyIconColor,
    replyPopupColor: replyPopupColor,
    replyPopupButtonColor: replyPopupButtonColor,
    replyPopupTopBorderColor: replyPopupTopBorderColor,
    reactionPopupTitleColor: reactionPopupTitleColor,
    linkPreviewOutgoingChatColor: linkPreviewOutgoingChatColor,
    linkPreviewIncomingChatColor: linkPreviewIncomingChatColor,
    linkPreviewIncomingTitleStyle: linkPreviewIncomingTitleStyle,
    linkPreviewOutgoingTitleStyle: linkPreviewOutgoingTitleStyle,
    incomingChatLinkBodyStyle: incomingChatLinkBodyStyle,
    incomingChatLinkTitleStyle: incomingChatLinkTitleStyle,
    outgoingChatLinkBodyStyle: outgoingChatLinkBodyStyle,
    outgoingChatLinkTitleStyle: outgoingChatLinkTitleStyle,
    flashingCircleDarkColor: flashingCircleDarkColor,
    flashingCircleBrightColor: flashingCircleBrightColor,
  );
}