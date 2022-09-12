#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

#include "parameter.h"
#include "function.h"

int main() {

    clock_t start, end;

    uint8_t*** ifmap = init_3D_tensor(C, H, W);
    uint8_t**** filter = init_4D_tensor(Cout, C, K, K);
    FILE* fp_ifmap, * fp_filter, * fp_ofmap;
    fp_ifmap = fopen("ifmap.txt", "w");
    fp_filter = fopen("filter.txt", "w");
    fp_ofmap = fopen("ofmap.txt", "w");

    set_3D_tensor(ifmap, C, H, W, fp_ifmap);
    set_4D_tensor(filter, Cout, C, K, K, fp_filter);

    start = clock();

    uint8_t*** ofmap = convolution_2D(ifmap, filter, C, H, W, Cout, K, STRIDE, P, fp_ofmap);

    end = clock();
    printf("[time : %f]\n", (float)(end - start) / CLOCKS_PER_SEC);

    fclose(fp_ifmap);
    fclose(fp_filter);
    fclose(fp_ofmap);

    return 0;
}