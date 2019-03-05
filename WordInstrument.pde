// import and create instance of XYscope
import xyscope.*;
XYscope xy;

// minim is required to generate audio
import ddf.minim.*; 
// extra libs are required for filtering
import ddf.minim.ugens.*;

// geomerative is required to generate text points
import geomerative.*; 

MoogFilter moog;

class WordInstrument implements Instrument 
{
  // variables
  ADSR  adsr;
  String text;
  
  // construct object
  WordInstrument( String word, float dur ){
    text = word;
    
    adsr = new ADSR(0.2);
        
    // patch everything together up to the final output
    xy.waveY.patch(adsr).patch(xy.outXY);
  }
  
  void noteOn( float dur ) {
    // clear waves like refreshing background
    xy.clearWaves(); 
  
    // write shape into audio buffer
    generateShape();
  
    // build audio from shapes
    xy.buildWaves();
    
    // patch to the output
    adsr.patch(moog).patch( xy.outXY );
    
    // turn on the ADSR
    adsr.noteOn();
  }
  
  void noteOff() {
    // call the noteOff 
    adsr.noteOff();
    
    // tell the ADSR to unpatch after the release is finished
    adsr.unpatchAfterRelease( xy.outXY );
    xy.waveY.unpatch(adsr);
  }
  
  // generates the word shape
  private void generateShape() {
    try{
      // render type with Geomerative
      RShape grp = RG.getText(text, "FreeSans.ttf", width/2, CENTER); 
      grp.centerIn(g, 30);
      RG.setPolygonizer(RG.UNIFORMSTEP);
      RG.setPolygonizerStep(10);
      RPoint[][] pointPaths = grp.getPointsInPaths();
    
      pushMatrix();
      translate(width/2, height/2);
      if (pointPaths != null) { // only draw if we have points 
        for (int i = 0; i < pointPaths.length; i++) { 
          xy.beginShape(); 
          for (int j=0; j < pointPaths[i].length; j++) { 
            xy.vertex(pointPaths[i][j].x, pointPaths[i][j].y);
          } 
          xy.endShape();
        }
      } 
      popMatrix();
    }catch(Exception e) {
      println("error");
    }
  } 
}
