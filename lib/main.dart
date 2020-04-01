import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SignUpScreen(),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: Card(
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>
    with SingleTickerProviderStateMixin {
  bool _formCompleted = false;
  AnimationController animationController;
  Animation<Color> colorAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));

    var colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    colorAnimation = animationController.drive(colorTween);
  }

  void _showWelcomeScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: animationController.value,
                valueColor: colorAnimation,
                backgroundColor: colorAnimation.value.withOpacity(0.4),
              );
            }),
        SignUpFormBody(
          onProgressChanged: (progress) {
            if (!animationController.isAnimating) {
              animationController.animateTo(progress);
            }
            setState(() {
              _formCompleted = progress == 1;
            });
          },
        ),
        Container(
          height: 40.0,
          width: double.infinity,
          margin: EdgeInsets.all(12.0),
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: _formCompleted ? _showWelcomeScreen : null,
            child: Text('Sign up'),
          ),
        ),
      ],
    );
  }
}

class SignUpFormBody extends StatefulWidget {
  final ValueChanged<double> onProgressChanged;

  SignUpFormBody({
    @required this.onProgressChanged,
  }) : assert(onProgressChanged != null);

  @override
  _SignUpFormBodyState createState() => _SignUpFormBodyState();
}

class _SignUpFormBodyState extends State<SignUpFormBody> {
  static const EdgeInsets padding = EdgeInsets.all(8);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  List<TextEditingController> get controllers =>
      [emailController, phoneController, websiteController];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllers.forEach((c) => c.addListener(() => _updateProgress()));
  }

  double get _formProgress {
    var progress = 0.0;
    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }
    return progress;
  }

  void _updateProgress() {
    widget.onProgressChanged(_formProgress);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: padding,
            child: Text('Sign up', style: Theme.of(context).textTheme.display1),
          ),
          SignUpField(
            hintText: 'Email address',
            controller: emailController,
          ),
          SignUpField(
            hintText: 'Phone number',
            controller: phoneController,
          ),
          SignUpField(
            hintText: 'Website',
            controller: websiteController,
          ),
        ],
      ),
    );
  }
}

class SignUpField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  SignUpField({this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextFormField(
        decoration: InputDecoration(hintText: hintText),
        controller: controller,
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome!', style: Theme.of(context).textTheme.display3),
      ),
    );
  }
}
