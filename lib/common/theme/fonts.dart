import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

TextTheme buildTextTheme(
  TextTheme base,
  String? language, [
  String fontFamily = 'Arial',
  String fontHeader = 'Raleway',
]) {
  return base
      .copyWith(
        headline1: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.headline1!.copyWith(
            fontWeight: FontWeight.w700,

            /// If using the custom font, un-comment below and clone to other headline.., bodyText..
            fontFamily: 'Klavika',
          ),
        ),
        headline2: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.headline1!.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: 'Klavika',
          ),
        ),
        headline3: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.headline3!.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: 'Klavika',
          ),
        ),
        headline4: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.headline4!.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: 'Klavika',
          ),
        ),
        headline5: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.headline5!.copyWith(
            fontWeight: FontWeight.w500,
            fontFamily: 'Klavika',
          ),
        ),
        headline6: GoogleFonts.getFont(
          fontHeader,
          textStyle: base.headline6!.copyWith(
            fontSize: 18.0,
            fontFamily: 'Klavika',
          ),
        ),
        caption: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.caption!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
            fontFamily: 'Klavika',
          ),
        ),
        subtitle1: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.subtitle1!.copyWith(
            fontFamily: 'Klavika',
          ),
        ),
        subtitle2: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.subtitle2!.copyWith(
            fontFamily: 'Klavika',
          ),
        ),
        bodyText1: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.bodyText1!.copyWith(
            fontFamily: 'Klavika',
          ),
        ),
        bodyText2: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.bodyText1!.copyWith(
            fontFamily: 'Klavika',
          ),
        ),
        button: GoogleFonts.getFont(
          fontFamily,
          textStyle: base.button!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
            fontFamily: 'Klavika',
          ),
        ),
      )
      .apply(
        displayColor: kGrey900,
        bodyColor: kGrey900,
      );
}
