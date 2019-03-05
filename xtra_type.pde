float LETTER_INTERVAL = 0.2;

void setup() {
  size(512, 512);

  // initialize XYscope with default/custom sound out
  xy = new XYscope(this, "VoiceMeeter Input (VB-Audio VoiceMeeter VAIO)");

  // initialize Geomerative
  RG.init(this);
  
  xy.freq(15);
  xy.amp(.3);
  
  xy.ease(true);
  xy.easeAmount(0.5);
  
  moog = new MoogFilter( 15000, 0.5 );
  moog.setChannelCount(2);
  
  String text = "Philosophy is written in [universe] which stands continously open to our gaze, "
    + "but it cannot be understood unless one first learns the language and recognizes the characters in which it is written. " 
    + "It's written in the language of mathematics, and its characters are triangles, circles, and other geometric figures. "
    + "Without knowledge of this medium, it is impossible to understand a single word of it; " 
    + "without this knowledge, one is wandering about a dark labryinth.";
  //String text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " +
  //  "Curabitur convallis sapien eu odio fringilla, egestas elementum nibh auctor.";  
  
  xy.outXY.pauseNotes();
  
  String[] words = text.split(" ");
  float totalTime = 0;
  for (int i = 0; i < words.length; i++) {
    String word = words[i];
    float wordTime = word.length()*LETTER_INTERVAL;
    xy.outXY.playNote(totalTime, wordTime, new WordInstrument(word, wordTime));
    
    if(word.charAt(word.length()-1) == '.')
      totalTime += wordTime + 1;
    else if(word.charAt(word.length()-1) == ';')
      totalTime += wordTime + 0.5;
    else if(word.charAt(word.length()-1) == ',')
      totalTime += wordTime + 0.35;
    else
      totalTime += wordTime + 0.2;
  }
  
  xy.outXY.resumeNotes();
}

void draw() {
  background(0);
  
  float freq = constrain( map(sin(millis()/random(990, 1010)), -1, 1, 35, 5000), 20, 12000);
  float rez  = constrain( map(cos(millis()/random(990, 1010)), -1, 1, 0.1, 0.5), 0, 1);
  moog.frequency.setLastValue(freq);
  moog.resonance.setLastValue(rez);
 
  // draw XY
  xy.drawXY();
}
