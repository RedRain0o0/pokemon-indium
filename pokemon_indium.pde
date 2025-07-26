// Imports
import processing.sound.*;
import java.nio.file.*;

// Vars
PrintWriter[] save;
SoundFile[] sfx = new SoundFile[1];
int[] soundTimer = new int[2];
String[][] saves = {{},{},{}};
int metadataIterator = 0;
int currentArea;
int[][][] currentAreaMap = {{{0,0}},{{0,0}},{{0,0}}};
String[] tempAreaDataStorage = {};
String[] currentAreaMetadata = {};
int[] areaSize = {0,0};
int[][] areaLoadZones = {{}};
PImage[] currentTileSet;
PImage[] outsideTiles = {};
PImage[] houseTiles = new PImage[24];
PImage[][] playerSprites = new PImage[3][2];
PImage[] uiSprites = new PImage[9];
String playerName = "";
String rivalName = "";
int[] playerPos = {0,0};
int moveTimer = 0;
int moveDir = 3;
int moveCooldown = 0;

boolean showTextBox = false;
boolean showPauseMenu = false;
boolean keyWasPressed = false;
Pokemon[] party = new Pokemon[6];

// Functions
void setup() { // Run on first start
  size(640, 576);
  
  // Load Sounds (wip)
  sfx[0] = new SoundFile(this, "assets/sounds/collision.wav");
  for (int timer : soundTimer) {
    println("Timer prep");
    timer = 0;
  }
  
  // Load sprites
  playerSprites[0][0] = loadImage("assets/player/front_idle.png");
  playerSprites[0][1] = loadImage("assets/player/front_walk.png");
  playerSprites[1][0] = loadImage("assets/player/side_idle.png");
  playerSprites[1][1] = loadImage("assets/player/side_walk.png");
  playerSprites[2][0] = loadImage("assets/player/back_idle.png");
  playerSprites[2][1] = loadImage("assets/player/back_walk.png");
  
  uiSprites[0] = loadImage("assets/ui/ui_top_left.png");
  uiSprites[1] = loadImage("assets/ui/ui_top.png");
  uiSprites[2] = loadImage("assets/ui/ui_top_right.png");
  uiSprites[3] = loadImage("assets/ui/ui_left.png");
  uiSprites[4] = loadImage("assets/ui/ui_middle.png");
  uiSprites[5] = loadImage("assets/ui/ui_right.png");
  uiSprites[6] = loadImage("assets/ui/ui_bottom_left.png");
  uiSprites[7] = loadImage("assets/ui/ui_bottom.png");
  uiSprites[8] = loadImage("assets/ui/ui_bottom_right.png");
  
  houseTiles[0] = loadImage("assets/house/floor.png");
  houseTiles[1] = loadImage("assets/house/wall.png");
  houseTiles[2] = loadImage("assets/house/window.png");
  houseTiles[4] = loadImage("assets/house/stairs_down.png");
  houseTiles[5] = loadImage("assets/house/stairs_up.png");
  houseTiles[6] = loadImage("assets/house/television.png");
  houseTiles[7] = loadImage("assets/house/snes.png");
  houseTiles[8] = loadImage("assets/house/bed_bottom.png");
  houseTiles[9] = loadImage("assets/house/bed_top.png");
  houseTiles[10] = loadImage("assets/house/table_bottom_left.png");
  houseTiles[11] = loadImage("assets/house/table_bottom_right.png");
  houseTiles[12] = loadImage("assets/house/table_wall_left.png");
  houseTiles[13] = loadImage("assets/house/table_wall_right.png");
  houseTiles[14] = loadImage("assets/house/table_top_left.png");
  houseTiles[15] = loadImage("assets/house/table_top_right.png");
  houseTiles[16] = loadImage("assets/house/computer_bottom.png");
  houseTiles[17] = loadImage("assets/house/computer_top.png");
  houseTiles[18] = loadImage("assets/house/plant_bottom.png");
  houseTiles[19] = loadImage("assets/house/plant_top.png");
  houseTiles[20] = loadImage("assets/house/bookshelf_bottom.png");
  houseTiles[21] = loadImage("assets/house/bookshelf_top.png");
  houseTiles[22] = loadImage("assets/house/stool.png");
  houseTiles[23] = loadImage("assets/house/carpet.png");
  
  // Save file prep (wip)
  saves[0] = loadStrings("saves/save1.txt");
  saves[1] = loadStrings("saves/save2.txt");
  saves[2] = loadStrings("saves/save3.txt");
  save = new PrintWriter[3];
  try { // Read save 1
    int i = 0;
    for (String line : saves[0]) {
      if (i == 0) { // Player X, Player Y, Move Dir, Area
        playerPos[0] = int(line.split(","))[0];
        playerPos[1] = int(line.split(","))[1];
        moveDir = int(line.split(","))[2];
        currentArea = int(line.split(","))[3];
        loadArea(currentArea);
      } else if (i == 1) { // Players name
        playerName = line;
      } else if (i == 2) { // Rivals name
        rivalName = line;
      } else if (i == 3) { // Party 0 info
        party[0] = new Pokemon(int(line.split(","))[1], line.split(",")[0], boolean(line.split(","))[2]);
      } else if (i == 4) { // Party 1 info
        party[0] = new Pokemon(int(line.split(","))[1], line.split(",")[0], boolean(line.split(","))[2]);
      } else if (i == 5) { // Party 2 info
        party[0] = new Pokemon(int(line.split(","))[1], line.split(",")[0], boolean(line.split(","))[2]);
      } else if (i == 6) { // Party 3 info
        party[0] = new Pokemon(int(line.split(","))[1], line.split(",")[0], boolean(line.split(","))[2]);
      } else if (i == 7) { // Party 4 info
        party[0] = new Pokemon(int(line.split(","))[1], line.split(",")[0], boolean(line.split(","))[2]);
      } else if (i == 8) { // Party 5 info
        party[0] = new Pokemon(int(line.split(","))[1], line.split(",")[0], boolean(line.split(","))[2]);
      }
      i++;
    }
  } catch(Exception e) { // Create save 1
    println("Save file 1 does not exist, creating");
    save[0] = createWriter("saves/save1.txt");
    playerPos[0] = 3;
    playerPos[1] = 5;
    moveDir = 1;
    playerName = "Red";
    loadArea(1);
  }
  try {
    int i = 0;
    for (String line : saves[1]) { // Read save 2
      println(line);
      i++;
    }
  } catch(Exception e) { // Create save 2
    println("Save file 2 does not exist, creating");
    save[0] = createWriter("saves/save2.txt");
  }
  try {
    int i = 0;
    for (String line : saves[2]) { // Read save 3
      println(line);
      i++;
    }
  } catch(Exception e) { // Create save 3
    println("Save file 3 does not exist, creating");
    save[0] = createWriter("saves/save3.txt");
  }
  
  // Set texture properties
  noSmooth();
  textureMode(IMAGE);
}

