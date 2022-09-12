#include "function.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>


uint8_t*** init_3D_tensor(int x, int y, int z) {
    uint8_t*** ret;
    ret = (uint8_t***)malloc(sizeof(uint8_t**) * x);
    for (int i = 0; i < x; i++) {
        ret[i] = (uint8_t**)malloc(sizeof(uint8_t*) * y);
        for (int j = 0; j < y; j++) {
            ret[i][j] = (uint8_t*)malloc(sizeof(uint8_t) * z);
            for (int k = 0; k < z; k++) {
                ret[i][j][k] = 0;
            }
        }
    }
    return ret;
}




uint8_t**** init_4D_tensor(int x, int y, int z, int w) {
    uint8_t**** ret;
    ret = (uint8_t****)malloc(sizeof(uint8_t***) * x);
    for (int i = 0; i < x; i++) {
        ret[i] = (uint8_t***)malloc(sizeof(uint8_t**) * y);
        for (int j = 0; j < y; j++) {
            ret[i][j] = (uint8_t**)malloc(sizeof(uint8_t*) * z);
            for (int k = 0; k < w; k++) {
                ret[i][j][k] = (uint8_t*)malloc(sizeof(uint8_t) * w);
                for (int l = 0; l < w; l++) {
                    ret[i][j][k][l] = 0;
                }
            }
        }
    }
    return ret;
}



void set_3D_tensor(uint8_t*** tensor, int x, int y, int z, FILE* fp) {
    srand(time(NULL));
    for (int i = 0; i < x; i++) {
        for (int j = 0; j < y; j++) {
            for (int l = 0; l < z; l++) {
                tensor[i][j][l] = rand() % 256;
                fprintf(fp, "%-3u ", tensor[i][j][l]);
            }
            fprintf(fp, "\n");
        }
    }
}




void set_4D_tensor(uint8_t**** tensor, int x, int y, int z, int w, FILE* fp) {
    srand(time(NULL));
    for (int i = 0; i < x; i++) {
        for (int j = 0; j < y; j++) {
            for (int l = 0; l < z; l++) {
                for (int k = 0; k < w; k++) {
                    tensor[i][j][l][k] = rand() % 256;
                    fprintf(fp, "%-3u ", tensor[i][j][l][k]);
                }
                fprintf(fp, "\n");
            }
        }
    }
}




uint8_t*** convolution_2D(uint8_t*** ifmap, uint8_t**** filter, int input_channel,
    int Height, int Weight, int output_channel, int filter_size, int stride_size, int padding_size, FILE* fp) {

      // so difficult

    return final;
}



void delete_3D_tensor(uint8_t*** tensor, int x, int y, int z) {
    for (int i = 0; i < x; i++) {
        for (int l = 0; l < y; l++) {
            free(tensor[i][l]);
        }
        free(tensor[i]);
    }
    free(tensor);
}