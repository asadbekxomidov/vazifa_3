import 'package:get/get.dart';

class GameController extends GetxController {
  var questionIndex = 0.obs;
  var score = 0.obs;
  var diamonds = 50.obs;
  var currentQuestion = "Тиши бар бирок тиштебейт.".obs;

  void nextQuestion() {
    questionIndex++;
  }

  void useHint() {}

  void buyDiamonds() {}
}
