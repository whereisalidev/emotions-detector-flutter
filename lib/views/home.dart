import 'package:emotion_detection_new/reuseable/reuseable_container.dart';
import 'package:emotion_detection_new/views/camera_image_view.dart';
import 'package:emotion_detection_new/views/gallery_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: const Divider(thickness: 5,)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Emotion Detector', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, letterSpacing: 2),),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('What are you looking for?', style: TextStyle(color: Colors.grey.shade300, letterSpacing: 1)),
              ),
              const SizedBox(height: 30,),
              Center(
                child: ReuseableContainer(
                  txt: 'Choose image from gallery', gradient1: Colors.lightBlue.shade100,
                  gradient2: Colors.lightBlue.shade400, gradient3: Colors.blue,
                  icon: CupertinoIcons.photo,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const GalleryImageView();
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: ReuseableContainer(
                  txt: 'Open camera', gradient1: Colors.green.shade500,
                  gradient2: Colors.green.shade700, gradient3: Colors.green.shade800,
                  icon: Icons.document_scanner_outlined,
                  onTap: (){
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const CameraImageView();
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: const Divider(thickness: 5,)),

            ],
          ),
        ),
      ),
    );
  }
}
