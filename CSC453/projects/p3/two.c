/* two.c */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv)
{
   char buf[1024];
   int cnt, i;

   cnt = atol(argv[1]);

   sprintf(buf, "%%%dd\n", 8*cnt);
   for(i = 0; i < cnt; i++)
   {
      printf(buf, cnt);
      fflush(stdout);
      sleep(1);
   }
   return 0;
}
