


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:developer' as dev show log;
void main(){

runApp(const TestPage2());
}
class TestPage2 extends StatefulWidget {
  const TestPage2({super.key});

  @override
  State<TestPage2> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage2> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();

  Future<Uint8List> imgCompress() async {
    try {
      // XFile data = XFile("assets/images/user_pic/default_user.png");
      ByteData data2 = await rootBundle.load("assets/images/user_pic/default_user.png");
      // Uint8List imageData = await data.readAsBytes();
      final imgData = await FlutterImageCompress.compressWithList(
        data2.buffer.asUint8List(),
        minHeight: 100,
        minWidth: 100,
        format: CompressFormat.png,
      );
      return imgData;
    } on CompressError catch (e) {
      dev.log(e.message);
      throw Exception();
    } catch (e) {
      dev.log(e.toString());
      throw Exception();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(),
          key: sKey,
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: imgCompress(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasError || !snapshot.hasData){
                    return  Center( child: Image.asset("assets/images/user_pic/default_user.png",color: Colors.red,),);
                  }else{
                    final data=  snapshot.data;
      
                    if(data == null){
                      return const Text('null');
                    }
                    return Center(child: Image.memory(data),);
                  }
                  }else{
                    return const Center(child: CircularProgressIndicator(),);
                  }
                },
              ))),
    );
  }
}