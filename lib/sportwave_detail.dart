import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sportwave_blog/blog_page.dart';
import 'package:sportwave_blog/utils/app_colors.dart';
import 'package:sportwave_blog/utils/app_style.dart';
import 'package:sportwave_blog/utils/buttons.dart';
import 'package:sportwave_blog/utils/input_text.dart';

class SportwaveDetail extends StatefulWidget {
  final title;
  final description;
  var uuid;
  SportwaveDetail(
      {super.key,
      required this.description,
      required this.title,
      required this.uuid});

  @override
  State<SportwaveDetail> createState() => _SportwaveDetailState();
}

class _SportwaveDetailState extends State<SportwaveDetail> {
  TextEditingController _controller = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  bool _isLoading = false;
  void fetchData() async {
    // Fetch data from Firestore
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('blog')
        .doc(widget.uuid)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Update the controllers with the fetched data
    setState(() {
      _controller.text = data['title'];
      descriptionController.text = data['description'];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Blog Details",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Blog Title*",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ),
          InputText(
            controller: _controller,
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
            controller: descriptionController,
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
                  title: "Edit Blog",
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    await FirebaseFirestore.instance
                        .collection("blog")
                        .doc(widget.uuid)
                        .update({
                      "title": _controller.text,
                      "description": descriptionController.text
                    });
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Blog Updated Successfully")));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => BlogPage()));
                  }),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SaveButton(
                      title: "Delete",
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        await FirebaseFirestore.instance
                            .collection("blog")
                            .doc(widget.uuid)
                            .delete();
                        setState(() {
                          _isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Blog Delete Successfully")));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => BlogPage()));
                      }),
                )
        ],
      ),
    );
  }
}
