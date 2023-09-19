import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f3_talk/model/speaker_list.dart';
import 'package:f3_talk/model/trascribResult.dart';
import 'package:f3_talk/pages/summerisetext.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

import '../model/data.dart';

class TalkSummery extends StatefulWidget {
  const TalkSummery({Key? key}) : super(key: key);

  @override
  State<TalkSummery> createState() => _TalkSummeryState();
}

class _TalkSummeryState extends State<TalkSummery> {
  late Record auidoRecorder;
  late audio.AudioPlayer audioPlayer;
  bool isRecording = false;
  bool isPlaying = false;
  String? audioPath = "";
  late String _filePath;
  late bool _isUploading = false;
  late bool isAudioIsAvalable = false;
  String? downloadUrl;
  String? uplodingfile;
  TranscribResult? transcribResult = TranscribResult();
  bool isSpekerSelected = false;

  String? selectedValue;

  String? data1;

  final ref = FirebaseFirestore.instance
      .collection('summarise')
      .withConverter<DataModel>(
        fromFirestore: (snapshot, _) => DataModel.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (model, _) => model.toJson(),
      );
  String? docID;

  @override
  void initState() {
    audioPlayer = audio.AudioPlayer();
    auidoRecorder = Record();
    super.initState();
  }

  @override
  void dispose() {
    auidoRecorder.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await auidoRecorder.hasPermission()) {
        await auidoRecorder.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print("print the error for recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await auidoRecorder.stop();
      setState(() {
        isRecording = false;
        audioPath = path;
        print("audio path");
        print(audioPath);

        _onFileUploadButtonPressed();
      });
    } catch (e) {
      print("print the error for stop recording: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      audio.Source urlSource = audio.UrlSource(audioPath!);
      await audioPlayer.play(urlSource);
      setState(() {
        isRecording = true;
      });
    } catch (e) {
      print("print the error for stop recording: $e");
    }
  }

  Future<void> pauseRecording() async {
    try {
      audio.Source urlSource = audio.UrlSource(audioPath!);
      await audioPlayer.pause();
      setState(() {
        isRecording = false;
      });
    } catch (e) {
      print("print the error for stop recording: $e");
    }
  }

  Future<void> _onFileUploadButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      _isUploading = true;
    });
    try {
      final metadata = SettableMetadata(
          contentType: 'audio/m3',
          customMetadata: {'picked-file-path': audioPath!});

      await firebaseStorage
          .ref('transcriptions')
          .child(audioPath!
              .substring(audioPath!.lastIndexOf('/'), audioPath!.length))
          .putFile(File(audioPath!), metadata);

      // widget.onUploadComplete();

      uplodingfile =
          audioPath!.substring(audioPath!.lastIndexOf('/'), audioPath!.length);
      uplodingfile = uplodingfile?.replaceAll("/", " ");
      uplodingfile = uplodingfile?.replaceAll(" ", "");
      print("uploading file");
      print(uplodingfile);
      setState(() {
        downloadFile();
      });

      String getFileNameFromUrl(String url) {
        Uri uri = Uri.parse(url);
        return uri.pathSegments.last;
      }

      setState(() {
        isAudioIsAvalable = true;
      });
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> downloadFile() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    try {
      print('download URL');
      print('transcriptions/$uplodingfile.wav_transcription.txt');
      Reference ref = firebaseStorage
          .ref('transcriptions')
          .child('$uplodingfile.wav_transcription.txt');

      String downloadUrl = await ref.getDownloadURL();
      http.Response response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        print(data['results'][0]['alternatives'][0]['transcript']);
        TranscribResult transcribResult = TranscribResult.fromJson(data);
        data1 =
            transcribResult.results![0].alternatives?[0].transcript.toString();
        print("************* data1 ******************");
        print(data1);
        setState(() {});
      } else {
        CircularProgressIndicator();
      }

      // You can use the 'downloadUrl' to download the file or display it as needed.
      print("Download URL: $downloadUrl");

      // Extract the filename from the download URL
      String filename = ref.name;
      print("Filename: $filename");
      print("printing actual url ++++++++++++++++++++++");
      print('transcriptions/$uplodingfile.wav_transcription.txt');
    } catch (error) {
      print('Error occurred while downloading file: ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred while downloading file'),
        ),
      );
    }
  }

  Future<void> _summeriseText() async {
    var doc = await ref.add(DataModel(text: data1, speakerName: selectedValue));
    setState(() {
      docID = doc.id;

    });

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => SummersiseText()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text("Record the Talk"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/images/record.png',
            height: 150,
            width: 150,
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Select the Speaker",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),

          Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: const Row(
                  children: [
                    Icon(
                      Icons.list,
                      size: 16,
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Select Speaker',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                    isSpekerSelected = true;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: 400,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.blue,
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.yellow,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.blue,
                  ),
                  offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all(6),
                    thumbVisibility: MaterialStateProperty.all(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),

          if (isRecording) const Text("recording in progress"),
          SizedBox(
            height: 200,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                if (isSpekerSelected == true) {
                  if (isRecording == true) {
                    stopRecording();
                  } else {
                    startRecording();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select the speaker'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: isRecording
                  ? const Icon(
                      Icons.stop,
                      size: 40,
                    )
                  : const Icon(
                      Icons.mic_rounded,
                      size: 40,
                    ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Record the talk",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isRecording && audioPath != null)
                ElevatedButton(
                    onPressed: playRecording, child: const Icon(Icons.play_arrow,color: Colors.blue,)),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: pauseRecording, child: const Icon(Icons.pause,color: Colors.blue,)),
              const SizedBox(
                width: 5,
              ),
              ElevatedButton(
                  onPressed: _summeriseText,
                  child: const Text("summarise Talk",style: TextStyle(color: Colors.blue),)),
            ],
          ),

        ],
      ),
    );
  }
}
