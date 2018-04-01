#include "pindefs.h"
#include "buttonControl.h"
#include "ledControl.h"

double firstPress1, firstHold1, firstPress2, firstHold2, firstPress3, firstHold3;
double stateControlHour;
double alarmOnControl;
int firstStateControlHour;
int firstAlarmOnControl;

void variableSetup (void)
{ 
  countTime1 = 0; 
  countTime2 = 0;
  countTime3 = 0;
  firstStateControlHour = 0;
  firstAlarmOnControl = 0;
}
    
void checkButton (int button)
{
    if(!digitalRead(button))
    {
       switch (button)
       {
          case KEY1:
          {
            if(countTime1 == 0)
            {
              firstHold1 = millis();
              countTime1 = 1;
            }
            
            if(button1Pressed == 0)
            {
              button1Pressed = 1;
              firstPress1 = millis();
              Serial.println("button1Pressed");
            }
            else
            {
              if( (millis() - firstPress1) > 500) //tratando  o debounce
              {
                 button1Pressed = 0;
                 firstPress1 = millis();
              }
            }
            if( (millis() - firstHold1) > 2000) //pressiona por 2 segundos
            {
              if(button1Hold == 0)
              {
                button1Hold = 1;
                firstHold1 = millis();
                Serial.println("button1Hold");
              }
            }
            if( (millis() - firstHold1) > 500 && button1Hold == 1) //tratando  o debounce
            {
               button1Hold = 0;
               firstHold1 = millis();
            }
          }
          break;
          case KEY2:
          {
            if(countTime2 == 0)
            {
              firstHold2 = millis();
              countTime2 = 1;
            }
            
            if(button2Pressed == 0)
            {
              button2Pressed = 1;
              firstPress2 = millis();
              Serial.println("button2Pressed");
            }
            else
            {
              if( (millis() - firstPress2) > 500) //tratando  o debounce
              {
                 button2Pressed = 0;
                 firstPress2 = millis();
              }
            }
            if( (millis() - firstHold2) > 2000) //pressiona por 2 segundos
            {
              if(button2Hold == 0)
              {
                button2Hold = 1;
                firstHold2 = millis();
                Serial.println("button2Hold");
              }
            }
            if( (millis() - firstHold2) > 500 && button2Hold == 1) //tratando  o debounce
            {
               button2Hold = 0;
               firstHold2 = millis();
            }
          }
          break;
          case KEY3:
          {
            if(countTime3 == 0)
            {
              firstHold3= millis();
              countTime3 = 1;
            }
            
            if(button3Pressed == 0)
            {
              button3Pressed = 1;
              firstPress3 = millis();
              Serial.println("button3Pressed");
            }
            else
            {
              if( (millis() - firstPress3) > 500) //tratando  o debounce
              {
                 button3Pressed = 0;
                 firstPress3 = millis();
              }
            }
            if( (millis() - firstHold3) > 2000) //pressiona por 2 segundos
            {
              if(button3Hold == 0)
              {
                button3Hold = 1;
                firstHold3 = millis();
                Serial.println("button3Hold");
              }
            }
            if( (millis() - firstHold3) > 500 && button3Hold == 1) //tratando  o debounce
            {
               button3Hold = 0;
               firstHold3 = millis();
            }
          }
          break;
          default:
            break;
       }
    }
    else
    {
      switch(button)
      {
        case KEY1:
        {
          countTime1 = 0; 
          button1Pressed = 0;
          button1Hold = 0;
        }
        break;
        case KEY2:
        {
          countTime2 = 0; 
          button2Pressed = 0;
          button2Hold = 0;
        }
        break;
        case KEY3:
        {
          countTime3 = 0; 
          button3Pressed = 0;
          button3Hold = 0;
        }
        break;
        default:
          break;
      }
    }
}

void changeStates (void)
{
  if(button1Hold == 1 && button2Hold == 0 && button3Hold == 0 && button2Pressed == 0 && button3Pressed == 0 && isAlarmChange == 0)
  {
    isTimeChange = 1;
    isAlarmChange = 0;
  }

  if( (isTimeChange == 1 || isAlarmChange == 1) && button2Hold == 1 && button3Hold == 0 && button3Pressed == 0)
  {
    isTimeChangeHours = 1;
    if(firstStateControlHour == 0)
    {
      stateControlHour = millis();
      firstStateControlHour = 1;
    }
  }

  if((isTimeChange == 1 || isAlarmChange == 1) && isTimeChangeHours == 1 && button2Hold == 1 && button3Hold == 0 && button3Pressed == 0 && (millis() - stateControlHour) > 500)
  {
    isTimeChangeMinuts = 1;
    stateControlHour = millis();
  }

  if(isTimeChange == 0 && button3Hold == 1 && button1Hold == 0 && button2Hold == 0 && button1Pressed == 0 && button2Pressed == 0)
  {
    isTimeChange = 0;
    isAlarmChange = 1;
  }

  if(isTimeChange == 0 && isAlarmChange == 0 && button2Hold == 1 && button3Hold == 0 && button3Pressed == 0 && button1Hold == 0 && button1Pressed == 0)
  {
    if(firstAlarmOnControl == 0)
    {
      alarmOnControl = millis();
      firstAlarmOnControl = 1;
    }
    if ( (millis() - alarmOnControl) > 500)
    {
      isAlarmOn = !isAlarmOn;
      alarmOnControl = millis();
      firstAlarmOnControl = 0;
    }
  }

  if(isAlarmPlaying == 1 && button1Pressed == 1 && button3Pressed == 1 && button2Pressed == 0 && button2Hold == 0)
  {
    napTime();
  }
}

