import 'package:get/get.dart';
import 'package:pfe_1/features/appointment/controller/appointment_controller.dart';
import 'package:pfe_1/features/centre/controller/center_controller.dart';
import 'package:pfe_1/utils/network/network.dart';

class GeneralBindings extends Bindings {

  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(() => AppointmentController());
    Get.lazyPut(()=>CenterController());
  }
}