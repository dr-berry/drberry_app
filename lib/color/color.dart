import 'dart:ui';

class CustomColors {
  static const lightPurple = Color(0xFFEFE6FE);
  static const lightGreen = Color(0xFFEAF8E0);
  static const lightBlue = Color(0xFFEDF5FB);
  static const lightPurple2 = Color(0xFFC1BBF0);
  static const middlePurple = Color(0xFF835EEE);
  static const lightGreen2 = Color(0xFF39C270);
  static const middleGreen = Color(0xFF379A41);
  static const middleBlue = Color(0xFF016EED);
  static const redorangeRed = Color(0xFFFF4319);
  static const deepIndigo = Color(0xFF0F0C5A);
  static const systemGrey2 = Color(0xFFAEAEB2);
  static const systemGrey3 = Color(0xFFC7C7CC);
  static const systemGrey4 = Color(0xFFD1D1D6);
  static const systemGrey5 = Color(0xFFE5E5EA);
  static const systemGrey6 = Color(0xFFF2F2F7);
  static const systemGrey7 = Color(0xFFF9F9F9);
  static const systemWhite = Color(0xFFFFFFFF);
  static const systemBlack = Color(0xFF000000);
  static const secondaryBlack = Color(0xFF111111);
  static const blue = Color(0xFF016EED);
  static const purple = Color(0xFF835EEE);
  static const yellow = Color(0xFFFFBB0D);
  static const red = Color(0xFFFF5C37);

  static Color hexaColor(String strcolor, double d, {int opacity = 15}) {
    strcolor = strcolor.replaceAll("#", "");
    String stropacity = opacity.toRadixString(16);
    return Color(int.parse("$stropacity$stropacity$strcolor", radix: 16));
  }

  static Color getNeon(String color) {
    Color neon;

    switch (color) {
      case 'GREEN':
        neon = const Color.fromRGBO(55, 154, 65, 0.32);
        break;
      case 'BLUE':
        neon = const Color.fromRGBO(1, 110, 237, 0.32);
        break;
      case 'YELLOW':
        neon = const Color.fromRGBO(255, 199, 0, 0.32);
        break;
      case 'PURPLE':
        neon = const Color.fromRGBO(131, 94, 238, 0.32);
        break;
      case 'RED':
        neon = const Color.fromRGBO(255, 67, 25, 0.32);
        break;
      default:
        neon = const Color.fromRGBO(255, 67, 25, 0.32);
        break;
    }

    return neon;
  }

  static List<Color> gradient(String gradient) {
    List<Color> gr = [];

    switch (gradient) {
      case 'GREEN':
        gr = [
          const Color(0xFF39C270),
          const Color(0xFF89DAA9),
          const Color(0xFF94e8b5),
        ];
        break;
      case 'BLUE':
        gr = [
          const Color(0xFF016eed),
          const Color(0xFFB2D5FD),
        ];
        break;
      case 'PURPLE':
        gr = [const Color(0xFF835EEE), const Color(0xFFD1C2FE)];
        break;
      case 'YELLOW':
        gr = [
          const Color(0xFFFFBB0D),
          const Color(0xFFFFF1A9),
        ];
        break;
      case 'RED':
        gr = [const Color(0xFFFF5C37), const Color(0xFFFFE4DE)];
        break;
      case 'GREY':
        gr = [const Color(0xFFD9D9D9), const Color(0xFFf5f5f5)];
        break;
      default:
        gr = [
          const Color(0xFF39C270),
          const Color(0xFF89DAA9),
          const Color(0xFF94e8b5),
        ];
        break;
    }

    return gr;
  }
}
