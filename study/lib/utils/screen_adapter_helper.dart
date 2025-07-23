import 'package:flutter/cupertino.dart';
/// 扩展int使用
/// 
extension IntFix on int {
    ///eg: 200.px
    double get px {
        return ScreenHelper.getPx(toDouble());
    }
}

///扩展double以方便使用
extension DoubleFix on double {
    ///eg: 200.0.px
    double get px {
        return ScreenHelper.getPx(this);
    }
}


///屏幕适配工具类，如果UI要求要和UI稿完全一致的还原度时可以使用
class ScreenHelper {
  static late MediaQueryData _mediaQueryData;
  static late double screenWith;
  static late double screenHeight;
  static late double ratio;

  ///根据设计稿实际宽度初始化
  ///baseWidth 设计稿宽度
  static init(BuildContext context, {double baseWidth = 375}) {
    _mediaQueryData = MediaQuery.of(context);
    screenWith = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    ratio = screenWith / baseWidth;
  }

  ///获取设计稿对应的大小
  static double getPx(double size) {
    return ScreenHelper.ratio * size;
  }
}
