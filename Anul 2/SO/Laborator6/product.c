#include <pthread.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

//la ele au acces toate threadurile
int a[100][100], b[100][100];

//functie pentru citirea din fisier
void readmatrix(int *nr_linii, int *nr_coloane, int ma[100][100], const char* filename)
{
   	FILE *file_pointer;
   	file_pointer = fopen (filename, "r");
    	if (file_pointer == NULL){
        	printf("Nu exista fisierul!");
	}
	fscanf(file_pointer, "%d %d", nr_linii, nr_coloane); 

    	for(int i = 0; i < *nr_linii; ++i)
    	{
        	for(int j = 0; j < *nr_coloane; ++j)
           	fscanf(file_pointer, "%d", ma[i] + j);
    	}
    	fclose(file_pointer); 
}

//rutina threadului nu poate primi decat un singur argument
//incapsulez intr-o structura toate datele necesare operatiilor
//din thread

struct Matrix
{
	int linie; // i
	int coloana; // j
	int dim; // dimensiunea comuna (numarul de produse din calcul)
};

void* multiply(void *args)
{
	struct Matrix* mArgs = (struct Matrix*)args;
	int *elem = (int*)malloc(sizeof(int));
	*elem = 0;
	
	//calculez elementul res[i][j] 
	//elem -> pointer pe care il returnez ca rezultat
	for(int k = 0; k < mArgs->dim; k++){
		*elem += a[mArgs->linie][k] * b[k][mArgs->coloana];
	}

	//incheie threadul care a fost apelat, argumentul functiei
	//va returna o valoare vizibila in procesul care apeleaza
	//threadul
	pthread_exit(elem);
}

int main()
{
	void* retval;
	int lin1, col1, lin2, col2;
	
	int res[100][100];

	//citesc si afisez la stdout matricile
	readmatrix(&lin1, &col1, a, "mat1.txt");
	for(int i = 0; i < lin1; i++)
	{
		for(int j = 0; j < col1; j++)
			printf("%d ", a[i][j]);

		printf("\n");
	}
	printf("\n");
	readmatrix(&lin2, &col2, b, "mat2.txt");
	for(int i = 0; i < lin2; i++)
	{
		for(int j = 0; j < col2; j++)
			printf("%d ", b[i][j]);

		printf("\n");
	}

	if(col1 != lin2)
	{
		printf("Nu se poate face inmultirea");
		return 0;
	}
	
	int nr_threads = lin1 * col2;
	//creez numarul necesar de threaduri (egal cu numarul de elemente)
	//al matricei rezultat
	pthread_t calc_element[nr_threads];

	int crrt_thr = 0;
	for(int i = 0; i < lin1; i++)
	{
		for(int j = 0; j < col2; j++)
		{
			
			//creez structura prin care trimit datele in argumentul rutinei
			struct Matrix *arg=(struct Matrix* )malloc(sizeof(struct Matrix));
			arg->linie = i;
			arg->coloana = j;
			arg->dim = col1;

			//creez threadul
			if(pthread_create(&calc_element[crrt_thr], NULL, multiply, arg))
			{
				perror("Eroare la crearea threadurilor");
				return errno;
			}
			crrt_thr++;
		}
	}

	crrt_thr = 0;
	for(int i = 0; i < lin1; i++)
	{
		for(int j = 0; j < col2; j++)
		{
			//astept finalizarea executiei threadurilor
			if(pthread_join(calc_element[crrt_thr], &retval))
			{
				perror("Eroare la join_thread");
				return errno;
			}
			res[i][j] = *((int*)retval);
			crrt_thr++;
		}
	}

	//printez matricea rezultat:
	printf("\n");
	for(int i = 0; i < lin1; i++)
	{
		for(int j = 0; j < col2; j++)
			printf("%d ", res[i][j]);

		printf("\n");
	}

	return 0;
}