void draw() { // Run every frame
  background(0); // Clear screen
  
  // Inputs
  if (keyPressed) {
    // Movement
    if (moveTimer == 0 && !showPauseMenu) {
      try {
        if (keyCode == 37 && moveDir == 0 && currentAreaMap[1][playerPos[1]][playerPos[0]-1] == (0|2)) { // Move player left
          moveTimer = 16;
          --playerPos[0];
        } else
        if (keyCode == 37) { // Rotate player left
          moveDir = 0;
        } else
        if (keyCode == 38 && moveDir == 1 && currentAreaMap[1][playerPos[1]-1][playerPos[0]] == 0) { // Move player up
          moveTimer = 16;
          --playerPos[1];
        } else
        if (keyCode == 38) { // Rotate player up
          moveDir = 1;
        } else
        if (keyCode == 39 && moveDir == 2 && currentAreaMap[1][playerPos[1]][playerPos[0]+1] == (0|2)) { // Move player right
          moveTimer = 16;
          ++playerPos[0];
          
        } else
        if (keyCode == 39) { // Rotate player right
          moveDir = 2;
        } else
        if (keyCode == 40 && moveDir == 3 && currentAreaMap[1][playerPos[1]+1][playerPos[0]] == (0|2)) { // Move player down
          moveTimer = 16;
          ++playerPos[1];
          if (currentAreaMap[1][playerPos[1]][playerPos[0]] == 2) { // Cliff jump things
            println("Player jumped down a cliff");
          }
        } else
        if (keyCode == 40) { // Rotate player down
          moveDir = 3;
        }
      } catch(Exception e) { // Makes the game not die when attempting to walk out of bounds (prob a better way but its 4am it works for now)
        if (soundTimer[0] == 0) { // Play collision sound
          sfx[0].play();
          soundTimer[0] = 20;
        }
      }
    }
    if (!keyWasPressed) { // Only run logic once per press
      if (key == 'x') { // A button
        println("A Button");
      }
      if (key == 'z') { // B button
        println("B Button");
        if (showPauseMenu) {showPauseMenu = false;} // Close pause screen
      }
      if (key == ENTER) { // Start button
        println("Start Button");
        if (!showPauseMenu) {showPauseMenu = true;} // Open pause screen
      }
    }
    keyWasPressed = true;
  } else {
    keyWasPressed = false;
  }
  
  // Draw area
  push(); // Isolate room movement
  translate(width/2-64, height/2-32); // Center screen at 0, 0
  if (moveTimer > 0) { // Walk animation (screen)
    if (moveDir == 0) { // Animate left
      translate(-playerPos[0]*64-moveTimer*4,-playerPos[1]*64);
    } else
    if (moveDir == 1) { // Animate up
      translate(-playerPos[0]*64,-playerPos[1]*64-moveTimer*4);
    } else
    if (moveDir == 2) { // Animate right
      translate(-playerPos[0]*64+moveTimer*4,-playerPos[1]*64);
    } else
    if (moveDir == 3) { // Animate down
      translate(-playerPos[0]*64,-playerPos[1]*64+moveTimer*4);
    }
    --moveTimer;
  } else { // Place world at player coords
    translate(-playerPos[0]*64,-playerPos[1]*64);
  }
  translate(0,-64);
  for (int y = 0; y < areaSize[1]+1; ++y) { // Draw world tiles
    for (int x = 0; x < areaSize[0]; ++x) {
      image(currentTileSet[currentAreaMap[0][y][x]], x*64,y*64,64,64);
    }
  }
  pop(); // Reset world location
  
  // Area interactions
  if (moveTimer == 1 && currentAreaMap[2][playerPos[1]][playerPos[0]] == 3) {
    for(int[] zone : areaLoadZones) {
      if (playerPos[0] == zone[0] && playerPos[1] == zone[1]) {
        loadArea(zone[2]);
        playerPos[0] = zone[3];
        playerPos[1] = zone[4];
      }
    }
  }
  
  // Draw player
  push(); // Isolate player position
  translate(width/2-32, height/2-96);
  if (moveDir == 0) { // Player facing left
    scale(-1,1); // Flip sprite
    image(playerSprites[1][0], -32, 0, 64, 128);
    scale(-1,1);
  } else
  if (moveDir == 1) { // Player facing up
    image(playerSprites[2][0], -32, 0, 64, 128);
  } else
  if (moveDir == 2) { // Player facing right
    image(playerSprites[1][0], -32, 0, 64, 128);
  } else
  if (moveDir == 3) { // Player facing down
    image(playerSprites[0][0], -32, 0, 64, 128);
  }
  pop(); // Reset player position
  
  // Draw UI
  if (showTextBox) { // Dialogue box (unfinished and unimplemented)
    rect(0,height-64*3,width,64*3);
  }
  if (showPauseMenu) { // Pause screen
    push(); // Isolate pause screen location
    translate(width-64*5,0); // Pause screen position
    
    // Draw top of the box
    image(uiSprites[0], 0, 0, 64, 64);
    image(uiSprites[1], 64, 0, 64, 64);
    image(uiSprites[1], 64*2, 0, 64, 64);
    image(uiSprites[1], 64*3, 0, 64, 64);
    image(uiSprites[2], 64*4, 0, 64, 64);
    
    // Draw body of the box
    for (int i = 1; i < 6; ++i) {
      image(uiSprites[3], 0, 64*i, 64, 64);
      image(uiSprites[4], 64, 64*i, 64, 64);
      image(uiSprites[4], 64*2, 64*i, 64, 64);
      image(uiSprites[4], 64*3, 64*i, 64, 64);
      image(uiSprites[5], 64*4, 64*i, 64, 64);
    }
    
    // Draw bottom of the box
    image(uiSprites[6], 0, 64*6, 64, 64);
    image(uiSprites[7], 64, 64*6, 64, 64);
    image(uiSprites[7], 64*2, 64*6, 64, 64);
    image(uiSprites[7], 64*3, 64*6, 64, 64);
    image(uiSprites[8], 64*4, 64*6, 64, 64);
    //rect(width-64*5,0,64*5,64*7);
    pop(); // Reset pause screen location
  }
  
  // Decrease timers
  for (int i = 0; i < soundTimer.length; ++i) {
    if (soundTimer[i] > 0) {
      --soundTimer[i];
    }
  }
}

