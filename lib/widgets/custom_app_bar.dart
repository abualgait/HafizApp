import 'package:flutter/material.dart';
import 'package:hafiz_app/core/app_export.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.height,
    this.leadingWidth,
    this.leading,
    this.title,
    this.centerTitle,
    this.actions,
    this.backgroundColor,
  });

  final double? height;

  final double? leadingWidth;

  final Widget? leading;

  final Widget? title;

  final bool? centerTitle;

  final List<Widget>? actions;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: height ?? 60.v,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor ?? Colors.transparent,
        leadingWidth: leadingWidth ?? 0,
        leading: leading,
        title: const SizedBox.shrink(),
        titleSpacing: 0,
        centerTitle: centerTitle ?? false,
        actions: actions,
      ),
      title ?? const SizedBox.shrink()
    ]);
  }

  @override
  Size get preferredSize => Size(
        mediaQueryData.size.width,
        height ?? 56.v,
      );
}
