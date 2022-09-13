import 'package:flutter/material.dart';
import 'package:kronosss/Home/home_page.dart';

class DialogsUtils {
  final BuildContext context;
  final String? title;
  final String? textContent;
  final Widget? child;
  final String? assetsError;

  DialogsUtils(this.context,
      {this.title, this.textContent, this.child, this.assetsError});

// esto es para la decoracion del dialogo
  _decoration({Color? colorBG}) => BoxDecoration(
        color: colorBG ?? Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      );

// esto es para la decoracion del dialogo "la rayita blanca esa que representa que puede ser arrastrado"
  _widget1({bool right = false}) {
    final ss = MediaQuery.of(context).size.width * 0.2;
    //final Widget expand = SizedBox(height: 4, child: Spacer());
    final Widget expand = SizedBox(height: 4, width: ss - 70);
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          expand,
          Container(
            width: 40,
            height: 4.5,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(50))),
          ),
          if (right) expand,
        ],
      ),
    );
  }

// un dialogo simple para mensajes simples pero manteniendo el estilo de los demas
  showMessage({
    void Function()? onAccept,
    void Function()? onCancel,
    String? strCancel,
    String? strAccept,
    Color? colorAccept,
    double width = 100,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: _decoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              _widget1(right: true),
              SizedBox(height: 10),
              // title
              if (title != null)
                Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Text(
                      title!,
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              SizedBox(height: 10),
              // message
              if (textContent != null)
                Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        textContent!,
                        style: style,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              if (onCancel != null || onAccept != null) SizedBox(height: 15),
              if (onCancel != null || onAccept != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (strCancel != null)
                      GestureDetector(
                        onTap: onCancel ?? () => Navigator.of(context).pop(),
                        child: Container(
                          width: width,
                          height: 45,
                          decoration: deco14,
                          child: Center(
                            child: Text(
                              strCancel,
                              style: styleTitles,
                            ),
                          ),
                        ),
                      ),
                    if (strCancel != null) SizedBox(width: 20),
                    if (strAccept != null)
                      GestureDetector(
                        onTap: onAccept,
                        child: Container(
                          width: width,
                          height: 50,
                          padding: padding,
                          margin: margin,
                          decoration: deco14.copyWith(color: colorAccept),
                          child: Center(
                            child: Text(
                              strAccept,
                              style: styleTitles,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              SizedBox(height: 15),
            ],
          ),
        ),
      );

  //  un dialogo simple para mensajes de error pero manteniendo el estilo de los demas
  showMessageError({
    void Function()? onError,
    void Function()? onCancel,
    String? strCancel,
    String? strError,
    double width = 100,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: _decoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              _widget1(right: true),
              SizedBox(height: 10),
              // title
              if (title != null)
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(30)
                          .copyWith(top: 10, bottom: 10),
                      child: Text(
                        title!,
                        style: style15H.copyWith(
                          color: Color.fromARGB(255, 129, 9, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10),
              // message
              if (textContent != null)
                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0)
                          .copyWith(left: 20, right: 20),
                      child: Text(textContent!, style: style),
                    ),
                  ],
                ),
              if (onCancel != null || onError != null) SizedBox(height: 15),
              if (onCancel != null || onError != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (strCancel != null)
                      GestureDetector(
                        onTap: onCancel ?? () => Navigator.of(context).pop(),
                        child: Container(
                          width: width,
                          height: 50,
                          decoration: deco14,
                          child: Center(
                            child: Text(
                              strCancel,
                              style: styleTitles,
                            ),
                          ),
                        ),
                      ),
                    if (strCancel != null) SizedBox(width: 20),
                    if (strError != null)
                      GestureDetector(
                        onTap: onError,
                        child: Container(
                          width: width,
                          height: 50,
                          padding: padding,
                          margin: margin,
                          decoration: deco14.copyWith(
                              color: Color.fromARGB(255, 97, 6, 0)),
                          child: Center(
                            child: Text(
                              strError,
                              style: styleTitles,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              SizedBox(height: 15),
            ],
          ),
        ),
      );

  /* // un dialogo para listas de widgets pero manteniendo el estilo de los demas
  showDialogListWidget({
    required List<Widget> list,
    expand: false,
    double initialChildSize = 0.50,
    double minChildSize = 0.25,
    double maxChildSize = 1.0,
  }) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: _decoration(),
          child: Stack(
            children: [
              DraggableScrollableSheet(
                expand: false,
                initialChildSize: initialChildSize,
                minChildSize: minChildSize,
                maxChildSize: maxChildSize,
                builder: (context, scrollController) => SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      // title
                      if (title != null)
                        Text(
                          title!,
                          style: style.copyWith(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      SizedBox(height: 10),
                      // list
                      ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: list,
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: _widget1(),
                ),
              ),
            ],
          ),
        ),
      ); */

  // un dialogo para hijos de widgets pero manteniendo el estilo de los demas
  showDialogChildWidget({
    required Widget child,
    bool marginBotton = false,
  }) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: _decoration(),
          child: Stack(
            children: [
              // title
              if (title != null)
                Positioned(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(30),
                        child: Text(title!, style: style16H),
                      ),
                    ],
                  ),
                ),
              ListView(
                shrinkWrap: true,
                //mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 55),
                  // list
                  child,
                  if (marginBotton) SizedBox(height: 15),
                ],
              ),
              Positioned(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 4,
                      width: 40,
                      margin: EdgeInsets.only(top: 12.5, bottom: 10),
                      child: SizedBox(),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  // un dialogo para hijos de widgets pero manteniendo el estilo de los demas
  showDialogScrolletWidget({
    required Widget child,
    double minHeight = 0.25,
    double initialChildSize = 0.5,
    double maxHeight = 1.0,
    bool? enabledSize,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      /* shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ), */
      builder: (context) => enabledSize != null
          ? makeDismissible(
              child: DraggableScrollableSheet(
                initialChildSize: initialChildSize,
                maxChildSize: maxHeight,
                minChildSize: minHeight,
                builder: (_, c) => children(child, controller: c),
              ),
            )
          : children(child),
    );
  }

  Widget children(Widget child, {ScrollController? controller}) => Container(
        decoration: _decoration(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          controller: controller,
          shrinkWrap: true,
          children: [
            SizedBox(height: 10),
            _widget1(right: true),
            SizedBox(height: 10),
            // title
            if (title != null)
              Wrap(
                alignment: WrapAlignment.start,
                children: [
                  Text(
                    title!,
                    style: style16H,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            SizedBox(height: 10),
            // message
            if (textContent != null)
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      textContent!,
                      style: style,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            // children
            child,
            //SizedBox(height: 15),
          ],
        ),
      );

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(onTap: () {}, child: child),
      );

  /* // un dialogo para hijos de widgets pero manteniendo el estilo de los demas
  showDialogSimpleChildWidget({
    required Widget child,
    double minHeight = 0.0,
    double? maxHeight = double.infinity,
  }) {
    var maxHeightDefault =
        maxHeight == null ? MediaQuery.of(context).size.height : maxHeight;
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight,
          maxHeight: maxHeight ?? maxHeightDefault,
        ),
        child: Container(
          decoration: _decoration(),
          child: Stack(
            children: [
              SizedBox(height: 30),
              Scaffold(
                body: child,
                backgroundColor: Colors.black,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: _widget1(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } */

  /* // un dialogo para listas de categorias pero manteniendo el estilo de los demas
  showDialogListCategories(
    List<CategoriesModel> list, {
    expand: false,
    bool imageIsAssets = false,
    double initialChildSize = 0.50,
    double minChildSize = 0.25,
    double maxChildSize = 1.0,
    Function(CategoriesModel)? onSelectItem,
    Function(int)? onPosition,
    int indexSelected = -1,
    Color? colorSelected,
    double sizeIcon = 30,
    Widget? iconWidget,
  }) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: _decoration(),
          padding: const EdgeInsets.only(top: 5.0),
          child: DraggableScrollableSheet(
            expand: expand,
            initialChildSize: initialChildSize,
            minChildSize: minChildSize,
            maxChildSize: maxChildSize,
            builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  _widget1(),
                  SizedBox(height: 10),
                  // title
                  if (title != null) Text(title!),
                  SizedBox(height: 10),
                  // list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (_, index) {
                      return ItemCategories(list[index],
                          fit: BoxFit.contain,
                          color: indexSelected == index ? colorSelected : null,
                          sizeIcon: sizeIcon,
                          iconWidget: list[index].iconWidget,
                          /* Reemplaza al del modelo */
                          onPressed: () {
                        // para saber la categoria "model"
                        if (onSelectItem != null) onSelectItem(list[index]);
                        // para saber la posicion de la seleccion
                        if (onPosition != null) onPosition(index);
                      });
                    },
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ); */

/* //  un dialogo de "siempre" para mensajes que manteniene el estilo (es un copy & paste del que esta en Utils)
  dialogBottomGeneral({
    required BuildContext context,
    Widget? bottons,
    double? elevation = 4,
    bool isNotImage = false,
    bool isNotTitle = false,
    String message = '',
    String? title,
    Widget? iconTitle,
    Widget? content,
    String? replaceImageAssets,
    double sizeIconDefault = 50,
    Color colorTitle = Colors.white,
    Color colorTextContent = Colors.white,
    Color? colorBG,
    Color barrierColor = Colors.transparent,
    Function()? onpressed,
    bool dissmiss = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool paddingButtonAdd = true,
    double initialChildSize = 0.5,
    double minChildSize = 0.5,
    double maxChildSize = 1.0,
  }) {
    iconTitle = isNotImage ? SizedBox() : null;
    showModalBottomSheet(
        context: context,
        isDismissible: dissmiss,
        isScrollControlled: isScrollControlled,
        useRootNavigator: useRootNavigator,
        enableDrag: enableDrag,
        backgroundColor: Colors.transparent,
        barrierColor: (dissmiss && (barrierColor == Colors.transparent))
            ? barrierColor
            : Colors.black12,
        elevation: elevation,
        builder: (ctx) => Container(
              decoration: _decoration(colorBG: colorBG),
              child: DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: initialChildSize,
                  minChildSize: minChildSize,
                  maxChildSize: maxChildSize,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10),
                          _widget1(),
                          SizedBox(height: 10),
                          //image
                          iconTitle ??
                              Container(
                                  width: sizeIconDefault,
                                  height: sizeIconDefault,
                                  child: Image.asset(
                                    replaceImageAssets ?? IMAGE_LOGO,
                                    fit: BoxFit.contain,
                                  )),
                          // titulo
                          isNotTitle
                              ? SizedBox()
                              : Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    title?.toUpperCase() ?? APP_NAME,
                                    style: TextStyle(
                                        color: colorTitle,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                          SizedBox(height: 10),
                          //contenido
                          content ??
                              SizedBox(
                                height: 400,
                                child: Center(
                                  child: Text(
                                    message,
                                    style: style,
                                  ),
                                ),
                              ),
                          SizedBox(height: 10),
                          //boton
                          bottons ?? SizedBox(),
                        ],
                      ),
                    );
                  }),
            ));
  } */
}//.........
