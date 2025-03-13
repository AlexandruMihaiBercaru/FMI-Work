#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h> // read, write
#include <errno.h>
#include <fcntl.h> // open, flags
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char**argv){
	if (argc != 3)
	{
		printf("Eroare - numar gresit de argumente.\n");
		return -1;
	}

	//deschid primul fisier si verific sa se fi deschis corect
	int fd1 = open(argv[1], O_RDONLY);
	if (fd1 < 0)
	{
		perror("Eroare la deschiderea primului fisier.\n");
		return errno;
	}
	// daca nu exista fisierul de la argv[1], returneaza eroarea
	// "no such file or directory"

	// deschid al doilea fisier si verific sa se fi deschis corect
	// S_IRWXU -> 0666 (read write execute)
	int fd2 = open(argv[2], O_CREAT | O_WRONLY, S_IRWXU);
	if (fd2 < 0)
	{
		perror("Eroare la deschiderea celui de-al doilea fisier.\n");
		return errno;
	}

	// apelul din conditia if intoarce in stats informatii despre fisierul din argv[1]
	struct stat stats;
	if(stat(argv[1], &stats)){
		perror("Eroare fisier 1");
		return errno;
	}

	int file_len = stats.st_size;
	int actual_bytes = 0;
	//buffer de dimensiunea fisierului
	char *cont_fisier = (char*)malloc(sizeof(char) * file_len);
	int nread;
	//nread = nr bytes cititi

	//citesc din fd1 in buffer atatia bytes cati imi indica al 3-lea argument

	while(nread = read(fd1, cont_fisier, file_len - actual_bytes))
	{
		//scriu in fd1 ce am in buffer
		int nwrite = write(fd2, cont_fisier, nread);
		if (nwrite < 0)
		{
			perror("Eroare la scrierea in al doilea fisier");
			return errno;
		}
		printf("S-au citit %d bytes din file1 si s-au scris %d bytes in file2", nread, nwrite);
		actual_bytes = nread;
	}

	close(fd1);
	close(fd2);
	printf("Copiere finalizata.\n");
}



// int stat ( const char * path , struct stat * sb );
// intoarce informatii despre fisierul din path in stats buffer (sb)


/*
struct stat {
dev_t    st_dev ; 			/*
ino_t    st_ino ; 			/*
mode_t   st_mode ; 			/*
nlink_t  st_nlink ; 		/*
uid_t    st_uid ; 			/* user ID of the file ’ s owner
gid_t    st_gid ; 			/*
dev_t    st_rdev ; 			/*
struct timespec st_atim ;
struct timespec st_mtim ;
struct timespec st_ctim ;
off_t     st_size ; 		/*  file size , in bytes
blkcnt_t  st_blocks ; 		/*  blocks allocated for file
blksize_t st_blksize ;		/*
u_int32_t st_flags ; 		/* user defined flags for file
u_int32_t st_gen ;   		/* file generation number
};
*/