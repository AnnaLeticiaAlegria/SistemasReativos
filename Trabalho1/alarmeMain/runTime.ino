#include "pindefs.h"
#include "beeper.h"

/* Segment byte maps for numbers 0 to 9 */
const byte SEGMENT_MAP[] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0X80, 0X90};
/* Byte maps to select digit 1 to 4 */
const byte SEGMENT_SELECT[] = {0xF1, 0xF2, 0xF4, 0xF8};

/* Run Time definitions*/
int currentTime [4];
double initArdTime;

/* Change Time definitions*/
int firstTimeDef;
int firstTimeDefHour;
int firstTimeDefMinut;
int firstAddHourTime;
int firstDecHourTime;
int firstAddMinutTime;
int firstDecMinutTime;
double initChangeTime;
double addHourTime;
double decHourTime;
double addMinutTime;
double decMinutTime;

/* Alarm Time definitions*/
int alarmTime [4];
double initChangeAlarm;
int firstMusicPlay;
int firstNapTime;

/* Write a decimal number between 0 and 9 to one of the 4 digits of the display */
void WriteNumberToSegment(byte Segment, byte Value)
{
  digitalWrite(LATCH_DIO, LOW);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_MAP[Value]);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_SELECT[Segment] );
  digitalWrite(LATCH_DIO, HIGH);
}

void initialTime (void)
{
  int i;

  for (i = 0; i < 4; i++)
  {
    WriteNumberToSegment(i, 0);
    currentTime[i] = 0;
    alarmTime[i] = 0;
  }
  initArdTime = millis();
  firstTimeDef = 0;
  firstTimeDefHour = 0;
  firstTimeDefMinut = 0;
  firstMusicPlay = 0;
}

void runWriteTime (void)
{
  int i;
  if (millis() - initArdTime > 60000 && isTimeChange == 0) // se passou 60 segundos
  {
    addMinut(currentTime);

    initArdTime = millis();
  }
  for (i = 0; i < 4; i++)
  {
    if (isAlarmChange == 0)
    {
      WriteNumberToSegment(i, currentTime[i]);
    }
    else
    {
      WriteNumberToSegment(i, alarmTime[i]);
    }
  }
}

void addHour (int * timeOrAlarm)
{
  timeOrAlarm[1] ++;
  if (timeOrAlarm[1] > 9)
  {
    timeOrAlarm[0] ++;
    timeOrAlarm[1] = 0;
  }
  if (timeOrAlarm[0] == 2 && timeOrAlarm[1] == 4)
  {
    timeOrAlarm[0] = 0;
    timeOrAlarm[1] = 0;
  }
}

void addMinut(int * timeOrAlarm)
{
  timeOrAlarm[3] ++;

  if (timeOrAlarm[3] > 9)
  {
    timeOrAlarm[2] ++;
    timeOrAlarm[3] = 0;
  }
  if (timeOrAlarm[2] > 5)
  {
    addHour (timeOrAlarm);
    timeOrAlarm[2] = 0;
  }
}

void decHour (int * timeOrAlarm)
{
  timeOrAlarm[1] --;
  if (timeOrAlarm[1] < 0)
  {
    timeOrAlarm[0] --;
    timeOrAlarm[1] = 9;
  }
  if (timeOrAlarm[0] < 0)
  {
    timeOrAlarm[0] = 2;
    timeOrAlarm[1] = 3;
  }
}

void decMinut(int * timeOrAlarm)
{
  timeOrAlarm[3] --;

  if (timeOrAlarm[3] < 0)
  {
    timeOrAlarm[2] --;
    timeOrAlarm[3] = 9;
  }
  if (timeOrAlarm[2] < 0)
  {
    decHour(timeOrAlarm);
    timeOrAlarm[2] = 5;
    timeOrAlarm[3] = 9;
  }
}

