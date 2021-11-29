import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../base_flutter.dart';

class ShowImagePage extends StatelessWidget {
  final List<String> galleryItems;
  final int position;

  ShowImagePage(this.galleryItems, {this.position = 0});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: position);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
              child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              var image = galleryItems[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: getImageProvider(image),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: galleryItems[index]),
              );
            },
            itemCount: galleryItems.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded /
                          (event.expectedTotalBytes ?? 1),
                ),
              ),
            ),
            pageController: controller,
          )),
          SafeArea(child: IconButton(
            splashColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: 30,
                color: Colors.white,
              ))).setLocation(right: 0, top: 0)
        ],
      ),
    );
  }


}

ImageProvider getImageProvider(String image) {
  if (image.contains('http')) {
    return CachedNetworkImageProvider(image);
  } else if (image.startsWith('assets') || image.startsWith('images')) {
    return AssetImage(image);
  } else {
    return FileImage(File(image));
  }
}

showBigImage(BuildContext context, List<String> images, {int position = 0}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ShowImagePage(
      images,
      position: position,
    );
  }));
}
