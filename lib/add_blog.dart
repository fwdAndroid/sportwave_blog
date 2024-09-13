import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportwave_blog/blog_page.dart';
import 'package:sportwave_blog/utils/app_colors.dart';
import 'package:sportwave_blog/utils/app_style.dart';
import 'package:sportwave_blog/utils/buttons.dart';
import 'package:sportwave_blog/utils/input_text.dart';
import 'package:uuid/uuid.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Blog",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 9),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Blog Title*",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          InputText(
            controller: _nameController,
            labelText: "Title",
            onChanged: (value) {},
            onSaved: (val) {},
            textInputAction: TextInputAction.done,
            isPassword: false,
            enabled: true,
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          TextFormField(
            controller: _descriptionController,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (value) {},
            onSaved: (val) {},
            maxLines: 6,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                isDense: true,
                filled: true,
                hintText: "Description",
                fillColor: AppColors.background,
                // contentPadding: EdgeInsets.all(height * 0.015),
                focusedBorder: AppStyles.focusedBorder,
                disabledBorder: AppStyles.focusBorder,
                enabledBorder: AppStyles.focusBorder,
                errorBorder: AppStyles.focusErrorBorder,
                focusedErrorBorder: AppStyles.focusErrorBorder,
                errorStyle: errorTextStyle(context)),
            enabled: true,
          ),
          const SizedBox(height: 40),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SaveButton(
                  title: "Submit",
                  onTap: () async {
                    if (_nameController.text.isEmpty ||
                        _descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Name and Description are Required")));
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      var uuid = Uuid().v4();
                      await FirebaseFirestore.instance
                          .collection("blog")
                          .doc(uuid)
                          .set({
                        "uuid": uuid,
                        "title": _nameController.text,
                        "description": _descriptionController.text
                      });
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Blog Added Submitted Successfully are Required")));
                      Navigator.push(context,
                          MaterialPageRoute(builder: (builder) => BlogPage()));
                    }
                  })
        ],
      ),
    );
  }
}
