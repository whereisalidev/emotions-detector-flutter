import 'package:flutter/material.dart';


class ReuseableContainer extends StatelessWidget {

  String txt;
  ReuseableContainer({
    super.key, required this.txt,
    required this.gradient1,
    required this.gradient2,
    required this.gradient3,
    required this.icon,
    required this.onTap
  });
  Color gradient1;
  Color gradient2;
  Color gradient3;
  IconData icon;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.2,
          width: MediaQuery.sizeOf(context).width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                colors: [
                  gradient2,
                  gradient2,
                  gradient3,
                ],
                begin: Alignment.topLeft,
                end: Alignment.center
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CircleAvatar(backgroundColor: Colors.black54,radius: 15, child: Icon(icon, size: 20,color: Colors.white,),),
              ),
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 8),
                child: Text(txt, style: const TextStyle(letterSpacing: 1, fontSize: 19),),
              ),
              const Align(
                  alignment: FractionalOffset.centerRight,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_forward ,size: 30,),
                  ))
            ],
          ),

        ),
      ),
    );
  }
}
