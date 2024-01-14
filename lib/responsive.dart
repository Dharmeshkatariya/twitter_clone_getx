import 'dart:developer';
import 'package:flutter/cupertino.dart';

class Responsive {
  static late double _screenWidth;
  static late double _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;
  static late double text;
  static late double icon;
  static late double height;
  static late double width;
  static late bool isTablet;
  static late bool isDesktop;
  static late bool isMobile;

  void init(BoxConstraints constraints, Orientation orientation) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    if (constraints.maxWidth < 450) {
      isMobile = true;
      isTablet = false;
      isDesktop = false;
      log("Responsive.isMobile : ${Responsive.isMobile}");
    } else if (constraints.maxWidth < 900 && constraints.maxWidth >= 450) {
      isTablet = true;
      isMobile = false;
      isDesktop = false;
      log("Responsive.isTablet : ${Responsive.isTablet}");
    } else if (constraints.maxWidth >= 900) {
      isDesktop = true;
      isMobile = false;
      isTablet = false;
      log("Responsive.isDesktop : ${Responsive.isDesktop}");
    }

    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    text = _blockSizeVertical;
    icon = _blockSizeHorizontal;
    height = _blockSizeVertical;
    width = _blockSizeHorizontal;
  }
}

class Sizer extends StatefulWidget {
  const Sizer({Key? key, required this.builder}) : super(key: key);
  final Widget builder;

  @override
  State<Sizer> createState() => _SizerState();
}

class _SizerState extends State<Sizer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        Responsive().init(constraints, orientation);
        return widget.builder;
      });
    });
  }
}

//region=====[ HEIGHT ]=====

double height_0_5 = Responsive.height * 0.5;
double height_1 = Responsive.height * 1;
double height_1_5 = Responsive.height * 1.5;
double height_2 = Responsive.height * 2;
double height_3 = Responsive.height * 3;
double height_4 = Responsive.height * 4;
double height_5 = Responsive.height * 5;
double height_6 = Responsive.height * 6;
double height_7 = Responsive.height * 7;
double height_8 = Responsive.height * 8;
double height_9 = Responsive.height * 9;
double height_10 = Responsive.height * 10;
double height_11 = Responsive.height * 11;
double height_12 = Responsive.height * 12;
double height_13 = Responsive.height * 13;
double height_14 = Responsive.height * 14;
double height_15 = Responsive.height * 15;
double height_16 = Responsive.height * 16;
double height_17 = Responsive.height * 17;
double height_18 = Responsive.height * 18;
double height_19 = Responsive.height * 19;
double height_20 = Responsive.height * 20;
double height_21 = Responsive.height * 21;
double height_22 = Responsive.height * 22;
double height_23 = Responsive.height * 23;
double height_24 = Responsive.height * 24;
double height_25 = Responsive.height * 25;
double height_26 = Responsive.height * 26;
double height_27 = Responsive.height * 27;
double height_28 = Responsive.height * 28;
double height_29 = Responsive.height * 29;
double height_30 = Responsive.height * 30;
double height_31 = Responsive.height * 31;
double height_32 = Responsive.height * 32;
double height_33 = Responsive.height * 33;
double height_34 = Responsive.height * 34;
double height_35 = Responsive.height * 35;
double height_36 = Responsive.height * 36;
double height_37 = Responsive.height * 37;
double height_38 = Responsive.height * 38;
double height_39 = Responsive.height * 39;
double height_40 = Responsive.height * 40;
double height_41 = Responsive.height * 41;
double height_42 = Responsive.height * 42;
double height_43 = Responsive.height * 43;
double height_44 = Responsive.height * 44;
double height_45 = Responsive.height * 45;
double height_46 = Responsive.height * 46;
double height_47 = Responsive.height * 47;
double height_48 = Responsive.height * 48;
double height_49 = Responsive.height * 49;
double height_50 = Responsive.height * 50;
double height_51 = Responsive.height * 51;
double height_52 = Responsive.height * 52;
double height_53 = Responsive.height * 53;
double height_54 = Responsive.height * 54;
double height_55 = Responsive.height * 55;
double height_56 = Responsive.height * 56;
double height_57 = Responsive.height * 57;
double height_58 = Responsive.height * 58;
double height_59 = Responsive.height * 59;
double height_60 = Responsive.height * 60;
double height_61 = Responsive.height * 61;
double height_62 = Responsive.height * 62;
double height_63 = Responsive.height * 63;
double height_64 = Responsive.height * 64;
double height_65 = Responsive.height * 65;
double height_66 = Responsive.height * 66;
double height_67 = Responsive.height * 67;
double height_68 = Responsive.height * 68;
double height_69 = Responsive.height * 69;
double height_70 = Responsive.height * 70;
double height_71 = Responsive.height * 71;
double height_72 = Responsive.height * 72;
double height_73 = Responsive.height * 73;
double height_74 = Responsive.height * 74;
double height_75 = Responsive.height * 75;
double height_76 = Responsive.height * 76;
double height_77 = Responsive.height * 77;
double height_78 = Responsive.height * 78;
double height_79 = Responsive.height * 79;
double height_80 = Responsive.height * 80;
double height_81 = Responsive.height * 81;
double height_82 = Responsive.height * 82;
double height_83 = Responsive.height * 83;
double height_84 = Responsive.height * 84;
double height_85 = Responsive.height * 85;
double height_86 = Responsive.height * 86;
double height_87 = Responsive.height * 87;
double height_88 = Responsive.height * 88;
double height_89 = Responsive.height * 89;
double height_90 = Responsive.height * 90;
double height_91 = Responsive.height * 91;
double height_92 = Responsive.height * 92;
double height_93 = Responsive.height * 93;
double height_94 = Responsive.height * 94;
double height_95 = Responsive.height * 95;
double height_96 = Responsive.height * 96;
double height_97 = Responsive.height * 97;
double height_98 = Responsive.height * 98;
double height_99 = Responsive.height * 99;
double height_100 = Responsive.height * 100;

