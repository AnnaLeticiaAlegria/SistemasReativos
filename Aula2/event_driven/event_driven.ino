#include "event_driven.h"
#include "app.h"
#include "pindefs.h"

int isButtonListener1;
int isButtonListener2;
int isButtonListener3;

int isTimeListener;
int isTimeExpired;
unsigned long startTime;
unsigned long endTime;
int state;
int timerState;

void setup() 
{
  // put your setup code here, to run once:

  isButtonListener1 = 0;
  isButtonListener2 = 0;
  isButtonListener3 = 0;
  
  isTimeListener = 0;
  isTimeExpired = 0;
  
  state = 0;
  timerState = 0;
  startTime = millis();
  
  digitalWrite(LED_PIN_1,LOW);
  digitalWrite(LED_PIN_2,LOW);
  digitalWrite(LED_PIN_3,LOW);
  
  appinit();
  
  Serial.begin(9600);
}

void button_listen (int pin)
{
   if (pin == BUTTON_PIN_1)
   {
     isButtonListener1 = 1;
   } 
   else
   {
     if (pin == BUTTON_PIN_2)
     {
       isButtonListener2 = 1;
     }
     else
     {
       isButtonListener3 = 1;
     }
   }
}

void timer_set (int ms)
{
   isTimeListener = 1;
   endTime = ms;
}

void loop() 
{
  // put your main code here, to run repeatedly:
 
  
  if (isButtonListener1)
  {
    if(digitalRead(BUTTON_PIN_1))
    {
      button_changed(LED_PIN_1, state);
      state = !state;
      
      Serial.println("LED1");
    }
  }
  
  if (isButtonListener2)
  {
    if(digitalRead(BUTTON_PIN_2))
    {
      button_changed(LED_PIN_2, state);
      state = !state;
      
      Serial.println("LED2");
    }
  }
  
  if (isButtonListener3)
  {
    if(digitalRead(BUTTON_PIN_3))
    {
      button_changed(LED_PIN_3, state);
      state = !state;
      
      Serial.println("LED3");
    }
  }
  
  if (isTimeListener)
  {
    unsigned long newTime = millis();
    if ( (newTime - startTime) >= endTime)
    {
      isTimeExpired = 1;
      startTime = newTime;
      timerState = !timerState;
      timer_expired();
      
      Serial.println("Time expired");
    }
  }
  
}
