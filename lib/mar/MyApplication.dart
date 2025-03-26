import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../api/UIHelper.dart';
import '../ui/binding/GetBinding.dart';
import '../utlis/language/Messages.dart';

class MyApplication extends StatefulWidget {
  const MyApplication({super.key});

  @override
  State<MyApplication> createState() => _MyApplicationState();
}

class _MyApplicationState extends State<MyApplication> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      footerTriggerDistance: 15,
      dragSpeedRatio: 0.91,
      headerBuilder: () => const MaterialClassicHeader(),
      footerBuilder: () => const ClassicFooter(),
      enableLoadingWhenNoData: false,
      enableRefreshVibrate: false,
      enableLoadMoreVibrate: false,
      shouldFooterFollowWhenNotFull: (state) {
        // If you want load more with noMoreData state ,may be you should return false
        return false;
      },
      child: ScreenUtilInit(
        designSize: const Size(750, 1334),
        builder: (BuildContext context, Widget? widget) {
          return GetMaterialApp(
            initialRoute: UIHelper.start,
            getPages: UIHelper.getPages,
            defaultTransition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 150),
            //全局Binding
            initialBinding: GetBinding(),
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            // 你的翻译
            translations: Messages(),
            // 将会按照此处指定的语言翻译
            locale: const Locale('zh_HK', 'HK'),
            // 添加一个回调语言选项，以备上面指定的语言翻译不存在
            fallbackLocale:const Locale('en', 'US'),
          );
        },
      ),
    );
  }
}
