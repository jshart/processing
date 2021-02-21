import uibooster.*;
import uibooster.model.*;


FilledForm form;

void setup() {
  size(1200, 1200);
  background(0);
  stroke(255);
  frameRate(30);
  
  new UiBooster().showInfoDialog("UiBooster is a lean library to ....");

UiBooster booster = new UiBooster();
form = booster.createForm("Personal information")
            .addText("Whats your first name?")
            .addTextArea("Tell me something about you")
            .addLabel("Choose an action")
            .addSlider("How many liters did you drink today?", 0, 5, 1, 5, 1)
            .show();
}

void draw() {
    
  int x,y;
  
  background(50);
  circle(10,10,10);
}

void mouseClicked() {
  new UiBooster().showInfoDialog("UiBooster is a lean library to ....");

}