void loadArea(int area) { // Load area function, takes an int for the area the player should load into
  currentArea = area; // Set players current area
  currentAreaMetadata = loadStrings("world/area"+currentArea+"/metadata.txt"); // Get metadata for the area
  for (String line : currentAreaMetadata) {
    if (metadataIterator == 0) { // Set tileset to correct type (currently accepts `houseTiles`)
      if (line.matches("houseTiles")) {
        currentTileSet = houseTiles;
      }
    } else
    if (metadataIterator == 1) { // Set areaSize
      areaSize = int(line.split(","));
    } else
    if (metadataIterator == 3) { // Parse loadzone data
      String[] parts = line.split(":");
      int loadZones = parts.length - 2;
      areaLoadZones = new int[loadZones][5];
      for (int i = 0; i < loadZones; ++i) {
        parts[i+1] = parts[i+1].substring(1, parts[i+1].length()-1);
        areaLoadZones[i] = int(parts[i+1].split(","));
      }
    }
    ++metadataIterator;
  }
  metadataIterator = 0;
  
  // Set map data
  currentAreaMap[0] = new int[areaSize[1]+1][areaSize[0]]; // Tileset prep
  currentAreaMap[1] = new int[areaSize[1]][areaSize[0]]; // Collision prep
  currentAreaMap[2] = new int[areaSize[1]][areaSize[0]]; // Interaction prep
  tempAreaDataStorage = loadStrings("world/area"+currentArea+"/tiles.txt"); // Get tiles
  for (String line : tempAreaDataStorage) { // Set tile map by current iterator
    currentAreaMap[0][metadataIterator] = int(line.split(","));
    ++metadataIterator;
  }
  metadataIterator = 0;
  tempAreaDataStorage = loadStrings("world/area"+currentArea+"/collision.txt"); // Get collisions
  for (String line : tempAreaDataStorage) { // Set collision map by current iterator
    currentAreaMap[1][metadataIterator] = int(line.split(","));
    ++metadataIterator;
  }
  metadataIterator = 0;
  tempAreaDataStorage = loadStrings("world/area"+currentArea+"/interaction.txt"); // Get interactions
  for (String line : tempAreaDataStorage) { // Set interaction map by current iterator
    currentAreaMap[2][metadataIterator] = int(line.split(","));
    ++metadataIterator;
  }
  metadataIterator = 0;
}
