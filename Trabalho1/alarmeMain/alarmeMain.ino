#include "pindefs.h"
//#include "ledControl.h"
#include "runTime.h"
//#include "buttonControl.h"

void pinSetup ()
{
   pinMode (LED1, OUTPUT);
   pinMode (LED2, OUTPUT);
   pinMode (LED3, OUTPUT);
   pinMode (LED4, OUTPUT);

   pinMode (KEY1, INPUT_PULLUP);
   pinMode (KEY2, INPUT_PULLUP);
   pinMode (KEY3, INPUT_PULLUP);

   pinMode (BUZZER, OUTPUT);

   /* Set DIO pins to outputs */
   pinMode(LATCH_DIO,OUTPUT);
   pinMode(CLK_DIO,OUTPUT);
   pinMode(DATA_DIO,OUTPUT);
}

void ledSetup ()
{
  digitalWrite(LED1,1);
  digitalWrite(LED2,1);
  digitalWrite(LED3,1);
  digitalWrite(LED4,1);
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  
  pinSetup ();
  ledSetup();
  digitalWrite(BUZZER, 1);
  initialTime ();
  initLedControl();

  variableSetup();
}

void loop() {
  // put your main code here, to run repeatedly:
  
  runWriteTime ();

  checkButton (KEY1);
  checkButton (KEY2);
  checkButton (KEY3);

  changeStates ();

  ledsOn ();

  changeTimeOrAlarm ();

  checkAlarmOut ();
}
