interface ButtonPress {
  void pressed();
}

interface StringPass {
  String passed();
}

class Button {
  float button_height;
  float button_width;
  float button_x;
  float button_y;
  String button_text;
  int textsize;
  int red, green, blue;
  ButtonPress BP;
  Panel parent;
  
  Button(float bw, float bh, float bx, float by, String bt, int ts, int r, int g, int b, Panel pr, ButtonPress BPin) {
    button_width = bw;
    button_height = bh;
    button_x = bx;
    button_y = by;
    button_text = bt;
    textsize = ts;
    red = r;
    green = g;
    blue = b;
    parent = pr;
    BP = BPin;
  }
  
  void display() {
    fill(red,green,blue,150);
    rect(button_x,button_y,button_width,button_height);
    textSize(textsize);
    textAlign(CENTER,CENTER);
    fill(255-red,255-green,255-blue,200);
    text(button_text,button_x,button_y,button_width,button_height);
  }
  
  boolean isMouseOver() {
    return (mouseX <= (((float)width/worldWidth)*((parent.panel_x+(worldWidth/2))+button_x+(button_width/2))) &&
            mouseX >= (((float)width/worldWidth)*((parent.panel_x+(worldWidth/2))+button_x-(button_width/2))) &&
            mouseY <= (((float)width/worldWidth)*((parent.panel_y+(worldHeight/2))+button_y+(button_height/2))) &&
            mouseY >= (((float)width/worldWidth)*((parent.panel_y+(worldHeight/2))+button_y-(button_height/2))));
  }
  
  void buttonPressed() {
    buttonpressed = true;
    BP.pressed();
  }
}

class TextBox {
  float textbox_width = 0;
  float textbox_height = 0;
  float textbox_x;
  float textbox_y;
  String textbox_text;
  int textsize;
  StringPass SP = null;
  Panel parent;
  int align_horiz;
  int align_vert;
  
  TextBox(float tw, float th, float tx, float ty, String tt, int ts, Panel pr, int ah, int av) {
    textbox_width = tw;
    textbox_height = th;
    textbox_x = tx;
    textbox_y = ty;
    textbox_text = tt;
    textsize = ts;
    parent = pr;
    align_horiz = ah;
    align_vert = av;
  }
  
  TextBox(float tcx, float tcy, String tt, int ts, Panel pr, int ah, int av) {
    textbox_x = (tcx-(pr.panel_width/2));
    textbox_y = (tcy-(pr.panel_height/2));
    textbox_text = tt;
    textsize = ts;
    parent = pr;
    align_horiz = ah;
    align_vert = av;
  }
  
  TextBox(float tw, float th, float tx, float ty, StringPass SPin, int ts, Panel pr, int ah, int av) {
    textbox_width = tw;
    textbox_height = th;
    textbox_x = tx;
    textbox_y = ty;
    SP = SPin;
    textsize = ts;
    parent = pr;
    align_horiz = ah;
    align_vert = av;
  }
  
  TextBox(float tcx, float tcy, StringPass SPin, int ts, Panel pr, int ah, int av) {
    textbox_x = (tcx-(pr.panel_width/2));
    textbox_y = (tcy-(pr.panel_height/2));
    SP = SPin;
    textsize = ts;
    parent = pr;
    align_horiz = ah;
    align_vert = av;
  }
  
  void display() {
    fill(0,0,0,200);
    textSize(textsize);
    if (textbox_width == 0 && textbox_height == 0) {
      textAlign(align_horiz,align_vert);
      fill(0,0,0,200);
      if (SP == null) text(textbox_text,textbox_x,textbox_y);
      else {
        text(SP.passed(),textbox_x,textbox_y);
      }
    }
    else {
      textAlign(align_horiz,align_vert);
      fill(0,0,0,200);
      if (SP == null) text(textbox_text,textbox_x,textbox_y,textbox_width,textbox_height);
      else {
        text(SP.passed(),textbox_x,textbox_y,textbox_width,textbox_height);
      }
    }
  }
}

