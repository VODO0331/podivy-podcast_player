import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:podivy/service/auth/bloc/authBLOC.dart';
import 'package:podivy/service/auth/bloc/authEvent.dart';
import 'package:podivy/util/dialogs/logout_dialog.dart';
import 'package:podivy/widget/userAvatar.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            "images/drawer/vine1.png",
            width: 200.0.w,
            height: 200.0.h,
            fit: BoxFit.cover,
            color: const Color.fromARGB(255, 146, 146, 146),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Image.asset(
            "images/drawer/vine2.png",
            width: 150.0.w,
            height: 150.0.h,
            fit: BoxFit.cover,
            color: const Color.fromARGB(255, 146, 146, 146),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 60).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 90.h,
              ),
              const UserAvatar(
                  imgPath: "images/userPic/people1.png", radius: 27),
              SizedBox(
                height: 12.h,
              ),
              const Text('User Name',overflow: TextOverflow.ellipsis,),
              SizedBox(
                height: 12.h,
              ),
              Container(
                height: 0.6.h,
                width: 200.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25.h,
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  size: 25.w,
                ),
                title: Text("設定"),
                //onTap: () { },
              ),
              const Divider(
                height: 1,
                thickness: 2.0,
                color: Colors.white38,
              ),
              ListTile(
                leading: Icon(
                  Icons.account_box,
                  size: 25.w,
                ),
                title: Text("選項一"),
                //onTap: () { },
              ),
              const Divider(
                height: 1,
                thickness: 2.0,
                color: Colors.white38,
              ),
              ListTile(
                leading: Icon(
                  Icons.alarm,
                  size: 25.w,
                ),
                title: Text("選項2"),
                //onTap: () { },
              ),
              const Divider(
                height: 1,
                thickness: 2.0,
                color: Colors.white38,
              ),
              Expanded(
                child: Container(),
              ),
              Align(
                alignment: Alignment.center,
                child: ListTile(
                
                  leading: const Icon(Icons.logout, size: 35, color: Colors.red),
                  title: const Text(
                    "登出",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    final result = await showLogOutDialog(context);
                    if(result){
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                      
                    }
                  },
                ),
              ),
               Padding(
                padding:const EdgeInsets.only(right: 60,left: 10).w,
                child:const  Divider(
                  height: 1,
                  thickness: 2.0,
                  color: Colors.white10,
                ),
              ),
            ],
          ),
          
        ),
      ],
    ));
  }
}
