#define LED_PIN_1 13
#define LED_PIN_2 10
#define BUTTON_PIN_1 A1
#define BUTTON_PIN_2 A2
#define BUTTON_PIN_3 A3

int state = 1;
unsigned long oldLedTime;
unsigned long timeLed;
unsigned long timeButton1;
unsigned long timeButton2;
int isButton1Pressed;
int isButton2Pressed;

void setup() {
  // put your setup code here, to run once:

  pinMode(LED_PIN_1, OUTPUT);
  pinMode(LED_PIN_2, OUTPUT);
  digitalWrite(LED_PIN_2,HIGH);
  
  pinMode(BUTTON_PIN_1, INPUT_PULLUP);
  pinMode(BUTTON_PIN_2, INPUT_PULLUP);
  pinMode(BUTTON_PIN_3, INPUT_PULLUP);
  
  oldLedTime = millis();
  timeLed = 1000;
  timeButton1 = -500;
  timeButton2 = -500;
  
  isButton1Pressed = 0;
  isButton2Pressed = 0;
}

void loop() {
  
  unsigned long nowLedTime = millis();
  
  if(nowLedTime >= oldLedTime + timeLed) {
    oldLedTime = nowLedTime;
    state = !state;
    digitalWrite(LED_PIN_1, state);
  }
  
  if(nowLedTime >= oldLedTime + 500)
  {
    if (isButton1Pressed == 1)
    {
      isButton1Pressed = 0;
    }
    if (isButton2Pressed == 1)
    {
      isButton2Pressed = 0;
    }
  }
  
  if (digitalRead(BUTTON_PIN_1) == LOW) 
  {
    timeButton1 = millis();
    
    if ( (timeButton1 - timeButton2) <= 500)
    {
      digitalWrite(LED_PIN_1,HIGH);
      digitalWrite(LED_PIN_2,LOW);
      while(1);
    } 
    
    if(isButton1Pressed == 0)
    {
      timeLed = timeLed - 100;
      isButton1Pressed = 1;
      delay(100);
    }
    
  }
  if (digitalRead(BUTTON_PIN_2) == LOW)
  {
    timeButton2 = millis();
    
    if ( (timeButton2 - timeButton1) <= 500)
    {
      digitalWrite(LED_PIN_1,HIGH);
      digitalWrite(LED_PIN_2,LOW);
      while(1);
    } 
    
    if(isButton2Pressed == 0)
    {
      timeLed = timeLed + 100;
      isButton2Pressed = 1;
      delay(100);
    }
    
  }
}
