import 'dart:io';

import 'package:blog_app_clean_arch/core/theme/app_pallete.dart';
import 'package:blog_app_clean_arch/core/utils/image_pick.dart';
import 'package:blog_app_clean_arch/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  List<String> selectedTopics = [];

  File? imageFile;

  void selectImage() async {
    final pickedImageFile = await pickImage();
    if (pickedImageFile != null) {
      setState(() {
        imageFile = pickedImageFile;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              imageFile != null
                  ? GestureDetector(
                      onTap: () => selectImage(),
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      child: DottedBorder(
                          borderType: BorderType.RRect,
                          color: AppPallete.borderColor,
                          strokeCap: StrokeCap.round,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          child: const SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Select Your Image",
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          )),
                    ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    "Programming",
                    "Bussiness",
                    "Entertainment",
                    "Technology"
                  ]
                      .map(
                        (element) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              if (selectedTopics.contains(element)) {
                                selectedTopics.remove(element);
                              } else {
                                selectedTopics.add(element);
                              }
                              setState(() {});
                            },
                            child: Chip(
                              color: selectedTopics.contains(element)
                                  ? const WidgetStatePropertyAll(
                                      AppPallete.gradient1)
                                  : null,
                              label: Text(element),
                              side: selectedTopics.contains(element)
                                  ? null
                                  : const BorderSide(
                                      color: AppPallete.borderColor),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlogEditor(controller: titleController, hintText: "Blog Title"),
              const SizedBox(
                height: 15,
              ),
              BlogEditor(
                  controller: contentController, hintText: "Content Title"),
            ],
          ),
        ),
      ),
    );
  }
}
