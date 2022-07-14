import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:learnplay/bloc/login_bloc/login_bloc.dart';
import 'package:learnplay/bloc/login_bloc/login_bloc_state.dart';
import 'package:learnplay/components/basic_widgets.dart';
import 'package:learnplay/components/main_appbar.dart';
import 'package:learnplay/controller/loading_controller.dart';
import 'package:learnplay/modules/dashboard/pages/index.dart';
import 'package:learnplay/modules/dashboard/pages/notifications.dart';
import 'package:learnplay/modules/dashboard/pages/profile.dart';
import 'package:learnplay/modules/dashboard/widgets/load_content.dart';
import 'package:learnplay/modules/dashboard/widgets/main_menu.dart';
import 'package:learnplay/modules/dashboard/widgets/top_button.dart';
import 'package:learnplay/routes.dart';
import 'package:learnplay/types/user.dart';

import '../../../bloc/login_bloc/login_bloc_event.dart';
import '../../../config.dart';
import '../../../services/storage/storage.dart';
import '../../../services/user/user_service.dart';
import '../../core/auth_controller.dart';

class DashboardBar extends StatefulWidget {
  final Widget child;

  DashboardBar({Key? key, required this.child}) : super(key: key);

  @override
  State<DashboardBar> createState() => _DashboardBarState();
}

class _DashboardBarState extends State<DashboardBar> {
  ScrollController _scrollController = ScrollController();
  bool _activateTopButton = false;

  @override
  void initState() {
    super.initState();
    AuthController.userCheck(context);
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_scrollController.offset >= 50) {
      _activateTopButton = true;
    } else {
      _activateTopButton = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state.user != null) {
        return Stack(
          children: [
            Scaffold(
                backgroundColor: MainTheme.primary,
                floatingActionButton: (!_activateTopButton)
                    ? null
                    : TopButton(scrollController: _scrollController),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: MainTheme.secondary,
                  titleSpacing: 0,
                  title: Row(
                    children: [
                      IconButton(
                          onPressed: () => Get.off(() => DashboardIndex()),
                          icon: Icon(Icons.home, color: MainTheme.white)),
                      SizedBox(width: 15),
                      Text(title, style: TextStyle(color: MainTheme.accent)),
                    ],
                  ),
                  actions: [
                    ..._spacing(_buildNotificationCenter()),
                    _buildProfilePicture(),
                    SizedBox(width: 15)
                  ],
                ),
                body: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      MainMenu(),
                      widget.child,
                    ],
                  ),
                )),
            LoadContent()
          ],
        );
      }

      return MainBar(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitDoubleBounce(
                color: Colors.white,
                size: 50.0,
              ),
              SizedBox(height: 18),
              _buildAnimatedLoading(),
            ],
          ),
        ),
      );
    });
  }

  _buildAnimatedLoading() {
    return AnimatedTextKit(
      animatedTexts: [
        WavyAnimatedText(
          "Carregando",
          textStyle: TextStyle(fontSize: 20),
        ),
      ],
      isRepeatingAnimation: true,
    );
  }

  _spacing(Widget widget) {
    return [widget, SizedBox(width: 15)];
  }

  _buildNotificationCenter() {
    return IconButton(
        onPressed: () => Get.off(() => DashboardNotifications()),
        icon: Icon(Icons.notifications_none, color: MainTheme.white, size: 28));
  }

  _buildProfilePicture() {
    return SizedBox(
      width: 30,
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return ElevatedButton(
          onPressed: () => Get.off(() => DashboardProfile()),
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Colors.transparent,
              padding: EdgeInsets.zero,
              shadowColor: Colors.transparent),
          child: ProfilePicture(
            name: "${state.user?.name ?? ''}",
            radius: 31,
            img:
                "${UserService.getProfilePicture(uuid: state.profilePhoto ?? 'assets/default-avatar.jpg')}",
            fontsize: 15,
          ),
        );
      }),
    );
  }
}
