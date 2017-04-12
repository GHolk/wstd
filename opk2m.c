
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int walk(double m[3][3], int (*operate)(double *v)) {
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            operate(&m[i][j]);
        }
    }
    return 0;
}

int print_double_pointer(double *v) {
    printf("%lf\t", *v);
    return 0;
}

int put_in_double_pointer(double *v) {
    return scanf("%15lf", v) > 0;
}

int main(int argc, char* argv[]) {
    double m[3][3];
    int (*print)(double *v), (*put)(double *v);
    print = print_double_pointer;
    put = put_in_double_pointer;

    walk(m, put);
    walk(m, print);

    return 0;
}

