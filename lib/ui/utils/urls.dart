
class urls{

  static const String _baseUrl = "http://35.73.30.144:2005/api/v1";
  static const String SignupUrl = "$_baseUrl/Registration";
  static const String LoginUrl = "$_baseUrl/Login";
  static const String AddNewTaskUrl = "$_baseUrl/createTask";
  static const String GetNewTasksUrl = "$_baseUrl/listTaskByStatus/New";
  static const String ProgressTasksUrl = "$_baseUrl/listTaskByStatus/Progress";
  static const String CancelledTasksUrl = "$_baseUrl/listTaskByStatus/Cancelled";
  static const String CompletedTasksUrl = "$_baseUrl/listTaskByStatus/Completed";
  static const String GetAllTasksUrl = "$_baseUrl/taskStatusCount";
  static String UpdateTaskStatusUrl(String taskid, String status) => "$_baseUrl/updateTaskStatus/$taskid/$status";
  static const String UpdateProfileUrl = '$_baseUrl/ProfileUpdate';
  static String RecoverVerifyEmailUrl(String email) => "$_baseUrl/RecoverVerifyEmail/$email";
  static String VeriftOtpdUrl(String email, String Otp) => "$_baseUrl/RecoverVerifyOtp/$email/$Otp";
  static const String ResetPasswordUrl = "$_baseUrl/RecoverResetPassword";
  static String DeleteTaskUrl(String taskId) => "$_baseUrl/deleteTask/$taskId";

}