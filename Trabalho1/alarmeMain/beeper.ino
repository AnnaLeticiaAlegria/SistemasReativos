#include "beeper.h"
#include "pindefs.h"

int firstStartMusic, musicState;
double startMusicTime;

void playMusic (int number)
{
  switch (number)
  {
    case 1:
    {
      defaultMusic();
    }
    break;
    default:
    break;
  }
}

void defaultMusic ()
{
  if(firstStartMusic == 0)
  {
    musicState = 0;
    digitalWrite(BUZZER,0);
    firstStartMusic = 1;
    startMusicTime = millis();
  }

  if( (millis() - startMusicTime) > 2000 )
  {
    musicState = !musicState;
    digitalWrite(BUZZER,musicState);
    startMusicTime = millis();
  }
  
  //tone(BUZZER,220,500);
  //tone(BUZZER,0,1000);
  //tone(BUZZER, 0, 2000);
}

