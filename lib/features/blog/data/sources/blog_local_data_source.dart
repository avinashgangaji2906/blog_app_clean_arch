import 'package:blog_app_clean_arch/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);
  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromJson(box.get(i
            .toString()))); // fetching data in Json and converting it to BlogModel
      }
    });
    print("Blogs from local Storage");
    return blogs;
  }

  @override
  void uploadBlogs({required List<BlogModel> blogs}) {
    box.clear();
    // prefer to use write function when storing large data to hive
    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(
            i.toString(), blogs[i].toJson()); // storing the data in Json Format
      }
    });
  }
}
