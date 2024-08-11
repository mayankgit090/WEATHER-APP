import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Inputfield extends StatefulWidget {
  const Inputfield({super.key,required this.lable,required this.keyboardtype,required this.onchange,required this.controller,required this.validator});
  final String lable;
  final String keyboardtype;
  final Function(String value ) onchange;
  final TextEditingController controller;

   final String? Function(String?)? validator;

  @override
  State<Inputfield> createState() => _InputfieldState();
}

class _InputfieldState extends State<Inputfield> {
  bool obsecure = false;
  @override
  
  Widget build(BuildContext context) {
    final IconData icon;
    if(widget.lable=='Username')
    {
      icon = Icons.person;
    }
    else if(widget.lable == 'Email')
    {
        icon = Icons.email;
    }
    else
    {
        icon = Icons.lock;
    }

    //final TextEditingController textEditingController = TextEditingController();
    return  Padding(
      padding:  const EdgeInsets.all(8.0),
      child: Container(
          width: MediaQuery.of(context).size.width*0.9,
          decoration:  BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.circular(16))
            
          ),
        child:  TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              border: InputBorder.none,
              label: Text(widget.lable,style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15
              ),),
              icon:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon),
              ),

            suffixIcon: widget.lable =='Password'? InkWell(
              onTap: () {
                setState(() {
                  obsecure = !obsecure;
                });
              },
              child:  Icon(!obsecure?Icons.visibility:Icons.visibility_off)) :null
            ),

            onChanged: (value) {
              widget.onchange(value);
            },

            obscureText: (widget.lable=='Password') & obsecure,

            validator: widget.validator
          
        ),
      ),
    );
  }
}