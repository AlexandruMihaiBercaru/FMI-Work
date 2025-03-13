#include <unistd.h>
#include <errno.h>			/* errno */
#include <stdlib.h>			/* atoi */
#include <stdio.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/mman.h>		/* */
#include <sys/stat.h>        /* S_IRUSR, S_IWUSR*/
#include <fcntl.h>           /* O_CREAT, O_RDWR */


int main(int argc, char*argv[])
{
	char shm_name[] = "collatz";
	int shm_fd;

	// se creeaza obiectul de memorie partajata enumit "collatz", este deschis pentru scriere si citire
	// ofer drepturi de scriere si citire doar userului care l-a creat

	shm_fd = shm_open(shm_name, O_CREAT|O_RDWR, S_IRUSR|S_IWUSR);
	if(shm_fd < 0){
		perror("Eroare la crearea ob. mem. partaj.\n");
		return errno;
	}
	
	//dimensiunea memoriei incarcate in spatiul procesului
	//trebuie sa fie multiplu de dimensiunea paginii

	int page_dim = getpagesize(); 

	// dimensiunea totala a obiectului de memorie va fi dim pagina * nr. de numere
	// fiecarui proces copil ii va reveni un spatiu egal cu dimensiunea unei pagini
	// in care sa scrie sirul collatz

	size_t sharedmem_size = (argc-1) * page_dim;
	if(ftruncate(shm_fd, sharedmem_size) == -1){
		perror("Eroare ftruncate");
		shm_unlink(shm_name);
		return errno;
	}

	printf("Starting parent %d \n", getpid());

	for(int i = 1; i < argc; i++)
	{
		//creez procesul copil
		pid_t pid = fork();

		if (pid < 0){
			perror("Nu s-a creat procesul copil");
			return errno;
		}
		else if(pid == 0)
		{
			// incarc in spatiul procesului memoria partajata alocata fiecarui copil
			// mem_copil -> pointer catre inceputul acelei zone de memorie
			// offsetul == (i-1) * page_dim (de unde din memoria partajata sa incarc)

			char *mem_copil = mmap(0, page_dim, PROT_WRITE, MAP_SHARED, shm_fd, (i-1) * page_dim);
			if(mem_copil == MAP_FAILED){
				perror("Map failed...(copil)");
				shm_unlink(shm_name);
				return errno;
			}

			int nr = atoi(argv[i]);
			// sprintf -> scriu direct in memorie 

			mem_copil += sprintf(mem_copil, "%d: ", nr);
        		while(nr > 1){
                	if(nr % 2 == 0){
                        	nr =nr / 2;
                	}
                	else{
                        	nr = 3 * nr + 1;
                	}
                	mem_copil += sprintf(mem_copil, "%d ", nr);
        		}
        		mem_copil += sprintf(mem_copil, "\n"); 
			printf("Done - Parent PID = %d   Child PID = %d\n", getppid(), getpid());

			// elimin din spatiul procesului memoria partajata
			munmap(mem_copil, page_dim);

			// omor copilul
			return 0;
		}
	}

	//parintele trebuie sa astepte fiecare proces copil
	for(int i = 1; i < argc; i++)
		wait(NULL);


	// incarc memoria, de data asta ca sa citesc din ea, de la offset 0, de dimensiune sharedmem_size
	char *mem_parinte = mmap(0, sharedmem_size, PROT_READ, MAP_SHARED, shm_fd, 0);

	if(mem_parinte == MAP_FAILED)
	{
		perror("Map failed....(parinte)");
		shm_unlink(shm_name);
		return errno;
	}
	
	// scriu la stdout ce am in bufferul mem_parinte
	write(1, mem_parinte, sharedmem_size);

	// eliberez spatiul din proces
	munmap(mem_parinte, page_dim);

	printf("\nDone (original process)- Parent PID = %d   My PID = %d\n", getppid(), getpid());

	// sterg obiectul de memorie
	shm_unlink(shm_name);
	return 0;
}

