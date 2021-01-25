import 'package:driver_app/AllScreens/mainscreen.dart';
import 'package:driver_app/configMaps.dart';
import 'package:driver_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarInfoScreen extends StatelessWidget {

  static const String idScreen = "carinfo";
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 22.0,),
              Image.asset("assets/images/logo.png",width: 390.0,height: 250.0,),
              Padding(padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0,),
                    Text("Enter Car details", style: TextStyle(fontFamily: "Brand-Bold", fontSize: 24.0),),
                    SizedBox(height: 26.0,),
                    TextField(
                      controller: carModelTextEditingController,
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                        labelText: "Car Model",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                      ),
                    ),
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: carNumberTextEditingController,
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                        labelText: "Car Number",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                      ),
                    ),
                    SizedBox(height: 10.0,),
                    TextField(
                      controller: carColorTextEditingController,
                      style: TextStyle(fontSize: 15.0),
                      decoration: InputDecoration(
                        labelText: "Car Color",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),

                      ),
                    ),
                    SizedBox(height: 42.0,),

                    Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: RaisedButton(
                      onPressed: (){

                        if(carModelTextEditingController.text.isEmpty){
                          Fluttertoast.showToast(msg: "please write Car model");
                        }else if(carNumberTextEditingController.text.isEmpty){
                          Fluttertoast.showToast(msg: "please write Car number");
                        }else if(carColorTextEditingController.text.isEmpty){
                          Fluttertoast.showToast(msg: "please write Car Color");
                        }else{
                          saveDriverCarInfo(context);
                        }


                      },
                      color: Theme.of(context).accentColor,
                      child: Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Next", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 26.0,),
                          ],
                        ),
                      ),
                    )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveDriverCarInfo(context){
    String userId = currentfirebaseUser.uid;

    Map carInfoMap ={
      "car_color" : carColorTextEditingController.text,
      "car_number" : carNumberTextEditingController.text,
      "car_model" : carModelTextEditingController.text,
    };

    driverRef.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
  }
}
