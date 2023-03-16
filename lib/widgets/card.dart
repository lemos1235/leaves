//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/16
//
import 'package:flutter/material.dart';

class ActionCardTitle extends StatelessWidget {
  ///标题显示文案：必填参数
  final String title;

  ///箭头左边的文字
  final String? accessoryText;

  ///标题点击
  final VoidCallback? onTap;

  ///标题右侧的小文字
  final String? subTitle;

  ///标题右侧的显示widget
  final Widget? subTitleWidget;

  ActionCardTitle({
    Key? key,
    required this.title,
    this.accessoryText,
    this.onTap,
    this.subTitle,
    this.subTitleWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (null == onTap) {
      return _rowWidget(context);
    }
    return GestureDetector(
      child: _rowWidget(context),
      onTap: onTap,
    );
  }

  Widget _rowWidget(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    var row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          //左侧信息
          child: _titleWidget(isDark),
        ),
        _accessoryTextWidget(isDark)
      ],
    );
    return Container(
      color: Theme.of(context).cardColor,
      child: row,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    );
  }

  Widget _titleWidget(bool isDark) {
    return Container(
      padding: EdgeInsets.only(right: 8),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 18,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _accessoryTextWidget(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: 84),
            child: Text(
              accessoryText ?? "",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                height: 1.2,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: isDark ? Colors.white : Color(0xFFCACACA),
          ),
        ],
      ),
    );
  }
}

class ShadowCard extends StatelessWidget {
  ///背景色 默认Color(0xfffafafa)
  final Color color;

  ///阴影颜色 默认Color(0xffeeeeee)
  final Color shadowColor;

  ///阴影偏移量 默认是0
  final Offset offset;

  ///内边距 默认是0
  final EdgeInsetsGeometry padding;

  ///圆角 默认4.0
  final double circular;

  ///子 Widget
  final Widget child;

  ///阴影模糊程度 默认5.0
  final double blurRadius;

  ///阴影扩散程度 默认0
  final double spreadRadius;

  ///边框的宽度 默认0.5
  final double borderWidth;

  ShadowCard(
      {required this.child,
      this.color = const Color(0xffffffff),
      this.shadowColor = const Color(0xffeeeeee),
      this.padding = const EdgeInsets.all(0),
      this.circular = 4.0,
      this.blurRadius = 5.0,
      this.spreadRadius = 0,
      this.offset = Offset.zero,
      this.borderWidth = 0.5});

  @override
  Widget build(BuildContext context) {
    double tempBorderWidth = 0;
    if (borderWidth > 0) {
      tempBorderWidth = borderWidth;
    }
    return Container(
      padding: padding,
      child: child,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(circular)),
          border: tempBorderWidth != 0
              ? Border.all(color: Theme.of(context).dividerColor, width: tempBorderWidth)
              : Border.all(style: BorderStyle.none),
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                offset: offset, //阴影xy轴偏移量
                blurRadius: blurRadius, //阴影模糊程度
                spreadRadius: spreadRadius //阴影扩散程度
                )
          ]),
    );
  }
}

class ListSection extends StatelessWidget {
  const ListSection({
    Key? key,
    required this.children,
    this.margin = const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
  }) : super(key: key);

  final List<Widget> children;

  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

class SingleListSection extends StatelessWidget {
  const SingleListSection({
    Key? key,
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
  }) : super(key: key);

  final Widget child;

  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(3.0)),
        child: child,
      ),
    );
  }
}