class Panel {
  float panel_width;
  float panel_height;
  float panel_x;
  float panel_y;
  boolean hiddenpanel;
  boolean enabled;
  boolean shown;
  float offsetX;
  float offsetY;
  float current_offsetX;
  float current_offsetY;
  int direction;
  ArrayList<Button> buttons = new ArrayList<Button>();
  ArrayList<TextBox> textboxes = new ArrayList<TextBox>();
  
  Panel(float pw, float ph, float px, float py, boolean hp) {
    panel_width = pw;
    panel_height = ph;
    panel_x = px;
    panel_y = py;
    hiddenpanel = hp;
    enabled = true;
    if (hiddenpanel) {
      shown = false;
      if (panel_x > panel_y)
        if ((-1*panel_x) > panel_y)
          direction = 0;
        else
          direction = 1;
      else
        if ((-1*panel_x) > panel_y)
          direction = 3;
        else
          direction = 2;
      switch (direction) {
        case 0:
          offsetX = 0;
          offsetY = ((-1*((panel_y+(worldHeight/2))+(panel_height/2)))+5);
          current_offsetX = 0;
          current_offsetY = offsetY;
          break;
        case 1:
          offsetX = ((((worldWidth/2)-panel_x)+(panel_width/2))-5);
          offsetY = 0;
          current_offsetX = offsetX;
          current_offsetY = 0;
          break;
        case 2:
          offsetX = 0;
          offsetY = ((((worldHeight/2)-panel_y)+(panel_height/2))-5);
          current_offsetX = 0;
          current_offsetY = offsetY;
          break;
        case 3:
          offsetX = ((-1*((panel_x+(worldWidth/2))+(panel_width/2)))+5);
          offsetY = 0;
          current_offsetX = offsetX;
          current_offsetY = 0;
          break;
      }
    }
    else shown = true;
    panels.add(this);
  }
  
  //  x = cameraX + (cameraZ * sin(PI/2.0)*1.15) * ((mouseX-width*0.5)/(width*0.5)) * 0.5; // not sure why 1.15
  //  y = cameraY + (cameraZ * sin(PI/2.0)*1.15) * ((mouseY-width*0.5)/(width*0.5)) * 0.5; // not sure why 1.15

  void display() {
    if (!enabled)return;
    if (shown) {
      pushMatrix();
      hint(DISABLE_DEPTH_TEST);
        translate(cameraX+panel_x, cameraY+panel_y,cameraZ-zoomOffset);  // centered and below the camera+180+panel_x
        fill(255,255,255,150);
        rect(0,0,panel_width,panel_height);
        for (Button b : buttons)
          b.display();
        for (TextBox t : textboxes)
          t.display();
      hint(ENABLE_DEPTH_TEST); 
      popMatrix();
    }
    else if (hiddenpanel) {
      pushMatrix();
      hint(DISABLE_DEPTH_TEST);
        translate(cameraX+panel_x+current_offsetX, cameraY+panel_y+current_offsetY,cameraZ-zoomOffset);
        fill(255,255,255,150);
        rect(0,0,panel_width,panel_height);
      hint(ENABLE_DEPTH_TEST); 
      popMatrix();
    }
  }
  
  void update() {
    if (!enabled)return;
    if (hiddenpanel) {
      if (isMouseNear()) {
        if (!shown) {
          if (direction == 0 || direction == 2) {
            current_offsetY -= (offsetY*0.1);
            if(current_offsetY == 0)shown = true;
          }
          else {
            current_offsetX -= (offsetX*0.1);
            if(current_offsetX == 0)shown = true;
          }
        }
      }
      else if (current_offsetX != offsetX || current_offsetY != offsetY) {
        if (direction == 0 || direction == 2) {
          current_offsetY += (offsetY*0.1);
          if (shown)shown = false;
        }
        else {
          current_offsetX += (offsetX*0.1);
          if (shown)shown = false;
        }
      }
    }
  }
  
