import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FullScreenImage extends StatefulWidget {
  const FullScreenImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('HD Wallpaper',
              style: TextStyle(
                  color: Colors.white, fontSize: 25, fontFamily: 'Pacifico')),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 50,
              right: 50,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: CupertinoButton(
                    color: Colors.black87,
                    onPressed: () {
                      setWallpaperHomeScreen();
                    },
                    child: Text(
                      'Apply',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Set Home Screen Method
  Future<void> setWallpaperHomeScreen() async {
    var location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);

    try {
      await WallpaperManager.setWallpaperFromFile(file.path, location);
    } on PlatformException {
      'Failed to get wallpaper.';
    }
  }

  //Set Lock Screen Method
  Future<void> setWallpaperLockScreen() async {
    var location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(widget.imageUrl);

    try {
      await WallpaperManager.setWallpaperFromFile(file.path, location);
    } on PlatformException {
      'Failed to get wallpaper.';
    }
  }

  setWallpaperOption() {
    return showModalBottomSheet(
        backgroundColor: Colors.black87,
        isDismissible: true,
        context: context,
        builder: (context) => Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black87, width: 2)),
              child: Column(
                children: [
                  //Set Home Screen Wallpaper
                  CupertinoButton(
                      child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: double.infinity,
                          color: Colors.black87,
                          child: Text(
                            'Set Home Screen',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      onPressed: () {
                        setWallpaperHomeScreen().then((value) =>
                            toastMessage('Home screen wallpaper applied!!'));
                        Navigator.pop(context);
                      }),
                  //Set Lock Screen Wallpaper
                  CupertinoButton(
                      child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: double.infinity,
                          color: Colors.black87,
                          child: Text(
                            'Set Lock Screen',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      onPressed: () {
                        setWallpaperLockScreen().then((value) =>
                            toastMessage('Lock screen wallpaper applied!!'));
                        Navigator.pop(context);
                      }),
                ],
              ),
            ));
  }

  toastMessage(
    String message,
  ) {
    return Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
