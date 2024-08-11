import 'package:flutter/material.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key,required this.takeinput});
  final void Function(String city) takeinput;

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final _formkey = GlobalKey<FormState>();
  String ? cityinput;
  @override
  Widget build(BuildContext context) {

    void search()
    {
        final valid =   _formkey.currentState!.validate();

          if(!valid)
          {
            return;
          }

        widget.takeinput(cityinput!);

        Navigator.of(context).pop();
    }
    return Dialog(
      child: SizedBox(
        height: 170,
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formkey,
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    label: Text('Input city name'),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                      cityinput = value;
                  },
                  validator: (value) {
                      if(value==null || value.isEmpty )
                      {
                            return 'Please provide valid city name';
                      }
                      return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 87, 142, 188),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      search();

                      
                    },
                    child: const Text(
                      'Search',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      side: const BorderSide(color: Color.fromARGB(255, 87, 142, 188)),
                    ),
                    onPressed: () {
                      // Handle cancel action
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color.fromARGB(255, 87, 142, 188)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
