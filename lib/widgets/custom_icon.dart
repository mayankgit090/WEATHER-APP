import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({super.key,required this. icon,required this.lable,required this.value});
    final Icon icon;
    final String lable;
    final String value;
  @override
  Widget build(BuildContext context) {
    return  Column(
      
     // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        icon,
        const SizedBox(height: 8,),
         Text(value,style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.bold
        ),),
        Text(lable,style: const TextStyle(
          color: Color.fromARGB(255, 141, 137, 137),
          fontWeight: FontWeight.bold
        ),)
      ],
    );
  }
}