//endregion

//region=====[ WIDTH ]=====

double width_0_5 = Responsive.width * 0.5;
double width_1_5 = Responsive.width * 1.5;
double width_1 = Responsive.width * 1;
double width_2 = Responsive.width * 2;
double width_3 = Responsive.width * 3;
double width_4 = Responsive.width * 4;
double width_4_8 = Responsive.width * 4.8;
double width_5 = Responsive.width * 5;
double width_6 = Responsive.width * 6;
double width_7 = Responsive.width * 7;
double width_8 = Responsive.width * 8;
double width_9 = Responsive.width * 9;
double width_10 = Responsive.width * 10;
double width_11 = Responsive.width * 11;
double width_12 = Responsive.width * 12;
double width_13 = Responsive.width * 13;
double width_14 = Responsive.width * 14;
double width_15 = Responsive.width * 15;
double width_16 = Responsive.width * 16;
double width_17 = Responsive.width * 17;
double width_18 = Responsive.width * 18;
double width_19 = Responsive.width * 19;
double width_20 = Responsive.width * 20;
double width_21 = Responsive.width * 21;
double width_22 = Responsive.width * 22;
double width_23 = Responsive.width * 23;
double width_24 = Responsive.width * 24;
double width_25 = Responsive.width * 25;
double width_26 = Responsive.width * 26;
double width_27 = Responsive.width * 27;
double width_28 = Responsive.width * 28;
double width_29 = Responsive.width * 29;
double width_30 = Responsive.width * 30;
double width_31 = Responsive.width * 31;
double width_32 = Responsive.width * 32;
double width_33 = Responsive.width * 33;
double width_34 = Responsive.width * 34;
double width_35 = Responsive.width * 35;
double width_36 = Responsive.width * 36;
double width_37 = Responsive.width * 37;
double width_38 = Responsive.width * 38;
double width_39 = Responsive.width * 39;
double width_40 = Responsive.width * 40;
double width_41 = Responsive.width * 41;
double width_42 = Responsive.width * 42;
double width_43 = Responsive.width * 43;
double width_44 = Responsive.width * 44;
double width_45 = Responsive.width * 45;
double width_46 = Responsive.width * 46;
double width_47 = Responsive.width * 47;
double width_48 = Responsive.width * 48;
double width_49 = Responsive.width * 49;
double width_50 = Responsive.width * 50;
double width_51 = Responsive.width * 51;
double width_52 = Responsive.width * 52;
double width_53 = Responsive.width * 53;
double width_54 = Responsive.width * 54;
double width_55 = Responsive.width * 55;
double width_56 = Responsive.width * 56;
double width_57 = Responsive.width * 57;
double width_58 = Responsive.width * 58;
double width_59 = Responsive.width * 59;
double width_60 = Responsive.width * 60;
double width_61 = Responsive.width * 61;
double width_62 = Responsive.width * 62;
double width_63 = Responsive.width * 63;
double width_64 = Responsive.width * 64;
double width_65 = Responsive.width * 65;
double width_66 = Responsive.width * 66;
double width_67 = Responsive.width * 67;
double width_68 = Responsive.width * 68;
double width_69 = Responsive.width * 69;
double width_70 = Responsive.width * 70;
double width_71 = Responsive.width * 71;
double width_72 = Responsive.width * 72;
double width_73 = Responsive.width * 73;
double width_74 = Responsive.width * 74;
double width_75 = Responsive.width * 75;
double width_76 = Responsive.width * 76;
double width_77 = Responsive.width * 77;
double width_78 = Responsive.width * 78;
double width_79 = Responsive.width * 79;
double width_80 = Responsive.width * 80;
double width_81 = Responsive.width * 81;
double width_82 = Responsive.width * 82;
double width_83 = Responsive.width * 83;
double width_84 = Responsive.width * 84;
double width_85 = Responsive.width * 85;
double width_86 = Responsive.width * 86;
double width_87 = Responsive.width * 87;
double width_88 = Responsive.width * 88;
double width_89 = Responsive.width * 89;
double width_90 = Responsive.width * 90;
double width_91 = Responsive.width * 91;
double width_92 = Responsive.width * 92;
double width_93 = Responsive.width * 93;
double width_94 = Responsive.width * 94;
double width_95 = Responsive.width * 95;
double width_96 = Responsive.width * 96;
double width_97 = Responsive.width * 97;
double width_98 = Responsive.width * 98;
double width_99 = Responsive.width * 99;
double width_100 = Responsive.width * 100;

