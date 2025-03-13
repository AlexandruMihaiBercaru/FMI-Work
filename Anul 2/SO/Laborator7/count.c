//gestionarea accesului la un numar finit de resurse

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
//#include <unistd.h>

# define MAX_RESOURCES 5
int available_resources = MAX_RESOURCES;

pthread_mutex_t mutex;

//cand un thread doreste sa obtina un numar `count`
//de resurse, apeleaza metoda decrease_count

int decrease_count (int count)
{
    //lock
    pthread_mutex_lock(&mutex);
    if (available_resources < count)
    {
        printf("Too few resources - release them!!! (Need %d, has %d available)\n", count, available_resources);
        pthread_mutex_unlock(&mutex);
        return -1;

    } 
    else
    {
        printf("Took %d resources, %d remaining\n", count, available_resources-count);
        available_resources -= count;
        pthread_mutex_unlock(&mutex);
        return 0;
    }
    //pthread_mutex_unlock(&mutex);
}

//cand resursele nu mai sunt necesare, apeleaza increase_count

int increase_count(int count)
{
    // lock
    // vreau ca un singur thread sa poata incrementa la un moment dat
    pthread_mutex_lock(&mutex);
    printf("Released %d resources, %d remaining\n", count, available_resources + count);
    available_resources += count;

    //unlock
    pthread_mutex_unlock(&mutex);
    return 0;
}

void* increase_decrease (void *args)
{
    int* argument = (int*) args;
    int count = *argument;
    int take_resources = decrease_count(count);
    if(take_resources < 0)
    {
        increase_count(count);
    }
    pthread_exit(NULL);

}

int main(int argc, char * argv[])
{
    printf("Max resources: %d\n", available_resources);
    //initializez variabila mutex

    if(pthread_mutex_init(&mutex, NULL))
    {
        perror("Eroare la initializarea mutex!!!\n");
        return errno;
    }

    int num_threads = 10;
    pthread_t threads[num_threads];

    //creez threaduri care sa apeleze rutina increase_decrease
    for(int i = 0; i < num_threads; i++)
    {
        int* arg = malloc(sizeof (int));
        *arg = i % 3 + 1;
        if(pthread_create(&threads[i], NULL, increase_decrease, arg))
        {
            perror("Eroare la crearea thread-urilor!!!!\n");
            return errno;
        }
    }

    for(int i = 0; i < num_threads; i++)
    {
        if(pthread_join(threads[i], NULL)){
            perror("Eroare la join threads!!!\n");
            return errno;
        }
    }

    printf("\nEnd of threads execution.\n");

    pthread_mutex_destroy(&mutex);
    return 0;
}