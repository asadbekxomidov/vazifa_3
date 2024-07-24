import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final RxInt score = 0.obs;
  final RxInt level = 1.obs;
  final RxInt gems = 50.obs;

  final List<Map<String, String>> questions = [
    {
      'question': 'Uzbekistondagi 31 dekabrda qanday bayram bo\'ladi?',
      'answer': 'YANGIYIL'
    },
    {'question': 'O\'zbekistonning poytaxti qayerda?', 'answer': 'TASHKENT'},
    {'question': 'Dunyoning eng katta okeani qaysi?', 'answer': 'TINCH'},
    {'question': 'Eng uzun daryo qaysi?', 'answer': 'NIL'},
    {'question': 'Osiyodagi eng katta davlat qaysi?', 'answer': 'RUSSIYA'},
    {'question': 'Dunyodagi eng baland tog\' qaysi?', 'answer': 'EVEREST'},
    {'question': 'Eng ko\'p aholiga ega davlat qaysi?', 'answer': 'XITOY'},
    {'question': 'Braziliyaning poytaxti qaysi?', 'answer': 'BRAZILIYA'},
    {
      'question': 'Afrikadagi eng katta cho\'l qaysi?',
      'answer': 'SAHROI KABIR'
    },
    {'question': 'Avstraliyaning poytaxti qaysi?', 'answer': 'KANBERRA'},
    {'question': 'Dunyoning eng kichik davlati qaysi?', 'answer': 'VATIKAN'},
    {'question': 'Yerning sun\'iy yo\'ldoshi nima?', 'answer': 'OY'},
    {'question': 'Fransiyaning poytaxti qaysi?', 'answer': 'PARIJ'},
    {'question': 'Ispaniyaning poytaxti qaysi?', 'answer': 'MADRID'},
    {'question': 'Germaniyaning poytaxti qaysi?', 'answer': 'BERLIN'},
    {'question': 'Italiyaning poytaxti qaysi?', 'answer': 'RIM'},
    {'question': 'Hindistonning poytaxti qaysi?', 'answer': 'DEHLI'},
    {'question': 'Misrning poytaxti qaysi?', 'answer': 'QOHIRA'},
    {'question': 'Dunyodagi eng chuqur ko\'l qaysi?', 'answer': 'BAYKAL'},
    {'question': 'Almaniyaning eng yirik shahri qaysi?', 'answer': 'BERLIN'}
  ];

  int currentQuestionIndex = 0;
  late String correctAnswer;
  final RxString question = ''.obs;
  final RxString maskedAnswer = ''.obs;

  final List<String> letters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];

  List<String> availableLetters = List.from([
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ]);

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _loadQuestion(currentQuestionIndex);

    super.initState();
  }

  void _loadQuestion(int index) {
    if (index < questions.length) {
      question.value = questions[index]['question']!;
      correctAnswer = questions[index]['answer']!;
      _initializeMaskedAnswer();
      availableLetters = List.from(letters);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Oyun tugadi'),
          content: Text('Siz barcha savollarni tugatdingiz!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _initializeMaskedAnswer() {
    String initialMaskedAnswer =
        correctAnswer.replaceAll(RegExp(r'[A-Z]'), '*');
    maskedAnswer.value = initialMaskedAnswer;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

// #############################################################
  void _handleHelp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yordam kerakmi?'),
          content: Text(
              'Harf ochish uchun variantlarni tanlang: 1. Birinchi harfni ochish (8 olmos) 2. Tasodifiy harfni ochish (6 olmos). Davom etish kerakmi?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Bekor qilish'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (gems.value >= 8) {
                  gems.value -= 8;
                  _revealFirstLetter();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Olmos yetarli emas!')));
                }
              },
              child: Text('Birinchi harfni ochish (8 olmos)'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (gems.value >= 6) {
                  gems.value -= 6;
                  _revealRandomLetter();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Olmos yetarli emas!')));
                }
              },
              child: Text('Tasodifiy harfni ochish (6 olmos)'),
            ),
          ],
        );
      },
    );
  }

  void _revealFirstLetter() {
    if (maskedAnswer.value.contains('*')) {
      _handleButtonClick(correctAnswer[0]);
    }
  }
