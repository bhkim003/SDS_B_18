#define _CRT_SECURE_NO_WARNINGS

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

    uint8_t*** padding = init_3D_tensor(input_channel, Height + 2 * padding_size, Weight + 2 * padding_size);

    //Make tensor which including ifmap and padding
    for (int i = 0; i < input_channel; i++) {
        for (int j = 0; j < Height; j++) {
            for (int k = 0; k < Weight; k++) {
                padding[i][j + padding_size][k + padding_size] = ifmap[i][j][k];
            }
        }
    }

    //Calculating
    int output_height = ((Height - filter_size + 2 * padding_size) / stride_size) + 1;
    int output_weight = ((Weight - filter_size + 2 * padding_size) / stride_size) + 1;

    uint8_t*** output_tensor = init_3D_tensor(output_channel, output_height, output_weight);

    for (int i = 0; i < output_channel; i++) {
        for (int j = 0; j < input_channel; j++) {
            for (int k = 0; k < output_height; k++) {
                for (int l = 0; l < output_weight; l++) {
                    for (int x = 0; x < filter_size; x++) {
                        for (int y = 0; y < filter_size; y++) {
                            output_tensor[i][k][l] += padding[j][(k * stride_size) + x][(l * stride_size) + y] * filter[i][j][x][y];
                        }
                    }
                }
            }
        }
    }

    //printing the output
    for (int i = 0; i < output_channel; i++) {
        for (int j = 0; j < output_height; j++) {
            for (int k = 0; k < output_weight; k++) {
                fprintf(fp, "%-3u ", output_tensor[i][j][k]);
            }
            fprintf(fp, "\n");
        }
        fprintf(fp, "\n");
    }

    return output_tensor;

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