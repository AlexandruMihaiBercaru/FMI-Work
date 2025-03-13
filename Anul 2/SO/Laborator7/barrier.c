#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <semaphore.h>

#define NO_THREADS 5

pthread_mutex_t mutex;
sem_t semaphore;

//count - variabila care numara apelurile barrier_point
int count;

void barrier_point()
{
    pthread_mutex_lock(&mutex);
        count--;
    //pthread_mutex_unlock(&mutex);

    if(count == 0)
    {
        pthread_mutex_unlock(&mutex);
        sem_post(&semaphore);
    }
    pthread_mutex_unlock(&mutex);
    sem_wait(&semaphore);
    sem_post(&semaphore);

}

void* tfun (void* arg){
    int* thread_id = (int* ) arg;
    printf("%d reached the barrier\n", *thread_id);
    barrier_point();
    printf("%d passed the barrier\n", *thread_id);

    free(thread_id);
    return NULL;
}

int main(int argc, char* argv[])
{
    pthread_t threads[NO_THREADS];
    count = NO_THREADS;

    if(sem_init(&semaphore, 0, 0)){
        perror("Eroare la initializarea semafor");
        return errno;
    }

    if(pthread_mutex_init(&mutex, NULL))
    {
        perror("Eroare la initializarea mutex\n");
        return errno;
    }

    for(int i = 0; i < NO_THREADS; i++)
    {
        int* arg = malloc(sizeof (int));
        *arg = i;
        if(pthread_create(&threads[i], NULL, tfun, arg))
        {
            perror("Eroare la crearea thread-urilor!!!!\n");
            return errno;
        }
    }

    for(int i = 0; i < NO_THREADS; i++)
    {
        if(pthread_join(threads[i], NULL)){
            perror("Eroare la join threads!!!\n");
            return errno;
        }
    }

    sem_destroy(&semaphore);
    pthread_mutex_destroy(&mutex);
    return 0;
}