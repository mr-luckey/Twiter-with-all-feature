import 'package:flutter/material.dart';
import 'package:kronosss/Home/HallOfFame/comment_model.dart';
import 'package:kronosss/Home/home_page.dart';
import 'package:kronosss/Home/home_widget.dart';
import 'package:kronosss/mConstants.dart';
import 'package:kronosss/utils.dart';

class ItemComment extends StatelessWidget {
  final CommentModel model;
  final void Function(int) onPressed;
  final void Function()? onLongPressed;
  final void Function(int) onPressedRespond;
  final void Function()? onTapImage;
  final Color? selectedColor;
  final bool noLoading;
  ItemComment(this.model, this.onPressed, this.onPressedRespond,
      {this.noLoading = true,
      this.onLongPressed,
      this.onTapImage,
      this.selectedColor});

  Widget _loading() => Container(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(),
      );

  Widget item() {
    return Container(
      color: selectedColor,
      child: ListTile(
        //minVerticalPadding: 0,
        leading: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              child: circularImage2(model.imageUser, size: 40),
              onTap: onTapImage,
            ),
            SizedBox(height: 12),
          ],
        ),
        trailing: noLoading ? null : _loading(),
        onLongPress: onLongPressed,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            model.thread == null
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      onPressed(model.thread?.index ?? model.index);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7),
                          bottomRight: Radius.circular(7),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${model.thread?.userEmail ?? ""}',
                            style: style.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '   ${model.thread?.message ?? ""}',
                            style:
                                style.copyWith(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
            Text(model.userName.isNotEmpty ? model.userName : model.userEmail,
                style: style.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Wrap(
          children: [
            Column(
              children: [
                model.message.isEmpty
                    ? SizedBox()
                    : Text(
                        model.message,
                        style: style.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.white70),
                      ),
                model.file.isEmpty
                    ? SizedBox()
                    : cacheImageNetwork(model.file,
                        size: 100, radius: 10, assetError: NOT_IMAGE)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(Utils.epochToStringDate(model.epoch),
                    style: style.copyWith(
                        fontSize: 10,
                        color: Colors.white70,
                        decoration: TextDecoration.none,
                        fontStyle: FontStyle.normal))
                /* GestureDetector(
                  onTap: () {
                    onPressedRespond(model.index);
                  },
                  child: Text("responder",
                      style: style.copyWith(fontSize: 10, color: Colors.grey)),
                ), */
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return item();
    /* Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          // respond
          model.thread == null
              ? SizedBox()
              : Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      onPressed(model.thread?.index ?? model.index);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${model.thread?.user ?? ""}',
                          style: style.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '   ${model.thread?.message ?? ""}',
                          style: style.copyWith(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
          // comment
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            padding: EdgeInsets.all(5),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: Colors.white),
              borderRadius: model.thread == null
                  ? BorderRadius.circular(5)
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  model.user,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "   " + model.message,
                  style: style.copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          // button Respond
          Container(
            margin: EdgeInsets.only(right: 10, top: 5, bottom: 5),
            child: GestureDetector(
              onTap: () {
                onPressedRespond(model.index);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("responder",
                      style: style.copyWith(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    ) */
  }
}
