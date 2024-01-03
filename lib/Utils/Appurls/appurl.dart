class AppUrl{
  static const String gKey                   = "AIzaSyDHRPXjG2JvJmgU2PedeuXeWRIkfNu6xRg";

  static const String baseUrl = 'http://52.66.145.37:3005';

  static const String register = '$baseUrl/driver/d_register';

  static const String login = '$baseUrl/driver/login';

  static const String tripHistory = '$baseUrl/driver/total';

  static const String addVehicles = '$baseUrl/driver/add_vehicle';

  static const String myVehiclesProfile = '$baseUrl/driver/get_vehicle';

  static const String driverProfile = '$baseUrl/driver/single_detail';


  static const String driverStarting = '$baseUrl/driver/master_trip';

  static const String driverStop = '$baseUrl/driver/stops';

  static const String master_Trip = '$baseUrl/driver/master_trip';

  static const String endTrip = '$baseUrl/driver/endstop';

  static const String checkIn = '$baseUrl/student/start';

  static const String checkOut = '$baseUrl/student/end';

  static const String driverTotal = '$baseUrl/driver/total';

  static const String editDriver = '$baseUrl/driver/edit_driver';

  static const String addingNewStopsBydriver = '$baseUrl/driver/add_stops';

  static const String getNewStop = '$baseUrl/driver/get_stops';

  static const String deleteTrip = '$baseUrl/driver/delete_stop';

  static const String addCordinates = '$baseUrl/driver/location';

  static const String singleDriver = '$baseUrl/driver/single_detail';

  static const String checkingNewUser = '$baseUrl/driver/find_vehicle';

  static const String editVehicle = '$baseUrl/driver/edit_vehicle';

  static const String getVehicleData = '$baseUrl/driver/vehicle_data';

  //google sign in
  static const String checkEmail = '$baseUrl/driver/google_signin';

}