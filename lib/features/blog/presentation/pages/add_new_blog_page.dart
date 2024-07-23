import 'dart:io';

import 'package:blog_app_clean_arch/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_clean_arch/core/common/widgets/loader.dart';
import 'package:blog_app_clean_arch/core/theme/app_pallete.dart';
import 'package:blog_app_clean_arch/core/utils/image_pick.dart';
import 'package:blog_app_clean_arch/core/utils/show_snackbar.dart';
import 'package:blog_app_clean_arch/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app_clean_arch/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app_clean_arch/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final formKey = GlobalKey<FormState>();

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

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        imageFile != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<BlogBloc>().add(
            BlogUploadEvent(
                posterId: posterId,
                title: titleController.text.trim(),
                imageUrl: imageFile!,
                content: contentController.text.trim(),
                topics: selectedTopics),
          );
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
          IconButton(
              onPressed: () => uploadBlog(),
              icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.message);
          }
          if (state is BlogSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
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
                    BlogEditor(
                        controller: titleController, hintText: "Blog Title"),
                    const SizedBox(
                      height: 15,
                    ),
                    BlogEditor(
                        controller: contentController,
                        hintText: "Blog Content"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
