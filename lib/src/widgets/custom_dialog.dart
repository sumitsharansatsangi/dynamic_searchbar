import 'package:flutter/material.dart';

class CustomDialogBuilder {
  CustomDialogBuilder(this.context, {this.dismissible});
  final BuildContext context;
  bool? dismissible;

  void showCustomDialog({
    Widget? titleText,
    BoxDecoration? footerDecoration,
    bool isWrapContent = false,
    required Widget content,
    Color? backgroundColor,
    List<Widget>? footer,
    Function? whenClosed,
    double? width,
    double? height,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: titleText == null
                ? const SizedBox()
                : Container(
                    width: 500,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(flex: 10, child: titleText),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => hideOpenDialog(context),
                              child: Icon(
                                Icons.close,
                                color: Theme.of(context).iconTheme.color,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            content: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isWrapContent ? content : Expanded(child: content),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: footer ?? [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((value) => whenClosed?.call());
  }

  void hideOpenDialog([BuildContext? innerContext]) {
    Navigator.pop(innerContext ?? context);
  }
}