void changeTime (int * timeOrAlarm)
{
  if ((*timeOrAlarm) == 1)
  {
    if (firstTimeDef == 0)
    {
      firstTimeDef = 1;
      initChangeTime = millis();
      Serial.println("FirstTimeDef");
    }

    if ( ((millis() - initChangeTime) > 5000 && isTimeChangeHours == 0 && button2Pressed == 0)) //tem 5 segundos para apertar outro botao
    {
      (*timeOrAlarm) = 0;
      isTimeChangeHours = 0;
      isTimeChangeMinuts = 0;
      firstStateControlHour = 0;
      firstTimeDef = 0;
      firstTimeDefHour = 0;
      Serial.println("-TimeOutChange");

      return;
    }

    if (isTimeChangeHours == 1)
    {
      if (firstTimeDefHour == 0)
      {
        firstTimeDefHour = 1;
        firstAddHourTime = 0;
        firstDecHourTime = 0;
        initChangeTime = millis();
        Serial.println("FirstTimeDefHour");
      }
      if ( (millis() - initChangeTime) > 5000 && isTimeChangeMinuts == 0) //tem 5 segundos para apertar outro botao
      {
        (*timeOrAlarm) = 0;
        isTimeChangeHours = 0;
        isTimeChangeMinuts = 0;
        firstStateControlHour = 0;
        firstTimeDef = 0;
        firstTimeDefHour = 0;
        Serial.println("-TimeOutChangeHour");
        return;
      }

      if (button1Pressed && isTimeChangeMinuts == 0)
      {
        if (firstAddHourTime == 0)
        {
          if (isTimeChange == 1)
          {
            addHour(currentTime);
          }
          if (isAlarmChange == 1)
          {
            addHour(alarmTime);
          }
          addHourTime = millis();
          firstAddHourTime = 1;
        }
        if ( (millis() - addHourTime) > 300 )
        {
          if (isTimeChange == 1)
          {
            addHour(currentTime);
          }
          if (isAlarmChange == 1)
          {
            addHour(alarmTime);
          }
          addHourTime = millis();
        }
        initChangeTime = millis();
      }
      if (button3Pressed && isTimeChangeMinuts == 0)
      {
        if (firstDecHourTime == 0)
        {
          if (isTimeChange == 1)
          {
            decHour(currentTime);
          }
          if (isAlarmChange == 1)
          {
            decHour(alarmTime);
          }
          decHourTime = millis();
          firstDecHourTime = 1;
        }
        if ( (millis() - decHourTime) > 300 )
        {
          if (isTimeChange == 1)
          {
            decHour(currentTime);
          }
          if (isAlarmChange == 1)
          {
            decHour(alarmTime);
          }
          decHourTime = millis();
        }
        initChangeTime = millis();
      }

      if (isTimeChangeMinuts == 1)
      {
        if (firstTimeDefMinut == 0)
        {
          firstTimeDefMinut = 1;
          firstAddMinutTime = 0;
          firstDecMinutTime = 0;
          initChangeTime = millis();
          Serial.println("FirstTimeDefMinut");
        }
        if ( (millis() - initChangeTime) > 5000) //tem 5 segundos para apertar outro botao
        {
          (*timeOrAlarm) = 0;
          isTimeChangeHours = 0;
          isTimeChangeMinuts = 0;
          firstStateControlHour = 0;
          firstTimeDef = 0;
          firstTimeDefHour = 0;
          firstTimeDefMinut = 0;
          Serial.println("-TimeOutChangeMinut");
          return;
        }

        if (button1Pressed)
        {
          if (firstAddMinutTime == 0)
          {
            if (isTimeChange == 1)
            {
              addMinut(currentTime);
            }
            if (isAlarmChange == 1)
            {
              addMinut(alarmTime);
            }
            addMinutTime = millis();
            firstAddMinutTime = 1;
          }
          if ( (millis() - addMinutTime) > 300 )
          {
            if (isTimeChange == 1)
            {
              addMinut(currentTime);
            }
            if (isAlarmChange == 1)
            {
              addMinut(alarmTime);
            }
            addMinutTime = millis();
          }
          initChangeTime = millis();
        }
        if (button3Pressed)
        {
          if (firstDecMinutTime == 0)
          {
            if (isTimeChange == 1)
            {
              decMinut(currentTime);
            }
            if (isAlarmChange == 1)
            {
              decMinut(alarmTime);
            }
            decMinutTime = millis();
            firstDecMinutTime = 1;
          }
          if ( (millis() - decMinutTime) > 300 )
          {
            if (isTimeChange == 1)
            {
              decMinut(currentTime);
            }
            if (isAlarmChange == 1)
            {
              decMinut(alarmTime);
            }
            decMinutTime = millis();
          }
          initChangeTime = millis();
        }
      }
    }
  }
}

void changeTimeOrAlarm (void)
{
  changeTime (&isTimeChange);
  changeTime (&isAlarmChange);
}

int isAlarmOut (void)
{
  int i;
  for(i=0;i<4;i++)
  {
    if(alarmTime[i] != currentTime[i])
    {
      return 0;
    }
  }
  return 1;
}

void checkAlarmOut (void)
{
  if(isAlarmOn == 1 && isAlarmChange == 0 && isTimeChange == 0)
  {
    if(isAlarmOut () == 1)
    {
      if(firstMusicPlay == 0)
      {
        firstStartMusic = 0;
        firstNapTime = 0;
        firstMusicPlay = 1;
      }
      playMusic (1);
      isAlarmPlaying = 1;
    }
    else
    {
      digitalWrite(BUZZER,1);
      firstMusicPlay = 0;
      firstStartMusic = 1;
      isAlarmPlaying = 0;
      isNapTime = 0;
    }
  }
  else
  {
    //noTone(BUZZER);
    digitalWrite(BUZZER,1);
    firstMusicPlay = 0;
    firstStartMusic = 1;
    isAlarmPlaying = 0;
    isNapTime = 0;
  }
}

void napTime (void)
{
  int i;
  if(firstNapTime == 0)
  {
     firstNapTime = 1;
     isNapTime = 1;
     for (i=0;i<5;i++)
     {
        addMinut(alarmTime);
     }
  }
}


