
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define FILL_ROW(mi,n0,n1,n2) \
    mi[0] = n0; mi[1] = n1; mi[2] = n2

#define FILL_MATRIX(m,n0,n1,n2,n3,n4,n5,n6,n7,n8) \
    FILL_ROW(m[0],n0,n1,n2); \
    FILL_ROW(m[1],n3,n4,n5); \
    FILL_ROW(m[2],n6,n7,n8)

#define OMEGA 0
#define PHI 1
#define KAPA 2

typedef double Matrix3[3][3];
typedef double Vector3[3];

void fill_omega_matrix (double omega, Matrix3 m) {
    FILL_MATRIX(
            m,
            1, 0, 0,
            0, cos(omega), sin(omega),
            0, -sin(omega), cos(omega)
    );
}
void fill_phi_matrix (double phi, Matrix3 m) {
    FILL_MATRIX(
            m,
            cos(phi), 0, -sin(phi),
            0, 1, 0,
            sin(phi), 0, cos(phi)
    );
}
void fill_kaya_matrix (double kapa, Matrix3 m) {
    FILL_MATRIX(
            m,
            cos(kapa), sin(kapa), 0,
            -sin(kapa), cos(kapa), 0,
            0, 0, 1
    );
}

void multiply_matrix (Matrix3 m1, Matrix3 m2, Matrix3 answer) {
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            answer[i][j] = 0;
            for (int k=0; k<3; k++) answer[i][j] += m1[i][k] * m2[k][j];
        }
    }
}

void multiply_matrix_vector (Matrix3 m, Vector3 v, Vector3 answer) {
    for (int i=0; i<3; i++) {
        answer[0] = 0;
        for (int j=0; j<3; j++) {
            answer[0] += m[i][j]*v[j]
        }
    }

}

void print_metrix (double m[3][3]) {
    puts("[");
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            putchar('\t');
            printf("%lf", m[i][j]);
        }
        putchar('\n');
    }
    puts("]");
}

int main(int argc, char* argv[]) {
    Matrix3 m[3], answer;
    double degree[3];

    if (argc-1 == 3) {
        for (int i=0; i<3; i++) sscanf(argv[i+1], "%lf", &degree[i]);
    }
    else {
        for (int i=0; i<3; i++) scanf("%lf", &degree[i]);
    }

    fill_omega_matrix(degree[OMEGA], m[OMEGA]);
    fill_phi_matrix(degree[PHI], m[PHI]);
    fill_kapa_matrix(degree[KAPA], m[KAPA]);

    print_metrix(m[0]);
    multiply_matrix(m[OMEGA], m[PHI], answer);
    multiply_matrix(m[OMEGA], m[PHI], answer);
    multiply_matrix(m[OMEGA], m[PHI], answer);
    print_metrix(m[2]);
    return 0;
}

