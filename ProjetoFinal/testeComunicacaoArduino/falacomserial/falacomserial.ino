#include "Arduino.h"
#include "SoftwareSerial.h"
#include "DFRobotDFPlayerMini.h" //https://github.com/DFRobot/DFRobotDFPlayerMini

#define LED1       10
#define LED2       11
#define LED3       12
#define LED4       13
#define BUZZ        3
#define KEY1       A1
#define KEY2       A2
#define KEY3       A3
#define POT        A0
#define BUZZER 3

#define LATCH_DIO 4
#define CLK_DIO 7
#define DATA_DIO 8

/* Segment byte maps for numbers 0 to 9 */
const byte SEGMENT_MAP[] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0X80, 0X90};
/* Byte maps to select digit 1 to 4 */
const byte SEGMENT_SELECT[] = {0xF1, 0xF2, 0xF4, 0xF8};

/* Run Time definitions*/
int currentTime [4];
double initArdTime;
bool start = false;

double readTime;
double firstPress1;
double deltaT;

// mp3 module initialization
SoftwareSerial mySoftwareSerial(A9, A8); // RX, TX
DFRobotDFPlayerMini myDFPlayer;
int firstTime = 0;
void printDetail(uint8_t type, int value);

void WriteNumberToSegment(byte Segment, byte Value)
{
  digitalWrite(LATCH_DIO, LOW);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_MAP[Value]);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_SELECT[Segment] );
  digitalWrite(LATCH_DIO, HIGH);
}


void decSecond(int * cTime)
{
  cTime[3] --;

  if (cTime[3] < 0)
  {
    cTime[2] --;
    cTime[3] = 9;
  }
  if (cTime[2] < 0)
  {
    cTime[2] = 5;
    cTime[3] = 9;
    cTime[1] --;
    if (cTime[1] < 0)
    {
      cTime[0] --;
      cTime[1] = 9;
    }
    if (cTime[0] < 0)
    {
      cTime[0] = 0;
      cTime[1] = 0;
      cTime[2] = 0;
      cTime[3] = 0;
    }
  }
}

void initialTime (void)
{
  int i;
  
  currentTime[0] = 0;
  currentTime[1] = 1;
  currentTime[2] = 3;
  currentTime[3] = 0;
  for (i = 0; i < 4; i++)
  {
    WriteNumberToSegment(i, 0);
  }
  initArdTime = millis();
}

void runWriteTime (void)
{
  int i;
  if (start == true && millis() - initArdTime > 1000) // se passou 1 segundo
  {
    decSecond(currentTime);

    initArdTime = millis();
  }
  for (i = 0; i < 4; i++)
  {
    WriteNumberToSegment(i, currentTime[i]);
  }
}


void setup() {
  
  mySoftwareSerial.begin(9600);
  
  if (!myDFPlayer.begin(mySoftwareSerial)) {  //Use softwareSerial to communicate with mp3.

    while(true);
  }
  
  myDFPlayer.volume(25);  //Set volume value. From 0 to 30

  // put your setup code here, to run once:
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  // make the pushbutton's pin an input:
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(LED4, OUTPUT);
  pinMode(KEY1, INPUT_PULLUP);
  pinMode(KEY2, INPUT_PULLUP);
  pinMode(KEY3, INPUT_PULLUP);
  digitalWrite(LED1, HIGH);
  digitalWrite(LED2, HIGH);
  digitalWrite(LED3, HIGH);
  digitalWrite(LED4, HIGH);  
  pinMode (BUZZER, OUTPUT);
  digitalWrite(BUZZER, HIGH);

   /* Set DIO pins to outputs */
   pinMode(LATCH_DIO,OUTPUT);
   pinMode(CLK_DIO,OUTPUT);
   pinMode(DATA_DIO,OUTPUT);

  initialTime ();
  readTime = millis();
  firstPress1 = millis();
}

void pisca (int led) {
  digitalWrite(led, LOW);
  delay(300);
  digitalWrite(led, HIGH);
}


void loop() {
  
  char incomingByte;
  // read the input pin:
  int button1State = digitalRead(KEY1);
  int button2State = digitalRead(KEY2);
  int button3State = digitalRead(KEY3);
  runWriteTime ();

  if(start == true)
  {
    if(millis() - firstPress1 > deltaT)
    {
      if (button1State == LOW) {
        Serial.write("1");
        //pisca(LED2);
      }
      else
      {
        if (button2State == LOW)
        {
          Serial.write("2");
          //pisca(LED3);
        }
        else
        {
          if (button3State == LOW)
          {
            Serial.write("3");
            //pisca(LED4);
          }
          else Serial.write("0");
        }
      }
      firstPress1 = millis();
    }
  }
  if ((millis() - readTime) > 100 && Serial.available() > 0) {
    incomingByte = Serial.read();
    if(firstTime == 0 && incomingByte == '1')
    {
      myDFPlayer.play(2);  //Play the first mp3
      firstTime = 1;
      start = true;
      //pisca(LED3);
      deltaT = Serial.read();
      firstPress1 = millis();
    }
    //pisca(LED1);
    //Serial.write(incomingByte);
    readTime = millis();
  }
  delay(10);       // delay in between reads for stability
}
