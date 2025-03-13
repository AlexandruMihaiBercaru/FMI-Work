#include <unistd.h>
#include <stdio.h> // perror
#include <errno.h> // errno 
int main()
{
	size_t nbytes = 15;
	int fd = 1;
	//1 - stdout
	const void *buff = "Hello, World!\n";
	ssize_t nwrite = write(fd, buff, nbytes);
	if (nwrite < 0)
	{
		perror("Eroare la scriere!\n");
		return errno;
	}

}
