#include <pthread.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>


//char* mystring;
void *reverse(void *arg)
{
	char* myrevstring = (char*) arg;
	int first = 0;
    	int last = strlen(myrevstring) - 1;
    	char temp;
	while (first < last) {
        	temp = myrevstring[first];
       		myrevstring[first] = myrevstring[last];
        	myrevstring[last] = temp;
        	first++;
        	last--;
    	}
	//strcpy(mystring, myrevstring);
	// pthread_exit inchide threadul si returneaza o valoare prin argument 
	// valoarea este preluata la pthread_join
	pthread_exit(myrevstring);
}

int main(int argc, char **argv)
{
	char* mystring = malloc(sizeof(char) * 1024);
	void * retval;

	strcpy(mystring, argv[1]);
	pthread_t thr_rev;

	//creez thread
	if(pthread_create(&thr_rev, NULL, reverse, mystring)){
		perror("Eroare la crearea threadului");
		return errno;
	}

	//astept finalizarea threadului
	if(pthread_join(thr_rev, &retval))
	{
		perror("Eroare la thread_join");
		return errno;
	}
	printf("Cuvantul inversat: %s\n", (char*)retval);

	free(mystring);
}
