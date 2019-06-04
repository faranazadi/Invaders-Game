//Main class to run game
//Setup 2D array of monkey objects
InvaderEntity[][] monkeys = new InvaderEntity[2][5]; 

//Set up ArrayList for player bullets
ArrayList bullets = new ArrayList();

//Set up ArrayList for monkey bullets
ArrayList monkeyBullets = new ArrayList();

//Variables
//Jungle background and game over background objects
PImage gameBackground, gameOver;

//Font object used throughout game
PFont font;

//Player object
PlayerEntity player;

//Player's HIGHSCORE
int highScore = 0;

//Game modes
final int START = 0;
final int DEFENDING = 1;
final int VICTORY = 2;
final int GAMEOVER = 3;
int gameMode = START;


void setup()
{
  //Set up screen size, backgrounds and font
  size(800,600);
  gameBackground = loadImage("Sprites/Backgrounds/GameBackground.png");
  gameBackground.resize(width, height);
  gameOver = loadImage("Sprites/Backgrounds/GameOver.png");
  gameOver.resize(width, height);
  font = loadFont("Fonts/ARCARTER-48.vlw");
  
  //Create player 
  player = new PlayerEntity(width/2, 550);
  
  //Create monkeys
  createMonkeys();

  //Anti-aliasing
  smooth();
}

//Main game loop
void draw()
{
  //println("px: " + player.x);
  //println("mx: " + mouseX);
  
  //Start screen
  if (gameMode == START)
  {
    //Show the welcome/splash screen
    welcomeScreen();
  }
  //Game in progress
  else if(gameMode == DEFENDING)
  {
    //Draw jungle background
    background(gameBackground);
    
    //Show score and highscore on screen
    textFont(font, 25);
    textAlign(LEFT);
    text("Score: " + player.score, 30, 30);
    text("HighScore: " + highScore, 690, 30);
    text("Lives: " + player.lives, 350, 30);
    
    //Takes care of rendering and movement for player
    player.update();
    
    //Takes care of rendering and movement for each monkey
    updateMonkeys();
    
    //Takes care of rendering and movement for each bullet
    updateBullets();
    
    //Checks to see if player has been hit by monkey bullet
    checkPlayerCollision();
    
    //If player score is 10, all monkeys must have been killed
    if (player.score >= 10) {
      gameMode = VICTORY;
    }
    
    //If player has run out of lives, game over
    if (player.lives <= 0) {
      gameMode = GAMEOVER;
    }
    
  }
  else if (gameMode == VICTORY) 
  {
      background(0);
      fill(255);
      textFont(font, 40);
      textAlign(CENTER);
      text("Congratulations, you killed all the invaders! Press 'r' to restart.", width / 2, height / 2);
      removeRemaingBullets(); //Delete any remaining bullets
  }
  else if (gameMode == GAMEOVER)
  {
    handleGameOver();
  }
  
}

void welcomeScreen()
{
    background(0);
    fill(255);
    textFont(font, 60);
    textAlign(CENTER);
    text("Press ENTER to begin defending!", width / 2, height / 2);
}

void startNewGame()
{
  //Replace the monkeys that have been deleted/killed
  createMonkeys();
  
  //Reset player score
  player.score = 0;
}

void handleGameOver()
{
  //Delete the monkeys left on the game screen
  removeRemainingMonkeys();
  
  //Reset current score and lives
  player.score = 0;
  player.lives = 5;
  //System.out.println(player.score);
  
  //Draw game over background
  background(gameOver);
  
  //Deletes any bullets leftover
  removeRemaingBullets();
}

void createMonkeys()
{
  //Create 10 monkeys
  for (int i = 0; i < 2; i++) {  
  for (int j = 0; j < 5; j++) {  
    //Spawn monkeys randomly on screen
    monkeys[i][j] = new InvaderEntity(random(350), random(350), -4);
    //System.out.println(j);
  }
  //print(i);
  }
}

