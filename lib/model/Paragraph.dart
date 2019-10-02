import 'package:flutter/material.dart';
import 'package:flutter_wordpress_content/wp_parser.dart';

import 'SimpleArticle.dart';

class Paragraph {
  final String type;
  final String rawContent;
  final List<TextSpan> textSpans;
  final String imageUri;
  final String imageCaption;
  final String jwMediaId;
  final String youtubeVideoId;
  final String soundcloudTrackId;
  final String fontFamily;
  final TextAlign textAlign;
  final SimpleArticle pdf;

  const Paragraph(
      {this.type,
      this.rawContent,
      this.textSpans,
      this.imageUri,
      this.imageCaption,
      this.jwMediaId,
      this.youtubeVideoId,
      this.soundcloudTrackId,
      this.fontFamily,
      this.textAlign,
      this.pdf});

  factory Paragraph.heading(String rawContent, List<TextSpan> textSpans,
      String fontFamily, TextAlign textAlign) {
    return Paragraph(
        type: "heading",
        rawContent: rawContent,
        textSpans: textSpans,
        imageUri: "",
        imageCaption: "",
        jwMediaId: "",
        youtubeVideoId: "",
        soundcloudTrackId: "",
        fontFamily: fontFamily,
        textAlign: textAlign);
  }

  factory Paragraph.text(String rawContent, List<TextSpan> textSpans,
      String fontFamily, TextAlign textAlign) {
    return Paragraph(
        type: "text",
        rawContent: rawContent,
        textSpans: textSpans,
        imageUri: "",
        imageCaption: "",
        jwMediaId: "",
        youtubeVideoId: "",
        soundcloudTrackId: "",
        fontFamily: fontFamily,
        textAlign: textAlign);
  }

  factory Paragraph.image(String imageUri, String caption) {
    return Paragraph(
      type: "image",
      rawContent: "",
      textSpans: List<TextSpan>(),
      imageUri: imageUri,
      imageCaption: caption,
      jwMediaId: "",
      youtubeVideoId: "",
      soundcloudTrackId: "",
    );
  }

  factory Paragraph.jwplayer(String url) {
    return Paragraph(
      type: "youtube",
      rawContent: "",
      textSpans: List<TextSpan>(),
      imageUri: "",
      imageCaption: "",
      jwMediaId: url,
      youtubeVideoId: "",
      soundcloudTrackId: "",
    );
  }

  factory Paragraph.youtubeEmbed(String videoId) {
    return Paragraph(
      type: "youtube",
      rawContent: "",
      textSpans: List<TextSpan>(),
      imageUri: "",
      imageCaption: "",
      jwMediaId: "",
      youtubeVideoId: videoId,
      soundcloudTrackId: "",
    );
  }

  factory Paragraph.soundcloudEmbed(String trackId) {
    return Paragraph(
      type: "soundcloud",
      rawContent: "",
      textSpans: List<TextSpan>(),
      imageUri: "",
      imageCaption: "",
      jwMediaId: "",
      youtubeVideoId: "",
      soundcloudTrackId: trackId,
    );
  }

  factory Paragraph.issuu(SimpleArticle pdfArticle) {
    return Paragraph(
        type: "issuu",
        rawContent: "",
        textSpans: List<TextSpan>(),
        imageUri: "",
        imageCaption: "",
        youtubeVideoId: "",
        soundcloudTrackId: "",
        pdf: pdfArticle);
  }

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    if (json == null) return new Paragraph();

    TextAlign textAlign = TextAlign.right;
    try {
      String textAlignString = json['textAlign'];
      textAlign = textAlignString == 'left'
          ? TextAlign.left
          : textAlignString == 'center' ? TextAlign.center : TextAlign.right;
    } catch (exception) {/* ignore */}

    String type = json["type"];

    String rawContent = json["rawContent"];

    String fontFamily = json["fontFamily"];

    List<TextSpan> textSpans = List<TextSpan>();
    try {
      if (type == "heading") {
        textSpans = parseHeadingHTML(rawContent,
                textAlign: textAlign, fontFamily: fontFamily)
            .textSpans;
      } else if (type == "text") {
        textSpans = parseParagraphHTML(rawContent,
                textAlign: textAlign, fontFamily: fontFamily)
            .textSpans;
      }
    } catch (exception) {/* ignore */}

    return Paragraph(
        type: json["type"],
        rawContent: rawContent,
        textSpans: textSpans,
        imageUri: json["imageUri"],
        imageCaption: json["imageCaption"],
        youtubeVideoId: json["youtubeVideoId"],
        soundcloudTrackId: json["soundcloudTrackId"],
        fontFamily: fontFamily,
        textAlign: textAlign);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'rawContent': rawContent,
      'imageUri': imageUri,
      'imageCaption': imageCaption,
      'youtubeVideoId': youtubeVideoId,
      'soundcloudTrackId': soundcloudTrackId,
      'fontFamily': fontFamily,
      'textAlign': textAlign == TextAlign.left
          ? 'left'
          : textAlign == TextAlign.center ? 'center' : 'right',
    };
  }

  static List<dynamic> toJsonFromList(List<Paragraph> paragraphs) {
    return paragraphs.map((p) => p.toJson()).toList();
  }
}
