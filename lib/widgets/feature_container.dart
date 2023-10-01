import 'package:flutter/material.dart';
import 'package:open_ai_chat_bot/pallete.dart';

class FeatureContainer extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureContainer({super.key, required this.color, required this.headerText, required this.descriptionText});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth*0.01,
        vertical: screenWidth*0.03
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(
          left: 15
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(headerText, style: const TextStyle(
                fontFamily: 'Cera-Pro',
                color: Pallete.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.bold
                
              ),),
            ),
            SizedBox(height: screenWidth*0.02,),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(right:20),
                child: Text(descriptionText, 
                style: const TextStyle(
                  fontFamily: 'Cera-Pro',
                  color: Pallete.blackColor,
                        
                  
                  
                ),
                ),
              ),
            ),
      
          ],
        ),
      ),
    );
  }
}