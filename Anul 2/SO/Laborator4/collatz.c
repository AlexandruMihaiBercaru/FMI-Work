#include <sys/types.h> // fork
#include <unistd.h> // getpid 
#include <stdio.h> // sscanf, printf
#include <errno.h> // errno
#include <sys/wait.h> // wait 

int main(int argc, char**argv)
{
	int numar;
	sscanf(argv[1], "%d", &numar);
	pid_t pid = fork();
    if(pid < 0)
	{
		perror("Eroare la crearea procesului copil");
    	return errno;
    }
	if(pid == 0) // in copil -> collatz
	{
		printf("Child created, PID = %d\n------COLLATZ-------\n", getpid());
		printf("%d: %d  ", numar, numar);
		while(numar != 1){
			if(numar % 2 == 0)
				numar = numar / 2;
			else
				numar = 3 * numar + 1;
			printf("%d  ", numar);
		}
		
	}
	else{
		wait(NULL);
		printf("\n-------END COLLATZ------\nChild %d finished.\n", pid);
	}

}