//endregion

//region=====[ ELEVATION ]=====

const double elvation_1 = 1.0;
const double elvation_2 = 2.0;
const double elvation_3 = 3.0;
const double elvation_4 = 4.0;
const double elvation_5 = 5.0;
const double elvation_6 = 6.0;
const double elvation_7 = 7.0;
const double elvation_8 = 8.0;
const double elvation_9 = 9.0;
const double elvation_10 = 10.0;

//endregion

//region=====[ RADIUS ]=====

const double radius_0 = 0.0;
const double radius_1 = 1.0;
const double radius_2 = 2.0;
const double radius_3 = 3.0;
const double radius_4 = 4.0;
const double radius_5 = 5.0;
const double radius_6 = 6.0;
const double radius_7 = 7.0;
const double radius_8 = 8.0;
const double radius_9 = 9.0;
const double radius_10 = 10.0;
const double radius_12 = 12.0;
const double radius_14 = 14.0;
const double radius_17 = 17.0;
const double radius_20 = 20.0;
const double radius_22 = 22.0;
const double radius_25 = 25.0;
const double radius_28 = 28.0;
const double radius_15 = 15.0;
const double radius_30 = 30.0;
const double radius_50 = 50.0;
const double radius_45 = 45.0;
const double radius_80 = 80.0;
const double radius_90 = 90.0;

//endregion

//region=====[ FONTS ]=====

double font_5 = 5.0;
double font_10 = 10.0;
double font_12 = 12.0;
double font_13 = 13.0;
double font_14 = 14.0;
double font_15 = 15.0;
double font_17 = 17.0;
double font_16 = 16.0;
double font_18 = 18.0;
double font_20 = 20.0;
double font_22 = 22.0;
double font_23 = 23.0;
double font_25 = 25.0;
double font_24 = 24.0;
double font_28 = 28.0;
double font_30 = 30.0;
double font_33 = 33.0;
double font_35 = 35.0;
double font_40 = 35.0;
double font_45 = 45.0;
double font_50 = 50.0;