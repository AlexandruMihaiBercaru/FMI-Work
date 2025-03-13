#include <sys/stat.h>
#include <stdio.h>
#include <errno.h>

int main(){
struct stat sb;
if(stat("test.c", &sb))
{	perror("test.c");
	return errno;
}
printf("test takes %jd bytes on disk \n", sb.st_size);
}
