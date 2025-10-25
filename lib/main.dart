import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Master',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.quiz,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Quiz Master',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Challenge Your Mind',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Ready for a challenge?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 50),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildCategoryCard(
                        context,
                        'General',
                        Icons.public,
                        Colors.orange,
                        QuizCategory.general,
                      ),
                      _buildCategoryCard(
                        context,
                        'Science',
                        Icons.science,
                        Colors.green,
                        QuizCategory.science,
                      ),
                      _buildCategoryCard(
                        context,
                        'History',
                        Icons.history_edu,
                        Colors.brown,
                        QuizCategory.history,
                      ),
                      _buildCategoryCard(
                        context,
                        'Sports',
                        Icons.sports_soccer,
                        Colors.blue,
                        QuizCategory.sports,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StatsScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.analytics),
                        SizedBox(width: 10),
                        Text(
                          'View Statistics',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon,
      Color color, QuizCategory category) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizScreen(category: category),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              SizedBox(height: 15),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum QuizCategory { general, science, history, sports }

class Question {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final QuizCategory category;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.category,
  });
}

class QuizData {
  static List<Question> getQuestions(QuizCategory category) {
    switch (category) {
      case QuizCategory.general:
        return [
          Question(
            question: "What is the capital of France?",
            options: ["London", "Berlin", "Paris", "Madrid"],
            correctAnswer: 2,
            category: category,
          ),
          Question(
            question: "Which planet is known as the Red Planet?",
            options: ["Venus", "Mars", "Jupiter", "Saturn"],
            correctAnswer: 1,
            category: category,
          ),
          Question(
            question: "What is the largest mammal in the world?",
            options: ["Elephant", "Blue Whale", "Giraffe", "Hippopotamus"],
            correctAnswer: 1,
            category: category,
          ),
        ];
      case QuizCategory.science:
        return [
          Question(
            question: "What is the chemical symbol for gold?",
            options: ["Go", "Gd", "Au", "Ag"],
            correctAnswer: 2,
            category: category,
          ),
          Question(
            question: "How many bones are in the human body?",
            options: ["206", "208", "210", "204"],
            correctAnswer: 0,
            category: category,
          ),
          Question(
            question: "What gas do plants absorb from the atmosphere?",
            options: ["Oxygen", "Nitrogen", "Carbon Dioxide", "Hydrogen"],
            correctAnswer: 2,
            category: category,
          ),
        ];
      case QuizCategory.history:
        return [
          Question(
            question: "In which year did World War II end?",
            options: ["1944", "1945", "1946", "1947"],
            correctAnswer: 1,
            category: category,
          ),
          Question(
            question: "Who was the first person to walk on the moon?",
            options: ["Buzz Aldrin", "Neil Armstrong", "John Glenn", "Alan Shepard"],
            correctAnswer: 1,
            category: category,
          ),
          Question(
            question: "Which ancient wonder of the world was located in Egypt?",
            options: ["Hanging Gardens", "Colossus of Rhodes", "Great Pyramid", "Lighthouse of Alexandria"],
            correctAnswer: 2,
            category: category,
          ),
        ];
      case QuizCategory.sports:
        return [
          Question(
            question: "How many players are on a basketball team on the court?",
            options: ["4", "5", "6", "7"],
            correctAnswer: 1,
            category: category,
          ),
          Question(
            question: "In which sport would you perform a slam dunk?",
            options: ["Tennis", "Basketball", "Volleyball", "Baseball"],
            correctAnswer: 1,
            category: category,
          ),
          Question(
            question: "How often are the Summer Olympic Games held?",
            options: ["Every 2 years", "Every 3 years", "Every 4 years", "Every 5 years"],
            correctAnswer: 2,
            category: category,
          ),
        ];
    }
  }
}

class QuizScreen extends StatefulWidget {
  final QuizCategory category;

  QuizScreen({required this.category});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with TickerProviderStateMixin {
  List<Question> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedAnswer;
  bool isAnswered = false;
  late AnimationController _progressController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    questions = QuizData.getQuestions(widget.category);
    _progressController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _selectAnswer(int answer) {
    if (isAnswered) return;

    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
    });

    HapticFeedback.lightImpact();

    if (answer == questions[currentQuestionIndex].correctAnswer) {
      score++;
    }

    _progressController.forward();

