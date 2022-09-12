#define _CRT_SECURE_NO_WARNINGS
//#define _NO_CRT_STDIO_INLINE
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

#include "parameter.h" //이상하게 헤더파일 new로 만들고 복붙해야 되더라
#include "function.h"



int main() {
    uint8_t*** ifmap = init_3D_tensor(C, H, W);
    uint8_t**** filter = init_4D_tensor(Cout,C,K,K);
    FILE* fp_ifmap, * fp_filter, * fp_ofmap;
    fp_ifmap = fopen("ifmap.txt","w");
    fp_filter = fopen("filter.txt","w");
    fp_ofmap = fopen("ofmap.txt","w");
   

    set_3D_tensor(ifmap, C, H, W, fp_ifmap);
    set_4D_tensor(filter,Cout,C,K,K,fp_filter);

    clock_t start, end; //시간측정을 위한 변수 선언
    start = clock();    //시작시간 삽입
    
    uint8_t*** ofmap = convolution_2D(ifmap,filter,C,H,W,Cout,K,STRIDE,P,fp_ofmap);
    end = clock();       //끝난시간 삽입
    printf("[time : %f]\n", (float)(end - start) / CLOCKS_PER_SEC); //시간측정한거 출력

    fclose(fp_ifmap);
    fclose(fp_filter);
    fclose(fp_ofmap);
    return 0;
}