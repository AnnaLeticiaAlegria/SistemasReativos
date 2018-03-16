#include "event_driven.h"
#include "app.h"
#include "pindefs.h"

void appinit(void) 
{
  button_listen (BUTTON_PIN_2);
  
  timer_set (2000);
}

void button_changed(int p, int v)
{
   digitalWrite(p, v);
}

void timer_expired(void)
{
  digitalWrite(LED_PIN_1,timerState);
  digitalWrite(LED_PIN_2,timerState);
  digitalWrite(LED_PIN_3,timerState);
}