    Future.delayed(Duration(seconds: 2), () {
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswered = false;
      });
      _progressController.reset();
      _slideController.reset();
      _slideController.forward();
    } else {
      _showResults();
    }
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: score,
          totalQuestions: questions.length,
          category: widget.category,
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (widget.category) {
      case QuizCategory.general:
        return Colors.orange;
      case QuizCategory.science:
        return Colors.green;
      case QuizCategory.history:
        return Colors.brown;
      case QuizCategory.sports:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = questions[currentQuestionIndex];
    double progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _getCategoryColor().withOpacity(0.8),
              _getCategoryColor().withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Header with progress
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${currentQuestionIndex + 1} of ${questions.length}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'Score: $score',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Question Card
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Text(
                              currentQuestion.question,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 40),
                            Expanded(
                              child: ListView.builder(
                                itemCount: currentQuestion.options.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: _buildOptionButton(
                                      currentQuestion.options[index],
                                      index,
                                      currentQuestion.correctAnswer,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option, int index, int correctAnswer) {
    Color buttonColor = Colors.grey[100]!;
    Color textColor = Colors.grey[800]!;
    IconData? icon;

    if (isAnswered) {
      if (index == correctAnswer) {
        buttonColor = Colors.green;
        textColor = Colors.white;
        icon = Icons.check_circle;
      } else if (index == selectedAnswer && index != correctAnswer) {
        buttonColor = Colors.red;
        textColor = Colors.white;
        icon = Icons.cancel;
      }
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () => _selectAnswer(index),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isAnswered && (index == correctAnswer || index == selectedAnswer)
                  ? Colors.transparent
                  : Colors.grey[300]!,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: textColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final QuizCategory category;

  ResultScreen({
    required this.score,
    required this.totalQuestions,
    required this.category,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getCategoryColor() {
    switch (widget.category) {
      case QuizCategory.general:
        return Colors.orange;
      case QuizCategory.science:
        return Colors.green;
      case QuizCategory.history:
        return Colors.brown;
      case QuizCategory.sports:
        return Colors.blue;
    }
  }

  String _getResultMessage() {
    double percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 80) return "Excellent! 🏆";
    if (percentage >= 60) return "Good Job! 👏";
    if (percentage >= 40) return "Not Bad! 👍";
    return "Keep Trying! 💪";
  }

  @override
  Widget build(BuildContext context) {
    double percentage = (widget.score / widget.totalQuestions) * 100;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _getCategoryColor().withOpacity(0.8),
              _getCategoryColor().withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Quiz Complete!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _getResultMessage(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      SizedBox(height: 40),

                      // Score Circle
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${widget.score}',
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        color: _getCategoryColor(),
                                      ),
                                    ),
                                    Text(
                                      'out of ${widget.totalQuestions}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${percentage.toInt()}%',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _getCategoryColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 40),

                      // Stats Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Correct',
                              '${widget.score}',
                              Icons.check_circle,
                              Colors.green,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: _buildStatCard(
                              'Wrong',
                              '${widget.totalQuestions - widget.score}',
                              Icons.cancel,
                              Colors.red,
                            ),
                          ),
                        ],
                      ),

                      Expanded(child: SizedBox()),

                      // Action Buttons
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizScreen(category: widget.category),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: _getCategoryColor(),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen()),
                                      (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                                ),
                              ),
                              child: Text(
                                'Back to Home',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: color,
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Text(
                      'Statistics',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // Overall Stats Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Performance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverallStatItem(
                              'Total Quizzes',
                              '12',
                              Icons.quiz,
                              Colors.blue,
                            ),
                          ),
                          Expanded(
                            child: _buildOverallStatItem(
                              'Average Score',
                              '78%',
                              Icons.trending_up,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverallStatItem(
                              'Best Score',
                              '100%',
                              Icons.star,
                              Colors.orange,
                            ),
                          ),
                          Expanded(
                            child: _buildOverallStatItem(
                              'Time Played',
                              '2h 15m',
                              Icons.timer,
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                Text(
                  'Category Performance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 15),

                // Category Stats
                Expanded(
                  child: ListView(
                    children: [
                      _buildCategoryStatCard(
                        'General Knowledge',
                        Icons.public,
                        Colors.orange,
                        85,
                        4,
                        3.4,
                      ),
                      SizedBox(height: 15),
                      _buildCategoryStatCard(
                        'Science',
                        Icons.science,
                        Colors.green,
                        72,
                        3,
                        2.9,
                      ),
                      SizedBox(height: 15),
                      _buildCategoryStatCard(
                        'History',
                        Icons.history_edu,
                        Colors.brown,
                        68,
                        2,
                        2.1,
                      ),
                      SizedBox(height: 15),
                      _buildCategoryStatCard(
                        'Sports',
                        Icons.sports_soccer,
                        Colors.blue,
                        90,
                        3,
                        2.7,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Achievement Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.emoji_events, color: Colors.yellow, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'Recent Achievements',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          _buildAchievementBadge('🏆', 'Perfect Score'),
                          SizedBox(width: 10),
                          _buildAchievementBadge('🔥', 'Quiz Master'),
                          SizedBox(width: 10),
                          _buildAchievementBadge('⚡', 'Speed Runner'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoryStatCard(String title, IconData icon, Color color,
      int accuracy, int quizzesTaken, double avgTime) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Wrap(
                  spacing: 10,
                  children: [
                    Text(
                      'Accuracy: $accuracy%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'Quizzes: $quizzesTaken',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${avgTime}m',
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(String emoji, String title) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 9,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}