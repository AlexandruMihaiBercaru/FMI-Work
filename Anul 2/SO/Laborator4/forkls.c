#include <sys/types.h> // fork()
#include <unistd.h> // execve()
#include <stdio.h> // sscanf, printf
#include <errno.h> // errno
#include <sys/wait.h> // wait 

int main()
{
	//On  success, the PID of the child process is returned in the parent
	//pe ramura pid > 0 -> PID-ul actual al copilului
	pid_t pid = fork();
	if(pid < 0){
		perror("Eroare la crearea procesului copil");
		return errno;
	}
	else{
		//in copil
		if(pid == 0)
		{
			//afisez pid parinte, pid copil
			printf("My PID= %d  Child PID= %d\n\n", getppid(), getpid());

			//lista argumente
			char *argv[] = {"ls", NULL};
			printf("Continut folder:\n");
			
			//suprascriu procesul copil cu procesul "ls"
            execve("/usr/bin/ls", argv, NULL);
	
            printf("Child %d finished.\n", getpid());
			perror("Eroare execve");
		}
		//in parinte
		else
		{
			wait(NULL);
			//in variabila pid am PID-ul copilului
			printf("\nS-a incheiat procesul copil, PID = %d\n", pid);
		}
	}
}
