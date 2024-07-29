int calculateReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;
  final time = wordCount / 220; // 220 is human reading speed per min
  return time.ceil();
}

// speed(220) = distance(wordcount) / time (x)