void removeRemainingMonkeys()
{
  //Delete any remaining monkeys from game
  for (int i = 0; i < 2; i++) {  
  for (int j = 0; j < 5; j++) {  
    if (monkeys[i][j] != null) {
      monkeys[i][j] = null;
    }
    //System.out.println(j);
  }
  //print(i);
  }
}

void updateMonkeys()
{
    checkMonkeyCollision(); //Check to see if monkey has been hit by player bullet
    //For every monkey
    for (int i = 0; i < 2; i++) {  
    for (int j = 0; j < 5; j++) {  
        //System.out.print((i * j) + " ");
       if (monkeys[i][j] != null) {
         if (!monkeys[i][j].yPosLimit()) { //Check to see if NOT reached bottom on screen
            monkeys[i][j].update(); //Draw to game screen if NOT reached bottom
            if (random(10) > 9.98) {
              monkeys[i][j].fireBullet();
            }
          } else {
            gameMode = GAMEOVER;
          }
        }
      }
    }
}

//Checks to see if monkey has been hit by player bullet 
//By checking x and y of bullet in comparison to monkey x and y
void checkMonkeyCollision()
{
    for (int i = 0; i < bullets.size(); i++) {
      Bullet b = (Bullet) bullets.get(i);
      
      //Each monkey image is 50x50 pixels
      //Should check whether bullet is less than 25 pixels away from centre of image
      for (int j = 0; j < 2; j++) {  
        for (int k = 0; k < 5; k++) {  
          if (monkeys[j][k] != null) {
            if (b.x > monkeys[j][k].x && b.x < monkeys[j][k].x+50 && b.y > monkeys[j][k].y && b.y < monkeys[j][k].y+50) {
              System.out.println("Monkey has been hit");
              bullets.remove(b); //Remove this bullet from the ArrayList
              monkeys[j][k] = null; //Delete this monkey
              System.out.print("Number of monkeys: " + (j * k));
              player.score++; //Increment current score
              System.out.println(player.score);
            if (player.score > highScore) {
              highScore = player.score; //Update highscore
            }
         }
        }
      }
    }
  }
}

//Checks to see if player has been hit by monkey bullet 
//By checking x and y of bullet in comparison to player x and y
void checkPlayerCollision()
{
    for (int i = 0; i < monkeyBullets.size(); i++) {
      Bullet mb = (Bullet) monkeyBullets.get(i);
      
      //Player image is 50x50
      if (mb.x > player.x && mb.x < player.x+50 && mb.y > player.y && mb.y < player.y+50) {
        System.out.println("Player has been hit");
        monkeyBullets.remove(mb); //Remove this bullet from the ArrayList
        player.lives--;
      }
    }
}

void updateBullets()
{
    //Handles rendering and boundary checking for each bullet
    for (int i = 0; i < bullets.size(); i++) {
        Bullet bullet = (Bullet) bullets.get(i);
        bullet.update();
    }
    
    for (int i = 0; i < monkeyBullets.size(); i++) {
        Bullet monkeyBullet = (Bullet) monkeyBullets.get(i);
        monkeyBullet.update();
    }
}

void removeRemaingBullets()
{
    //Deletes all remaining bullets from the game
    for (int i = 0; i < bullets.size(); i++) {
        bullets.clear();
    }
    
    for (int i = 0; i < monkeyBullets.size(); i++) {
        monkeyBullets.clear();
    }
}

void keyPressed()
{
    if (key == ENTER) //Starts game
    {
      gameMode = DEFENDING;
    }
    if (key == ' ' && gameMode == DEFENDING) //Shoot bullet
    {
      player.fireBullet();
    }
    if (key == 'r' && gameMode == GAMEOVER || gameMode == VICTORY) //Restarts game if player wins or loses
    {
      gameMode = DEFENDING;
      System.out.println("Game mode: defending");
      startNewGame();
    }
    
    if (key == CODED) {
      if (keyCode == RIGHT && player.x <= width) //Moves player to right
      {
        player.x = player.x + 10; 
      } 
      if (keyCode == LEFT && player.x >= 0) //Moves player to left
      {
        player.x = player.x - 10;
      } 
    }
} //End of class