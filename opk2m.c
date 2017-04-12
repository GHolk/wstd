
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char* argv[]) {
    double m[3][3], opk[3];
    if (argc-1 == 3) {
        for (int i=0; i<3; i++) sscanf(argv[i+1], "%lf", &opk[i]);
    }
    else {
        for (int i=0; i<3; i++) scanf("%lf", &opk[i]);
    }

    printf("%lf\t%lf\t%lf\n", opk[0], opk[1], opk[2]);
    return 0;
}

