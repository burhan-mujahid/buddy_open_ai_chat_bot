import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'feature_container.dart';
import '../pallete.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({super.key});

  @override
  State<WelcomeUI> createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {

  int start = 200;
  int delay = 200;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Stack(
        children: [

          FadeInLeft(
            child: Container(
              width: screenWidth,
              //height: screenWidth*0.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, top: 20),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenWidth*0.3,
                          width: screenWidth*0.3,
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/images/openAI.png'))
                          ),
                        ),
                        const SizedBox(width: 30,),
                        SizedBox(
                          height:  screenWidth*0.4,
                            width: screenWidth*0.4,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text('Your Personal Assitant,', style: TextStyle(fontSize: 20, color: Colors.blueAccent, ),),
                              SizedBox(height: 10,),
                              Text('Powered by OpenAI', style: TextStyle(fontSize: 15, color: Colors.blueAccent, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          FadeInUp(
            delay: const Duration(milliseconds: 500),
            child: Container(
              margin: EdgeInsets.only(top: screenWidth*0.4),
              width: screenWidth,
              height: screenHeight*0.95,
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100,

                borderRadius: const BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    const Text('Dall-E  2', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800),),
                    const Text('From your imagination to visual arts', style: TextStyle(color: Colors.white, fontSize: 15, ),),
                    const SizedBox(height: 10,),
                    Container(
                      height: screenWidth*0.5,
                      width: screenWidth*0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: screenWidth*0.4,
                              width: screenWidth*0.22,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                image: const DecorationImage(
                                    image: AssetImage('assets/images/dall_e_sample_1.jpg'),
                                  fit: BoxFit.fitHeight,
                                )

                              ),
                            ),
                            Container(
                              height: screenWidth*0.4,
                              width: screenWidth*0.22,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/dall_e_sample_2.jpeg'),
                                    fit: BoxFit.fitHeight,
                                  )

                              ),
                            ),
                            Container(
                              height: screenWidth*0.4,
                              width: screenWidth*0.22,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/dall_e_sample_3.jpeg'),
                                    fit: BoxFit.fitHeight,
                                  )

                              ),
                            ),

                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),


         FadeInUp(
           delay: Duration(milliseconds: 1000),
           child: Container(
             margin: EdgeInsets.only(top: screenWidth*1.2),
             width: screenWidth,
             height: screenWidth*1.2,
             decoration: const BoxDecoration(
               color: Colors.white38,

               borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40)),
             ),
             child: Padding(
               padding: const EdgeInsets.only(left: 30.0),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const SizedBox(height: 20,),
                   const Text('Chat GPT', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800),),
                   const Text('Your friendly chat assistant', style: TextStyle(color: Colors.white, fontSize: 15, ),),
                   const SizedBox(height: 10,),
                   Container(
                     //height: screenWidth*0.5,
                     width: screenWidth*0.85,
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(15)
                     ),
                     child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: [
                           SlideInLeft(
                             delay: Duration(milliseconds: start),
                             child: const FeatureContainer(color: Pallete.firstSuggestionBoxColor,
                               headerText: 'Writing partner',
                               descriptionText: 'Get help brainstorming ideas',),
                           ),

                           SlideInRight
                             (
                             delay: Duration(milliseconds: start+delay),
                             child: const FeatureContainer(color: Pallete.secondSuggestionBoxColor,
                               headerText: 'Code assistant',
                               descriptionText: 'Get productive & speed up the process',),
                           ),

                           SlideInLeft(
                             delay: Duration(milliseconds: start+ 2*delay),
                             child: const FeatureContainer(color: Pallete.firstSuggestionBoxColor,
                               headerText: 'Explore new ideas',
                               descriptionText: 'Get Inspired and stay creative',),
                           )
                         ],
                       ),
                     ),
                   )

                 ],
               ),
             ),

           ),
         )





        ],
      ),
    );
  }
}
