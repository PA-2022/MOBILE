class DateHelper {
  static String formatDate(String dateString) {
    String result = "";

    String date = dateString.split("T").first;
    result += date + " ";

    String time = dateString.split("T").last;
    time = time.split(".").first;
    time = time.split(":")[0] + ":" + time.split(":")[1];

    result += time;

    return result;
  }
}
