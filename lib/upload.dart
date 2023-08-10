import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart'as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
File? image;
final _picker = ImagePicker();
bool showSpinner = false;

  Future<void> getImage()async{
    final PickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if(PickedFile!= null){
      image= File(PickedFile.path);
      setState(() {
        
      });
    }
    else{
      print('no Image selected');
    }
  }

  Future<void> uploadImage()async{
    setState(() {
      showSpinner=true;
    });
    var stream = new http.ByteStream(image!.openRead());
    stream.cast();
    var length= await image!.length();

    var uri = Uri.parse('https://fakestoreapi.com/products');

    var request = new http.MultipartRequest('POST', uri);

    request.fields['title']='Static title';

    var multipart = new http.MultipartFile(
      'image', 
      stream,
       length);
  
  request.files.add(multipart);

  var response = await request.send();

  print(response.stream.toString());
  if(response.statusCode==200){
     setState(() {
      showSpinner=false;
    });
    print('Image uploaded');
  }
  else{
     setState(() {
      showSpinner=false;
    });
    print('Failed');
  }
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Image Api'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: Container(
                child: image == null ? Center(child: Text('Pick Image'),):
              Container(
                child: Center(
                  child: Image.file(
                    File(image!.path).absolute,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              )
              ),
            ),
            SizedBox(height: 150,),
            GestureDetector(
              onTap: (){
                uploadImage();
              },
              child: Container(
                height: 50,
                width: 200,
                color: Colors.green,
                child: Center(child: Text('Upload')),
              ),
            )
          ],
        ),
      ),
    );
  }
}