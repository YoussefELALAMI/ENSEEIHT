#include "aux.h"
#include "omp.h"
#define MAX_THREADS 30

void loop1(int n){

  long   t_start, t_end;
  double time_it, load;
  int i;
  double loadProcess[MAX_THREADS];

  load = 0.0;
  #pragma omp parallel
  {
  #pragma omp for schedule(static)
  for(i=0; i<n; i++){
    t_start=usecs();
    func1(i,n);
    time_it = (double)(usecs()-t_start);
    load+=time_it;
    loadProcess[omp_get_thread_num()] += time_it; 
    if(n<=20) printf("Iteration %6d  of loop 1 took %.2f usecs (Thread %2d, Load : %.2f)\n",i, time_it, omp_get_thread_num(), loadProcess[omp_get_thread_num()]);
  }

  #pragma omp master
  {
    double min = loadProcess[0];
    double max = 0.0;

    for(int j=0; j<omp_get_num_threads(); j++){
      if(loadProcess[j] < min){
        min = loadProcess[j];
      }
      if(loadProcess[j]>max){
        max = loadProcess[j];
      } 
    }

    printf("Minimum is : %.2f, and Maximum is : %.2f\n, and the Balance is : %.2f", min, max, max/min);
  }
  }
}


void loop2(int n){

  long   t_start, t_end;
  double time_it, load;
  int i;
  double loadProcess[MAX_THREADS];

  load = 0.0;
  #pragma omp parallel
  {
  #pragma omp for schedule(dynamic)
  for(i=0; i<n; i++){
    t_start=usecs();
    func2(i,n);
    time_it = (double)(usecs()-t_start);
    load+=time_it;    loadProcess[omp_get_thread_num()] += time_it; 
    if(n<=20) printf("Iteration %6d  of loop 1 took %.2f usecs (Thread %2d, Load : %.2f)\n",i, time_it, omp_get_thread_num(), loadProcess[omp_get_thread_num()]);
  }
  #pragma omp master
  {
    double min = loadProcess[0];
    double max = 0.0;

    for(int j=0; j<omp_get_num_threads(); j++){
      if(loadProcess[j] < min){
        min = loadProcess[j];
      }
      if(loadProcess[j]>max){
        max = loadProcess[j];
      } 
    }

    printf("Minimum is : %.2f, and Maximum is : %.2f\n, and the Balance is : %.2f", min, max, max/min);
  }
  }
}

void loop3(int n){

  long   t_start, t_end;
  double time_it, load;
  int i;
  double loadProcess[MAX_THREADS];

  load = 0.0;
  #pragma omp parallel
  {
  #pragma omp for schedule(guided)
  for(i=0; i<n; i++){
    t_start=usecs();
    func3(i,n);
    time_it = (double)(usecs()-t_start);
    load+=time_it;load+=time_it;    loadProcess[omp_get_thread_num()] += time_it; 
    if(n<=20) printf("Iteration %6d  of loop 1 took %.2f usecs (Thread %2d, Load : %.2f)\n",i, time_it, omp_get_thread_num(), loadProcess[omp_get_thread_num()]);
  
  }

  #pragma omp master
  {
    double min = loadProcess[0];
    double max = 0.0;

    for(int j=0; j<omp_get_num_threads(); j++){
      if(loadProcess[j] < min){
        min = loadProcess[j];
      }
      if(loadProcess[j]>max){
        max = loadProcess[j];
      } 
    }

    printf("Minimum is : %.2f, and Maximum is : %.2f\n, and the Balance is : %.2f", min, max, max/min);
  }
  }
}


int main(int argc, char **argv){
  int    i, j, n;

  // Command line argument
  if ( argc == 2 ) {
    n = atoi(argv[1]);    /* the number of loop iterations */
  } else {
    printf("Usage:\n\n ./main n \n\nwhere n is the number of iterations in the loops\n");
    return 1;
  }

  printf("\n");
  
  loop1(n);
  
  printf("\n");

  loop2(n);
  
  printf("\n");

  loop3(n);
  
  printf("\n");
  
  return 0;
}
