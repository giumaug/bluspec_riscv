#include <stdio.h>

char in[10];
char out[10];

int main (int argc, const char * argv[]) 
{
	while (gets(in)) 
	{
		//printf("in %s \n" , in);
		out[1] = in[7];
		out[0] = in[6];
		out[3] = in[5];
		out[2] = in[4];
		out[5] = in[3];
		out[4] = in[2];
		out[7] = in[1];
		out[6] = in[0];
		out[8] = '\0';
		//printf("out %s \n" , out);
		printf("%s \n" , out);
	}
}

