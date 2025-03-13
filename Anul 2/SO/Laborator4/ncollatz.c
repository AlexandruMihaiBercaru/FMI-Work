#include <sys/types.h> // fork
#include <unistd.h> // getpid, getppid
#include <stdio.h> // printf
#include <errno.h> // errno
#include <stdlib.h> // atoi
#include <sys/wait.h> // wait


int main(int argc, char**argv) 
{
	printf("Starting parent %d.\n", getpid());
	for(int j = 1; j <= argc - 1; j++)
	{
		pid_t pid = fork(); //creez copil
		if(pid < 0)
		{
			perror("Eroare la crearea copilului");
			return errno;
		}
		else if(pid == 0) // in copil -> collatz
        {
			int numar;
			numar = atoi(argv[j]);
			printf("%d: %d  ", numar, numar);
            while(numar != 1)
			{
            	if(numar % 2 == 0)
                    numar = numar/ 2;
                else
                    numar = 3 * numar + 1;
                printf("%d  ", numar);
			}
			//afisez din copil mesajul ca s-a finalizat collatz
			printf("\nDone. Parent %d, Me %d\n", getppid(), getpid());

			//ca sa ma intorc in parinte
			return 1;
		}

       
    }
	//parintele trebuie sa astepte terminarea executiei fiecarui copil
	for(int j = 1; j <= argc - 1; j++)
	{
		wait(NULL);
	}

	printf("\nDone. Parent %d, Me %d\n", getppid(), getpid());
	return 0;
}

