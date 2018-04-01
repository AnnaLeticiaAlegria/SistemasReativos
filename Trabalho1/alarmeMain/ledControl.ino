#include "pindefs.h"
//#include "ledControl.h"

int firstLedTime;
int state;
double initialLEDTime;

void initLedControl (void)
{
  isTimeChange = 0;
  isTimeChangeMinuts = 0;
  isTimeChangeHours = 0;
  isAlarmChange = 0;
  isAlarmOn = 0;
  isAlarmPlaying = 0;
  isNapTime = 0;
  state = 1;
  firstLedTime = 0;
}

void ledsOn (void)
{
  if (isTimeChange == 1)
  {
    if (isTimeChangeHours == 0)
    {
      if (firstLedTime == 0)
      {
        initialLEDTime = millis();
        firstLedTime = 1;
      }
      if ((millis() - initialLEDTime) > 500)
      {
        digitalWrite(LED1, !state);
        state = !state;
        initialLEDTime = millis();
      }
    }
    else
    {
      if (isTimeChangeMinuts == 0)
      {
        digitalWrite(LED1, 0);
        if ((millis() - initialLEDTime) > 500)
        {
          digitalWrite(LED2, !state);
          state = !state;
          initialLEDTime = millis();
        }
      }
      else
      {
        digitalWrite(LED1, 0);
        digitalWrite(LED2, 0);
        if ((millis() - initialLEDTime) > 500)
        {
          digitalWrite(LED3, !state);
          state = !state;
          initialLEDTime = millis();
        }
      }
    }
  }
  else
  {
    if (isAlarmChange == 1)
    {
      if (isTimeChangeHours == 0)
      {
        if (firstLedTime == 0)
        {
          initialLEDTime = millis();
          firstLedTime = 1;
        }
        if ((millis() - initialLEDTime) > 500)
        {
          digitalWrite(LED3, !state);
          state = !state;
          initialLEDTime = millis();
        }
      }
      else
      {
        if (isTimeChangeMinuts == 0)
        {
          digitalWrite(LED3, 0);
          if ((millis() - initialLEDTime) > 500)
          {
            digitalWrite(LED1, !state);
            state = !state;
            initialLEDTime = millis();
          }
        }
        else
        {
          digitalWrite(LED1, 0);
          digitalWrite(LED3, 0);
          if ((millis() - initialLEDTime) > 500)
          {
            digitalWrite(LED2, !state);
            state = !state;
            initialLEDTime = millis();
          }
        }
      }
    }
    else
    {
      firstLedTime = 0;
      digitalWrite(LED1, 1);
      digitalWrite(LED2, 1);
      digitalWrite(LED3, 1);
    }
  }

  if (isAlarmOn == 0)
  {
    digitalWrite(LED4, 1);
  }
  else
  {
    digitalWrite(LED4, 0);
  }
}
