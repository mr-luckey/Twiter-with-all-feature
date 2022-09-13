// ignore: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kronosss/Common/image_network_widget.dart';

class ItemImageReel extends StatelessWidget {
  final String src;
  final bool isNetwork;
  final bool isExpand;
  final Size? resolution;
  const ItemImageReel(
    this.src, {
    Key? key,
    this.isNetwork = true,
    this.isExpand = false,
    this.resolution,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = TransformationController();
    return src.isEmpty
        ? SizedBox()
        : Stack(
            children: [
              InteractiveViewer(
                transformationController: _controller,
                minScale: 0.2,
                maxScale: 4.0,
                child: isNetwork
                    ? ImageNetworkWidgets(
                        src: src,
                        resolution: resolution,
                        boxfit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        sizeIconError: double.infinity,
                        isExpand: isExpand,
                      )
                    : Image.file(
                        File(src),
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
              ),
              // gradient
              /* InteractiveViewer(
                transformationController: _controller,
                minScale: 0.2,
                maxScale: 4.0,
                child: Container(
                  decoration:
                      BoxDecoration(gradient: Colorskronoss.gradient_semi),
                ),
              ), */
            ],
          );
  }
}
