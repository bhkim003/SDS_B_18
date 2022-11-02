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

uint8_t*** im2col(uint8_t*** ifmap, uint8_t**** filter, int input_channel,
    int Height, int Weight, int output_channel, int filter_size,
    int padding_size, FILE* fp) {

    // definition! lowering filter size
    int lowered_filter_row_size = output_channel;
    int lowered_filter_column_size = input_channel * filter_size * filter_size;

    // 2D lowered filter init
    uint8_t** lowered_filter;

    lowered_filter = (uint8_t**)malloc(sizeof(uint8_t*) * lowered_filter_row_size);
    for (int i = 0; i < lowered_filter_row_size; i++) {
        lowered_filter[i] = (uint8_t*)malloc(sizeof(uint8_t) * lowered_filter_column_size);
        for (int j = 0; j < lowered_filter_column_size; j++) {
            lowered_filter[i][j] = 0;
        }
    }

    // ifmap element go to 2D lowered filter
    for (int i = 0; i < lowered_filter_row_size; i++) {
        for (int j = 0; j < input_channel; j++) {
            for (int k = 0; k < filter_size; k++) {
                for (int l = 0; l < filter_size; l++) {
                    lowered_filter[i][j * filter_size * filter_size + k * filter_size + l]
                        = filter[i][j][k][l];
                }
            }
        }
    }

    // definition! lowering ifmap size (stride_size is 1)
    int lowered_ifmap_row_size = input_channel * filter_size * filter_size;
    int lowered_ifmap_column_size = (Height + 2 * padding_size - filter_size + 1)
        * (Weight + 2 * padding_size - filter_size + 1);
    // 2D lowered filter init
    uint8_t** lowered_ifmap;

    lowered_ifmap = (uint8_t**)malloc(sizeof(uint8_t*) * lowered_ifmap_row_size);
    for (int i = 0; i < lowered_ifmap_row_size; i++) {
        lowered_ifmap[i] = (uint8_t*)malloc(sizeof(uint8_t) * lowered_ifmap_column_size);
        for (int j = 0; j < lowered_ifmap_column_size; j++) {
            lowered_ifmap[i][j] = 0;
        }
    }

    // Make the padded ifmap
    uint8_t*** padded = init_3D_tensor(input_channel, Height + 2 * padding_size
        , Weight + 2 * padding_size);
    for (int i = 0; i < input_channel; i++) {
        for (int j = 0; j < Height; j++) {
            for (int k = 0; k < Weight; k++) {
                padded[i][j + padding_size][k + padding_size] = ifmap[i][j][k];
            }
        }
    }

    // insert the element to the lowered_ifmap
    for (int i = 0; i < input_channel; i++) {
        for (int j = 0; j < (Height + 2 * padding_size - filter_size + 1); j++) {
            for (int k = 0; k < (Weight + 2 * padding_size - filter_size + 1); k++) {
                for (int l = 0; l < filter_size; l++) {
                    for (int m = 0; m < filter_size; m++) {
                        lowered_ifmap[i * filter_size * filter_size + l*filter_size + m][j*(Weight + 2 * padding_size - filter_size + 1) + k] = padded[i][j + l][k + m];
                    }
                }
            }
        }
    }

    // init final output 3D tensor (stride = 1)
    int final_channel = output_channel;
    int final_row = ((Height - filter_size + 2 * padding_size) / 1) + 1;
    int final_column = ((Weight - filter_size + 2 * padding_size) / 1) + 1;
    uint8_t*** final = init_3D_tensor(final_channel, final_row, final_column);
    // Let's do matrix multiplication
    for (int i = 0; i < lowered_filter_row_size/*output_channel*/; i++) {
        for (int j = 0; j < lowered_ifmap_column_size; j++) {
            for (int k = 0; k < lowered_ifmap_row_size/*lowered_filter_column_size*/; k++) {
                final[i][(j / final_column)][(j % final_column)]
                    += lowered_filter[i][k] * lowered_ifmap[k][j];
            }
        }
    }

    // print process
    for (int i = 0; i < output_channel; i++) {
        for (int j = 0; j < ((Height - filter_size + 2 * padding_size) / 1) + 1; j++) {
            for (int l = 0; l < ((Weight - filter_size + 2 * padding_size) / 1) + 1; l++) {
                fprintf(fp, "%-3u ", final[i][j][l]);
            }
            fprintf(fp, "\n");
        }
        fprintf(fp, "\n");
    }

    return final;
}

uint8_t*** convolution_2D(uint8_t*** ifmap, uint8_t**** filter, int input_channel,
    int Height, int Weight, int output_channel, int filter_size, int stride_size, int padding_size, FILE* fp) {

    uint8_t*** padded = init_3D_tensor(input_channel, Height + 2 * padding_size
        , Weight + 2 * padding_size);

    uint8_t*** final = init_3D_tensor(output_channel, ((Height - filter_size + 2 * padding_size) / stride_size) + 1
        , ((Weight - filter_size + 2 * padding_size) / stride_size) + 1);


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
            for (int l = 0; l < Height - filter_size + 2 * padding_size + 1; l += stride_size) {
                for (int k = 0; k < Weight - filter_size + 2 * padding_size + 1; k += stride_size) {
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
        for (int j = 0; j < ((Height - filter_size + 2 * padding_size) / stride_size) + 1; j++) {
            for (int l = 0; l < ((Weight - filter_size + 2 * padding_size) / stride_size) + 1; l++) {
                fprintf(fp, "%-3u ", final[i][j][l]);
            }
            fprintf(fp, "\n");
        }
        fprintf(fp, "\n");
    }
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