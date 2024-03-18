
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:netdoc/Utilities/constants/color_constants.dart';

import 'package:netdoc/utilities/constants/user_constants.dart';

import 'package:netdoc/widgets/show_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/constants/font_constants.dart';
import '../models/common_functions.dart';
import '../models/video_singleton.dart';
import '../onboarding_questions/quiz_page1.dart';


SingletonModalClass videoVariables = SingletonModalClass();

class VideoViewer extends StatefulWidget {
  // VideoViewer({this.appId = "a6293127425146ceb482077eccd3cd33", this.channelName = 'test', this.tempToken = '007eJxTYJg/weWYuffH6VozUjc3pmkvsJllscR5Wtq72yHVp5cJFH9UYLAwSEkyMUtONTO1NDUxTLO0MDEwMU1KMzZNtLQ0MjYwF8xMTW4IZGQwuTmZlZEBAkF8FoaS1OISBgYASJse4g=='});
  // final String appId;
  // final String channelName;
  // final String tempToken;

  static String id = 'agora_video';

  @override
  State<VideoViewer> createState() => _VideoViewerState();

  void terminateCall() {

  }
}

class _VideoViewerState extends State<VideoViewer> {


  @override
  void initState() {
    super.initState();

    initAgora();
  }
  var name = '';
  var opacity = true;
  String callId = "";



   AgoraClient client =
  AgoraClient(

      agoraConnectionData: AgoraConnectionData(
          appId: videoVariables.videoAppId,
          channelName: videoVariables.videoChannelName,
          username: "user",
          tempToken: videoVariables.videoTempToken


      ),
      agoraEventHandlers: AgoraRtcEventHandlers(

          userOffline: (number, reason) async{
            final prefs = await SharedPreferences.getInstance();
            String callId = prefs.getString(kCallKit)??"";
            CommonFunctions().executeRemoveCall();

            Get.snackbar('Video Call Ended', 'This video call has ended',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: kPureWhiteColor,
                icon: Icon(Icons.check_circle, color: kBlack,),
                isDismissible: false,
                onTap: (bar) {
                  print(bar.message);
                },
                snackbarStatus: (status) {


                }
            );
          },
      )
  );
      //
      //       // Navigator.push(context,
      //       //     MaterialPageRoute(builder: (context)=> QuizPage1())
      //       // );
      //
      //     },
      // )

      //     connectionLost: (){
      //       Get.snackbar("Connection Lost", "Connection to the server has been lost");
      //     }
      //
      //
      // )





  void initAgora() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(kFullNameConstant)!;
    await client.initialize();
    // print(videoVariables.videoAppId);
    // print(videoVariables.videoChannelName);
    print('ZUUZUZUZUZUZUUZ ${videoVariables.videoTempToken}');
    print('BUBUBBUBUBU ${videoVariables.videoChannelName}');
    print('SASAASASSASASA ${videoVariables.videoAppId}');

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenDarkColorOld,
        foregroundColor: kPureWhiteColor,
        title: Text('Doctors Appointment', style: kNormalTextStyle.copyWith(color: kPureWhiteColor),),),

      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              showNumberOfUsers: true,
              client: client,
              layoutType: Layout.floating,
              floatingLayoutContainerHeight: 400,
              floatingLayoutContainerWidth: 400,
              enableHostControls: true,
              disabledVideoWidget: Container(
                  color: kBlack,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: ClipOval(

                          child: Image.network('https://mcusercontent.com/f78a91485e657cda2c219f659/images/e80988fd-e61d-2234-2b7e-dced6e5f3a1a.jpg', height: 80,))),
                      kSmallHeightSpacing,
                      Text(name, style: kNormalTextStyle.copyWith(color: kPureWhiteColor, fontSize: 12),)
                    ],
                  )
                //Image.asset('images/logo.png', height: 100,))),
              ),),
            AgoraVideoButtons(
              enabledButtons: [
                BuiltInButtons.callEnd,
                BuiltInButtons.toggleMic,
                BuiltInButtons.toggleCamera,
                BuiltInButtons.switchCamera,


              ],

              onDisconnect: () {

                 print("LOOOOOOOOOOL DISCONNECTED SUCCESSFULLY");
              },
              // disableVideoButtonChild: ,
              // disconnectButtonChild: Container(height: 100, width: 150, color: Colors.red,),

              client: client,

              // onDisconnect: (){
              //  Navigator.pop(context);
              // },
            ),

            // Positioned(
            //   left: 10,
            //     bottom: 200,
            //     child: Text('Bad headache',style: kHeadingExtraLargeTextStyle.copyWith(color: kPureWhiteColor),))
          ],
        ),
      ),
    );
  }
}