  boolean isMouseNear() {
    return ((mouseX <= (((float)width/worldWidth)*((panel_x+(worldWidth/2))+(panel_width/2)))) &&
            (mouseX >= (((float)width/worldWidth)*((panel_x+(worldWidth/2))-(panel_width/2)))) &&
            (mouseY <= (((float)width/worldWidth)*((panel_y+(worldHeight/2))+(panel_height/2)))) &&
            (mouseY >= (((float)width/worldWidth)*((panel_y+(worldHeight/2))-(panel_height/2)))));
  }
  
  void mouse_pressed() {
    if (!enabled)return;
    for (Button b : buttons)
      if (b.isMouseOver())b.buttonPressed();
  }
  
  int createButton(float bw, float bh, float bx, float by, String bt, int ts, ButtonPress BP) {
    buttons.add(new Button(bw,bh,bx,by,bt,ts,0,0,128,this,BP));//bw,bh,bx,by,bt,this,BP));
    return (buttons.size() - 1); // return the index of this button for later reference
  }
  
  int createButton(float bw, float bh, float bx, float by, String bt, int ts, int r, int g, int b, ButtonPress BP) {
    buttons.add(new Button(bw,bh,bx,by,bt,ts,r,g,b,this,BP));//bw,bh,bx,by,bt,this,BP));
    return (buttons.size() - 1); // return the index of this button for later reference
  }
  
  int createTextBox(float tw, float th, float tx, float ty, String tt, int ts) {//used for hardcoded strings
    textboxes.add(new TextBox(tw,th,tx,ty,tt,ts,this,CENTER,CENTER));//specifies a size for the text to wrap within
    return (textboxes.size() - 1); // return the index of this textbox for later reference
  }
  
  int createTextBox(float tcx, float tcy, String tt, int ts) {//used for hardcoded strings
    textboxes.add(new TextBox(tcx,tcy,tt,ts,this,LEFT,TOP));//bw,bh,bx,by,bt,this,BP));
    return (textboxes.size() - 1); // return the index of this textbox for later reference
  }
  
  int createTextBox(float tw, float th, float tx, float ty, StringPass SP, int ts) {//used when the contents of the textbox contains a variable that will change, and therefore must be accesed every time
    textboxes.add(new TextBox(tw,th,tx,ty,SP,ts,this,CENTER,CENTER));//specifies a size for the text to wrap within
    return (textboxes.size() - 1); // return the index of this textbox for later reference
  }
  
  int createTextBox(float tcx, float tcy, StringPass SP, int ts) {//used when the contents of the textbox contains a variable that will change, and therefore must be accesed every time
    textboxes.add(new TextBox(tcx,tcy,SP,ts,this,LEFT,TOP));//bw,bh,bx,by,bt,this,BP));
    return (textboxes.size() - 1); // return the index of this textbox for later reference
  }
  
  int createTextBox(float tw, float th, float tx, float ty, String tt, int ts, int ah, int av) {//used for hardcoded strings
    textboxes.add(new TextBox(tw,th,tx,ty,tt,ts,this,ah,av));//specifies a size for the text to wrap within
    return (textboxes.size() - 1); // return the index of this textbox for later reference
  }
  
  int createTextBox(float tcx, float tcy, String tt, int ts, int ah, int av) {//used for hardcoded strings
    textboxes.add(new TextBox(tcx,tcy,tt,ts,this,ah,av));//bw,bh,bx,by,bt,this,BP));
    return (textboxes.size() - 1); // return the index of this textbox for later reference
  }
  
  int createTextBox(float tw, float th, float tx, float ty, StringPass SP, int ts, int ah, int av) {//used when the contents of the textbox contains a variable that will change, and therefore must be accesed every time
    textboxes.add(new TextBox(tw,th,tx,ty,SP,ts,this,ah,av));//specifies a size for the text to wrap within
    return (textboxes.size() - 1); // return the index of this textbox for later reference
  }
  
  int createTextBox(float tcx, float tcy, StringPass SP, int ts, int ah, int av) {//used when the contents of the textbox contains a variable that will change, and therefore must be accesed every time
    textboxes.add(new TextBox(tcx,tcy,SP,ts,this,ah,av));//bw,bh,bx,by,bt,this,BP));
    return (textboxes.size() - 1); // return the index of this textbox for later reference
  }
}