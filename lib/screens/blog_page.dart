import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "dart:math";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../Utilities/constants/color_constants.dart';
import '../widgets/blog_post_widget.dart';


class BlogPage extends StatelessWidget {

  final _random = new Random();
  var backgroundColors = [kBackgroundGreyColor];
  var blogPosts = [];
  var images = [];
  var blogTitles = [];
  var sender = [];
  var date= [];
  var blogId = [];
  var link = [];
  Future<dynamic> getPosts() async {
    blogPosts = [];
    images = [];
    blogTitles = [];
    sender = [];
    date= [];
    blogId = [];

    link = [];


    final blenditBlogs = await FirebaseFirestore.instance
        .collection('blogs')
        .orderBy('time',descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        blogPosts.add(doc['blog']);
        blogTitles.add(doc['label']);
        sender.add(doc['sender']);
        images.add(doc['image']);
        date.add(doc['time']);
        blogId.add(doc['id']);
        link.add(doc['url']);
      });

    });
    return blenditBlogs ;
  }

  @override
  Widget build(BuildContext context) {
    return
      Stack(
            children:[
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('blogs').orderBy('time',descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    blogPosts = [];
                    images = [];
                    blogTitles = [];
                    sender = [];
                    date= [];
                    blogId = [];
                    link = [];
                    var blogs = snapshot.data!.docs;
                    for (var blog in blogs) {
                      sender.add(blog.get('sender'));
                      blogPosts.add(blog.get('blog'));
                      images.add(blog.get('image'));
                      blogId.add(blog.get('id'));
                      blogTitles.add(blog.get('label'));
                      date.add(blog.get('time').toDate());
                      link.add(blog.get('url'));

                    }
                  }
                  return ListView.builder(
                    // scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: sender.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        return
                          // Text(link[index]);

                          blogPostWidget(blogPosts: blogPosts[index],cardColor: backgroundColors[_random.nextInt(backgroundColors.length)]
                            , link: Uri.parse(link[index]) ,
                            blogCategory: sender[index],
                            blogTitle: blogTitles[index], imageUrl:images[index] ,
                            blogId: blogId[index],
                          );
                      });
                },
              ),
            ] );

  }
}

