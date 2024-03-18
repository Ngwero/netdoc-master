import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../utilities/constants/font_constants.dart';


class blogPostWidget extends StatelessWidget {

  blogPostWidget ({required this.cardColor, required this.imageUrl,
    required this.blogPosts, required this.blogCategory,
    required this.blogTitle, required this.blogId, required this.link });

  final String blogCategory; final String blogTitle; final String blogPosts; final String imageUrl;
  final Color cardColor; final String blogId;
  final Uri link;


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        launchUrl(link);
      },
      child: Container(
        //width: double.infinity,

        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(top: 16, left:16, right: 16),
        decoration: BoxDecoration(
          color: cardColor, borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [


            Padding(padding: EdgeInsets.only(top:2),
              child:
              Row(
                children: [
                  Expanded(

                    flex:2,
                    child: Container(

                      //height: 100,
                      child:  ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 100,
                          width: 50,
                          child:
                          CachedNetworkImage(imageUrl: imageUrl,fit: BoxFit.cover)
                          //Image.network(imageUrl, fit: BoxFit.cover,),

                        ),
                      ),

                    ), ),
                  Expanded(

                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(blogPosts, style: kNormalTextStyleDark,),
                      ))
                ],
              ),
            ),
            Text("#$blogCategory" , style: kNormalTextStyle,),

          ],
        ),
      ),
    );
  }
}



