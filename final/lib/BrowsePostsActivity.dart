import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 导入 FirebaseAuth
import 'PostDetailActivity.dart'; // 导入新的详情页面
import 'NewPostActivity.dart';
import 'auth_gate.dart';

class BrowsePostsActivity extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to handle user logout
  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AuthGate()),
      );
    } catch (e) {
      print('Error signing out: $e');
      // Optionally show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse Posts'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOut(context), // Log out when clicked
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index].data() as Map<String, dynamic>;
              final postId = posts[index].id;
              final title = post['title'];
              final price = post['price'];
              final description = post['description'];
              final images = post['images'] ?? []; // 确保images为列表
              final firstImage = images.isNotEmpty ? images[0] : null; // 获取第一张图片

              return ListTile(
                title: Text(title),
                subtitle: Text('Price: \$${price}\nDescription: $description'),
                leading: firstImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    firstImage,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes !=
                                null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ??
                                    1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, color: Colors.red);
                    },
                  ),
                )
                    : null, // 如果没有图片，则不显示
                onTap: () {
                  // 点击后跳转到详情页面，传递帖子 ID 和其他详细信息
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailActivity(postId: postId),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await _firestore.collection('posts').doc(postId).delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Post deleted')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostActivity()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
