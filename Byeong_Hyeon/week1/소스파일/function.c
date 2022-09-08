#include "function.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

uint8_t*** init_3D_tensor(int x, int y, int z) {
    uint8_t *** ret;
    ret = (uint8_t***)malloc(sizeof(uint8_t**)*x);
    for(int i = 0; i < x; i++) {
        ret[i] = (uint8_t**)malloc(sizeof(uint8_t*)*y);
        for(int j = 0; j < y; j++) {
            ret[i][j] = (uint8_t*)malloc(sizeof(uint8_t)*z);
            for(int k = 0; k < z; k++) {
                    ret[i][j][k] = 0;
                }
        }
    }
    return ret;
}

uint8_t**** init_4D_tensor(int x, int y, int z, int w) {
    uint8_t **** ret;
    ret = (uint8_t****)malloc(sizeof(uint8_t***)*x);
    for(int i = 0; i < x; i++) {
        ret[i] = (uint8_t***)malloc(sizeof(uint8_t**)*y);
        for(int j = 0; j < y; j++) {
            ret[i][j] = (uint8_t**)malloc(sizeof(uint8_t*)*z);
            for(int k = 0; k < w; k++) {
                ret[i][j][k] = (uint8_t*)malloc(sizeof(uint8_t)*w);
                for(int l = 0; l < w; l++) {
                    ret[i][j][k][l] = 0;
                }
            }
        }
    }
    return ret;
}
void set_3D_tensor(uint8_t*** tensor, int x, int y, int z, FILE *fp) {
    srand(time(NULL));
    for(int i = 0; i < x; i++) {
        for(int j = 0; j < y; j++) {
            for(int l = 0; l < z; l++) {
                tensor[i][j][l] = rand()%256;
                fprintf (fp, "%-3u ", tensor[i][j][l]);
            }
            fprintf(fp, "\n");
        }
    }
}

void set_4D_tensor(uint8_t**** tensor, int x, int y, int z, int w, FILE *fp) {
    srand(time(NULL));
    for(int i = 0; i < x; i++) {
        for(int j = 0; j < y; j++) {
            for(int l = 0; l < z; l++) {
                for(int k = 0; k < w; k++) {
                    tensor[i][j][l][k] = rand()%256;
                    fprintf (fp, "%-3u ", tensor[i][j][l][k]);
                }
                fprintf(fp, "\n");
            }
        }
    }
}

uint8_t*** convolution_2D(uint8_t*** ifmap, uint8_t**** filter, int input_channel, 
                    int Height, int Weight, int output_channel, int filter_size, int stride_size, int padding_size,FILE* fp) {

    uint8_t*** padded = init_3D_tensor(input_channel, Height + 2 * padding_size
        , Weight + 2*padding_size);

    uint8_t*** final = init_3D_tensor(output_channel, ((Height - filter_size + 1) / stride_size) + 2 * padding_size
        , ((Weight - filter_size + 1) / stride_size) + 2 * padding_size);
    


    /* int size tensor define
    int x = output_channel;
    int y = ((Height - filter_size + 1) / stride_size) + 2 * padding_size;
    int z = ((Weight - filter_size + 1) / stride_size) + 2 * padding_size;
    int*** final;
    final = (int***)malloc(sizeof(int**) * x);
    for (int i = 0; i < x; i++) {
        final[i] = (int**)malloc(sizeof(int*) * y);
        for (int j = 0; j < y; j++) {
            final[i][j] = (int*)malloc(sizeof(int) * z);
            for (int k = 0; k < z; k++) {
                final[i][j][k] = 0;
            }
        }
    }
    */
 
    //패딩된 매트릭스만들기
    for (int i = 0; i < input_channel; i++) {
        for (int j = 0; j < Height; j++) {
            for (int k = 0; k < Weight; k++) {
                padded[i][j + padding_size][k + padding_size] = ifmap[i][j][k];
            }
        }
    }


    for (int i = 0; i < output_channel; i++) {
        for (int j = 0; j < input_channel; j++) {
            for (int l = 0; l < Height - filter_size + 2*padding_size + 1; l += stride_size) {
                for (int k = 0; k < Weight - filter_size + 2*padding_size  + 1; k += stride_size) {
                    for (int a = l; a < l + filter_size; a++) {
                        for (int b = k; b < k + filter_size; b++) {
                            final[i][(l / stride_size)][(k / stride_size)]
                                += padded[j][a][b] * filter[i][j][a - l][b - k];
                        }
                    }
                }
            }
        }
    }

    // 프린트작업
    for (int i = 0; i < output_channel; i++) {
        for (int j = 0; j < ((Height - filter_size + 1) / stride_size) + 2 * padding_size; j++) {
            for (int l = 0; l < ((Weight - filter_size + 1) / stride_size) + 2 * padding_size; l++) {
                fprintf(fp, "%-3u ", final[i][j][l]);
            }
            fprintf(fp, "\n");
        }
        fprintf(fp, "\n");
    }

    return final;
}

void delete_3D_tensor(uint8_t*** tensor, int x, int y, int z) {
    for(int i = 0; i < x; i++) {
        for(int l = 0; l < y; l++) {
                free(tensor[i][l]);
        }
        free(tensor[i]);
    }
    free(tensor);
}