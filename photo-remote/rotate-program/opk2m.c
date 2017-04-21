#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define OMEGA 0
#define PHI 1
#define KAPA 2

#define M_OMEGA(omega) { \
    {1, 0, 0}, \
    {0, cos(omega), sin(omega)}, \
    {0, -sin(omega), cos(omega)} \
}

#define M_PHI(phi) { \
    {cos(phi), 0, -sin(phi)}, \
    {0, 1, 0}, \
    {sin(phi), 0, cos(phi)} \
}

#define M_KAPA(kapa) { \
    {cos(degree[KAPA]), sin(degree[KAPA]), 0}, \
    {-sin(degree[KAPA]), cos(degree[KAPA]), 0}, \
    {0, 0, 1} \
}

typedef double Matrix3[3][3];

void multiply_matrix (Matrix3 m1, Matrix3 m2, Matrix3 answer) {
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            answer[i][j] = 0;
            for (int k=0; k<3; k++) answer[i][j] += m1[i][k] * m2[k][j];
        }
    }
}

void print_matrix (double m[3][3]) {
    puts("[");
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            putchar('\t');
            printf("%lf", m[i][j]);
        }
        putchar('\n');
    }
    puts("]\n");
}

int main(int argc, char* argv[]) {
    double degree[3];

    if (argc-1 == 3) {
        for (int i=0; i<3; i++) sscanf(argv[i+1], "%lf", &degree[i]);
    }
    else {
        FILE *eoio = fopen("eoio.tsv","r");
        for (int i=0; i<3; i++) fscanf(eoio, "%lf", &degree[i]);
        fclose(eoio);
    }

    Matrix3 m[] = {
        M_OMEGA(degree[OMEGA]),
        M_PHI(degree[PHI]),
        M_KAPA(degree[KAPA])
    };

#ifdef DEBUG
    puts("M(omega) = ");
    print_matrix(m[OMEGA]);

    puts("M(phi) = ");
    print_matrix(m[PHI]);

    puts("M(kapa) = ");
    print_matrix(m[KAPA]);
#endif

    Matrix3 answer[2];

    puts("M(kapa) * M(phi) * M(omega) = ");
    multiply_matrix(m[KAPA], m[PHI], answer[0]);
    multiply_matrix(answer[0], m[OMEGA], answer[1]);
    print_matrix(answer[1]);

    return 0;
}

