import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/app.dart';
import 'package:gsy_github_app_flutter/env/config_wrapper.dart';
import 'package:gsy_github_app_flutter/env/env_config.dart';
import 'package:gsy_github_app_flutter/page/error_page.dart';
import 'package:logger/logger.dart';

import 'env/dev.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    // 不显示方法调用堆栈
    errorMethodCount: 0,
    // 错误时也不显示方法堆栈
    lineLength: 120,
    // 缩短边框长度
    colors: true,
    // 颜色
    printEmojis: false,
    // 禁用表情符号
    printTime: false,
    // 禁用时间戳
    excludeBox: {
      // 禁用所有级别的边框
      Level.trace: true,
      Level.debug: true,
      Level.info: true,
      Level.warning: true,
      Level.error: true,
      Level.fatal: true,
    },
  ),
);

void main() {
  logger.i('App Start 有没---------------');
  runZonedGuarded(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
      ///此处仅为展示，正规的实现方式参考 _defaultErrorWidgetBuilder 通过自定义 RenderErrorBox 实现
      return ErrorPage(
          details.exception.toString() + "\n " + details.stack.toString(), details);
    };
    runApp(ConfigWrapper(
      child: FlutterReduxApp(),
      config: EnvConfig.fromJson(config),
    ));
    ///屏幕刷新率和显示率不一致时的优化，必须挪动到 runApp 之后
    GestureBinding.instance.resamplingEnabled = true;
  }, (Object obj, StackTrace stack) {
    print(obj);
    print(stack);
  });
}
