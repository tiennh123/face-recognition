import 'package:face_net_authentication/utils/constant.dart';
import 'package:flutter/material.dart';

class CameraHeader extends StatelessWidget {
  CameraHeader(this.title, this.step, {this.onBackPressed});
  final String title;
  final int step;
  final Function onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onBackPressed,
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  width: 50,
                  child: Center(child: Icon(Icons.arrow_back)),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 90,
              ),
            ],
          ),
          if (step == StepLiveness.stepHeadLeft)
            Text('Vui lòng xoay đầu qua trái', style: TextStyle(color: Colors.white, fontSize: 16),),
          if (step == StepLiveness.stepHeadRight)
            Text('Vui lòng xoay đầu qua phải', style: TextStyle(color: Colors.white, fontSize: 16),),
          if (step == StepLiveness.stepBlink)
            Text('Vui lòng chớp mắt', style: TextStyle(color: Colors.white, fontSize: 16),),
          if (step == StepLiveness.stepSmile)
            Text('Vui lòng cười', style: TextStyle(color: Colors.white, fontSize: 16),),
          if (step == StepLiveness.stepTakePicture)
            Text('Vui lòng chụp hình', style: TextStyle(color: Colors.white, fontSize: 16),),
        ],
      ),
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.black, Colors.transparent],
        ),
      ),
    );
  }
}
