import 'dart:developer';

import 'package:dio/dio.dart';

class AuthService{
  Dio dio = Dio();
 Future authorization ()async{
  const String baseUrl = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBFiEDfEaaK6lBtIdxLXspmxGux1TGsCmg";
  try{
    Response response = await dio.post(baseUrl,data: {
      "email":"geethumahi38+2@gmail.com",
      "password":"Marlo@123",
      "returnSecureToken":true
    });

    if(response.statusCode == 200 || response.statusCode == 201){
      log(response.data.toString());
    }
  } on DioException catch(e){
    log(e.message.toString());
  }
 }

 
}