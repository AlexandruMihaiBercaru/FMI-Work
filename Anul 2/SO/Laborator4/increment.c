
#include <sys/types.h> // fork()
#include <unistd.h> // execve()
#include <stdio.h> // sscanf, printf
#include <errno.h> // errno
#include <sys/wait.h> // wait 

int main()
{
    int x = 0;
    if(!fork())
    {
        x++;
    }
    if(!fork())
    {
        x++;
    }
        printf("%d ", x);
}