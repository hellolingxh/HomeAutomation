import 'package:speech_recognition/speech_recognition.dart';

abstract class GoogleSpeechRecognition {

  final SpeechRecognition speechRecognition = new SpeechRecognition();

  bool isAvailable = false;
  bool isListening = false;
  bool isComplete = false;

  String resultText = '';

  void setAvailableState(bool result);

  void setRecognitionStartedState();

  void setRecognitionResultState(String speech);

  void setRecognitionCompleteState();

  void activeCallback(bool result);

  void initSpeechRecognizer(){
      
      speechRecognition.setAvailabilityHandler(
          (bool result) => setAvailableState(result)
      );
      speechRecognition.setRecognitionStartedHandler(
          () => setRecognitionStartedState(),
      );
      speechRecognition.setRecognitionResultHandler(
          (String speech) => setRecognitionResultState(speech)
      );
      speechRecognition.setRecognitionCompleteHandler(
          () => setRecognitionCompleteState()
      );
      speechRecognition.activate().then(
          (result) => activeCallback(result)
      );
  }


}
