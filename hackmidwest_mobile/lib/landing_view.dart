import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:hackmidwest_mobile/chat_prompt_view.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPromptView(),),);
    });

  }
  
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineLarge?.copyWith(
      color: Colors.green,
      fontWeight: FontWeight.bold,
    );

    const bgColorCode = 0xffA0522D;

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(bgColorCode),),
      backgroundColor: const Color(bgColorCode),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Flexible(
            child: Image.network(
              "https://img.freepik.com/premium-vector/farmer-using-smartphone-app-that-integrates-ai-technology-weather-data-alert-them-any_216520-124477.jpg",
              width: double.infinity,
            ),
          ),
          Text("FARMWISE", style: textStyle,),
          SizedBox(
            height: 100,
            child: AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText("CULTURE", textStyle: textStyle),
                FadeAnimatedText("SMARTER", textStyle: textStyle),
                FadeAnimatedText("GROW BETTER", textStyle: textStyle),
              ],
            ),
          ),
          const Spacer()
        ],
      ),
    );
  }
}