// #############################################################

  void _handleButtonClick(String letter) {
    setState(() {
      availableLetters.remove(letter);
    });

    String newMaskedAnswer = '';
    bool correctGuess = false;

    for (int i = 0; i < correctAnswer.length; i++) {
      if (correctAnswer[i] == letter) {
        newMaskedAnswer += letter;
        correctGuess = true;
      } else {
        newMaskedAnswer += maskedAnswer.value[i];
      }
    }

    maskedAnswer.value = newMaskedAnswer;

    if (maskedAnswer.value == correctAnswer) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Tabriklaymiz!'),
          content: Text('Siz yutdingiz!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                score.value += 10;
                level.value += 1;
                if (level.value % 5 == 0) {
                  gems.value += 100;
                }
                _moveToNextQuestion();
              },
              child: Text('OK'),
            ),
          ],
        ),
      ).then((_) {
        setState(() {
          availableLetters = List.from(letters);
        });
      });
    } else if (correctGuess) {
      score.value += 5;
    }
  }

  void _moveToNextQuestion() {
    currentQuestionIndex++;
    _loadQuestion(currentQuestionIndex);
  }

  void _resetGame() {
    currentQuestionIndex = 0;
    availableLetters = List.from(letters);
    _loadQuestion(currentQuestionIndex);
  }

  void _handleHelpp() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Yordam kerakmi?'),
            content: Text(
                'Harf ochish uchun 20 olmos kerak bo\'ladi. Davom etish kerakmi?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Bekor qilish'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (gems.value >= 20) {
                    gems.value -= 20;
                    _revealRandomLetter();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Olmos yetarli emas!')));
                  }
                },
                child: Text('Ha'),
              ),
            ],
          );
        });
  }

  void _revealRandomLetter() {
    for (int i = 0; i < correctAnswer.length; i++) {
      if (maskedAnswer.value[i] == '*') {
        _handleButtonClick(correctAnswer[i]);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 45,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue.shade500,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: ScoreGemsWidget(
                            icon: Icons.star,
                            value: score,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _controller.value * 6.3,
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue.shade500,
                                  width: 3.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Obx(() => Text(
                                level.toString(),
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 45,
                        width: 125,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue.shade500,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ScoreGemsWidget(value: gems, icon: Icons.diamond),
                            IconButton(
                              icon: Icon(Icons.help, color: Colors.white),
                              onPressed: _handleHelp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 200),
            Obx(() => Text(
                  question.value,
                  style: GoogleFonts.daiBannaSil(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                )),
            SizedBox(height: 180),
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(maskedAnswer.value.length, (index) {
                      return Container(
                        height: 35,
                        width: 35,
                        margin: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            maskedAnswer.value[index],
                            style: GoogleFonts.daiBannaSil(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                )),
            SizedBox(height: 60),
            Expanded(
              child: GridView.count(
                childAspectRatio: 1 / 1.6,
                crossAxisCount: 13,
                padding: const EdgeInsets.all(5.0),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                children: List.generate(availableLetters.length, (index) {
                  final letter = availableLetters[index];
                  return GestureDetector(
                    onTap: () => _handleButtonClick(letter),
                    child: Container(
                      height: 40,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: GoogleFonts.daiBannaSil(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreGemsWidget extends StatelessWidget {
  final IconData icon;
  final RxInt value;

  ScoreGemsWidget({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Obx(() => Text(
                value.value.toString(),
                style: GoogleFonts.daiBannaSil(
                  fontSize: 18,
                ),
              )),
          SizedBox(width: 4),
          Icon(
            icon,
            size: 24,
            color: Colors.amber.shade900,
          ),
        ],
      ),
    );
  }
}

















// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   final RxInt score = 0.obs;
//   final RxInt level = 1.obs;
//   final RxInt gems = 50.obs;

//   final List<Map<String, String>> questions = [
//     {
//       'question': 'Uzbekistondagi 31 dekabrda qanday bayram bo\'ladi?',
//       'answer': 'YANGIYIL'
//     },
//     {'question': 'O\'zbekistonning poytaxti qayerda?', 'answer': 'TASHKENT'},
//     {'question': 'Dunyoning eng katta okeani qaysi?', 'answer': 'TINCH'},
//     {'question': 'Eng uzun daryo qaysi?', 'answer': 'NIL'},
//     {'question': 'Osiyodagi eng katta davlat qaysi?', 'answer': 'RUSSIYA'},
//     {'question': 'Dunyodagi eng baland tog\' qaysi?', 'answer': 'EVEREST'},
//     {'question': 'Eng ko\'p aholiga ega davlat qaysi?', 'answer': 'XITOY'},
//     {'question': 'Braziliyaning poytaxti qaysi?', 'answer': 'BRAZILIYA'},
//     {
//       'question': 'Afrikadagi eng katta cho\'l qaysi?',
//       'answer': 'SAHROI KABIR'
//     },
//     {'question': 'Avstraliyaning poytaxti qaysi?', 'answer': 'KANBERRA'},
//     {'question': 'Dunyoning eng kichik davlati qaysi?', 'answer': 'VATIKAN'},
//     {'question': 'Yerning sun\'iy yo\'ldoshi nima?', 'answer': 'OY'},
//     {'question': 'Fransiyaning poytaxti qaysi?', 'answer': 'PARIJ'},
//     {'question': 'Ispaniyaning poytaxti qaysi?', 'answer': 'MADRID'},
//     {'question': 'Germaniyaning poytaxti qaysi?', 'answer': 'BERLIN'},
//     {'question': 'Italiyaning poytaxti qaysi?', 'answer': 'RIM'},
//     {'question': 'Hindistonning poytaxti qaysi?', 'answer': 'DEHLI'},
//     {'question': 'Misrning poytaxti qaysi?', 'answer': 'QOHIRA'},
//     {'question': 'Dunyodagi eng chuqur ko\'l qaysi?', 'answer': 'BAYKAL'},
//     {'question': 'Almaniyaning eng yirik shahri qaysi?', 'answer': 'BERLIN'}
//   ];

//   int currentQuestionIndex = 0;
//   late String correctAnswer;
//   final RxString question = ''.obs;
//   final RxString maskedAnswer = ''.obs;

//   final List<String> letters = [
//     'A',
//     'B',
//     'C',
//     'D',
//     'E',
//     'F',
//     'G',
//     'H',
//     'I',
//     'J',
//     'K',
//     'L',
//     'M',
//     'N',
//     'O',
//     'P',
//     'Q',
//     'R',
//     'S',
//     'T',
//     'U',
//     'V',
//     'W',
//     'X',
//     'Y',
//     'Z'
//   ];

//   List<String> availableLetters = List.from([
//     'A',
//     'B',
//     'C',
//     'D',
//     'E',
//     'F',
//     'G',
//     'H',
//     'I',
//     'J',
//     'K',
//     'L',
//     'M',
//     'N',
//     'O',
//     'P',
//     'Q',
//     'R',
//     'S',
//     'T',
//     'U',
//     'V',
//     'W',
//     'X',
//     'Y',
//     'Z'
//   ]);

//   late AnimationController _controller;

//   @override
//   void initState() {
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();

//     _loadQuestion(currentQuestionIndex);

//     super.initState();
//   }

//   void _loadQuestion(int index) {
//     if (index < questions.length) {
//       question.value = questions[index]['question']!;
//       correctAnswer = questions[index]['answer']!;
//       _initializeMaskedAnswer();
//       availableLetters = List.from(letters);
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Oyun tugadi'),
//           content: Text('Siz barcha savollarni tugatdingiz!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _resetGame();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   void _initializeMaskedAnswer() {
//     String initialMaskedAnswer =
//         correctAnswer.replaceAll(RegExp(r'[A-Z]'), '*');
//     maskedAnswer.value = initialMaskedAnswer;
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleButtonClick(String letter) {
//     setState(() {
//       availableLetters.remove(letter);
//     });

//     String newMaskedAnswer = '';
//     bool correctGuess = false;

//     for (int i = 0; i < correctAnswer.length; i++) {
//       if (correctAnswer[i] == letter) {
//         newMaskedAnswer += letter;
//         correctGuess = true;
//       } else {
//         newMaskedAnswer += maskedAnswer.value[i];
//       }
//     }

//     maskedAnswer.value = newMaskedAnswer;

//     if (maskedAnswer.value == correctAnswer) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Tabriklaymiz!'),
//           content: Text('Siz yutdingiz!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 score.value += 10;
//                 level.value += 1;
//                 if (level.value % 5 == 0) {
//                   gems.value += 50;
//                 }
//                 _moveToNextQuestion();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       ).then((_) {
//         setState(() {
//           availableLetters = List.from(letters);
//         });
//       });
//     } else if (correctGuess) {
//       score.value += 5;
//     }
//   }

//   void _moveToNextQuestion() {
//     currentQuestionIndex++;
//     _loadQuestion(currentQuestionIndex);
//   }

//   void _resetGame() {
//     currentQuestionIndex = 0;
//     availableLetters = List.from(letters);
//     _loadQuestion(currentQuestionIndex);
//   }

//   void _handleHelp() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Yordam kerakmi?'),
//           content: Text(
//               'Harf ochish uchun variantlarni tanlang: 1. Birinchi harfni ochish (8 olmos) 2. Tasodifiy harfni ochish (6 olmos). Davom etish kerakmi?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Bekor qilish'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 if (gems.value >= 8) {
//                   gems.value -= 8;
//                   _revealFirstLetter();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Olmos yetarli emas!')));
//                 }
//               },
//               child: Text('Birinchi harfni ochish (8 olmos)'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 if (gems.value >= 6) {
//                   gems.value -= 6;
//                   _revealRandomLetter();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Olmos yetarli emas!')));
//                 }
//               },
//               child: Text('Tasodifiy harfni ochish (6 olmos)'),
//             ),
//           ],
//         );
//       },
//     );
//   }

  // void _revealFirstLetter() {
  //   if (maskedAnswer.value.contains('*')) {
  //     _handleButtonClick(correctAnswer[0]);
  //   }
  // }

//   void _revealRandomLetter() {
//     for (int i = 0; i < correctAnswer.length; i++) {
//       if (maskedAnswer.value[i] == '*') {
//         _handleButtonClick(correctAnswer[i]);
//         break;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/image.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           children: [
//             SizedBox(height: 60),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Obx(
//                     () => Text(
//                       'Level: ${level.value}',
//                       style: GoogleFonts.pressStart2p(
//                         textStyle: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Obx(
//                     () => Text(
//                       'Score: ${score.value}',
//                       style: GoogleFonts.pressStart2p(
//                         textStyle: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Obx(
//                     () => Text(
//                       'Gems: ${gems.value}',
//                       style: GoogleFonts.pressStart2p(
//                         textStyle: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             Obx(
//               () => Text(
//                 question.value,
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.pressStart2p(
//                   textStyle: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 40),
//             Obx(
//               () => Text(
//                 maskedAnswer.value,
//                 style: GoogleFonts.pressStart2p(
//                   textStyle: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 40),
//             GridView.builder(
//               shrinkWrap: true,
//               itemCount: availableLetters.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 7,
//                 mainAxisSpacing: 5,
//                 crossAxisSpacing: 5,
//               ),
//               itemBuilder: (context, index) {
//                 return ElevatedButton(
//                   onPressed: () => _handleButtonClick(availableLetters[index]),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.all(8.0),
//                     backgroundColor: Colors.blueAccent,
//                   ),
//                   child: Text(
//                     availableLetters[index],
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _handleHelp,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//               ),
//               child: Text(
//                 'Yordam',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
