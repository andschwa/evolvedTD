class player {
  ArrayList<tower> towers;
  Panel playerPanel;
  Panel statsPanel;
  Panel newpanel;
  
  Panel testpanel;
  
  float resources;        // amount of resources the tower has
  float maxResources;     // max resources the tower can store, may not use, if used should be upgradable
  float resourceGain;     // gain per timestep
  creature selectedCreature;

  player() {
    towers = new ArrayList<tower>();
    
    testpanel = new Panel(400,400,-1000,0,true);
    testpanel.createTextBox(400,200,0,-100,"THIS is a textbox!",40);
    testpanel.createButton(300,100,0,100,"Yay BUTTON",30,new ButtonPress() { public void pressed() { println("button has been pressed!!"); } });
    testpanel.enabled = false;
    
    playerPanel = new Panel(500,420,980,-1020,true);
    playerPanel.createTextBox(480,50,0,-180,new StringPass() { public String passed() { return ("Resources: " + (int)resources); } },40);
    playerPanel.createTextBox(480,50,0,-100,new StringPass() { public String passed() { return ("Generation: " + generation); } },40);
    playerPanel.createTextBox(480,50,0,-20,new StringPass() { public String passed() { return ("Time left: " + (timepergeneration - timesteps)); } },40);
    playerPanel.createButton(350,100,0,110,"Wave Fire",50,new ButtonPress() { public void pressed() { wave_fire(); } });
    
    statsPanel = new Panel(500,520,980,1020-200,false);//-200 so it's not cut off the bottom of some peoples' screens
    statsPanel.createTextBox(20,10+0*50,new StringPass() { public String passed() { return ("Creature: " + selectedCreature.num); } },40);
    statsPanel.createTextBox(20,10+1*50,new StringPass() { public String passed() { return ("Health: " + selectedCreature.health + " / " + selectedCreature.maxHealth + " +" + selectedCreature.health_regen); } },40);
    statsPanel.createTextBox(20,10+2*50,new StringPass() { public String passed() { return ("Fitness: " + selectedCreature.fitness); } },40);
    statsPanel.createTextBox(20,10+3*50,new StringPass() { public String passed() { return ("Max speed: " + (int)selectedCreature.maxMovementSpeed); } },40);
    statsPanel.createTextBox(20,10+4*50,new StringPass() { public String passed() { return ("Time in water: " + selectedCreature.time_in_water); } },40);
    statsPanel.createTextBox(20,10+5*50,new StringPass() { public String passed() { return ("Time on land: " + selectedCreature.time_on_land); } },40);
    statsPanel.createTextBox(20,10+6*50,new StringPass() { public String passed() { return ("Scent strength: " + selectedCreature.scentStrength); } },40);
    statsPanel.createTextBox(20,10+7*50,new StringPass() { public String passed() { return ("Reproduction energy: " + (int)selectedCreature.energy_reproduction); } },40);
    statsPanel.createTextBox(20,10+8*50,new StringPass() { public String passed() { return ("Locomotion energy: " + (int)selectedCreature.energy_locomotion); } },40);
    statsPanel.createTextBox(20,10+9*50,new StringPass() { public String passed() { return ("Health energy: " + (int)selectedCreature.energy_health); } },40);
    
    resources = 0;
    resourceGain = 0.1;
    selectedCreature = null;
  }

  void display() {
    if (selectedCreature != null) {
      Vec2 pos = box2d.getBodyPixelCoord(selectedCreature.body);
      cameraX = int(pos.x);
      cameraY = int(pos.y);
      statsPanel.enabled = true;
    }
    else statsPanel.enabled = false;
    
    for (int i = towers.size() - 1; i >= 0; i--)  // walk through the towers
      towers.get(i).display();  // display them all
    for (int i = panels.size() - 1; i >= 0; i--)
      panels.get(i).display();
  }

  void addtower(tower t) {
    towers.add(t);
  }

  void update() {
    resources += resourceGain;
    // walk through the towers
    for (int i = towers.size() - 1; i >= 0; i--)
      towers.get(i).update();   // update them
    for (int i = panels.size() - 1; i >= 0; i--)
      panels.get(i).update();
  }

  void mouse_pressed() {
    // check if the mouse was pressed in the player panel
    for (int i = panels.size() - 1; i >= 0; i--)
      panels.get(i).mouse_pressed();
  }

  void wave_fire(){
    for (int i = towers.size() - 1; i >= 0; i--){  // walk through the towers
      tower t = towers.get(i);
      t.wave_fire();
    }
  }
}
