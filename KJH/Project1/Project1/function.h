#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

/**
 * @brief 3D_tensor를 생성하는 함수. x = channel, y = H, z = W 를 뜻하며
 *        모든 값을 0으로 초기화한다.
 *
 * @Usage: uint8_t***ifmap = init_3D_tensor(C,H,W) ...
 *
 * @param x
 * @param y
 * @parma z
 * @return uint8_t*** 3D_tensor
 */
uint8_t*** init_3D_tensor(int x, int y, int z);

/**
 * @brief 4D_tensor를 생성하는 함수. x = output_channel, y = input_channel, z,w = K 를 뜻하며
 *        모든 값을 0으로 초기화한다.
 *
 * @Usage: uint8_t****filter = init_4D_tensor(Cout,C,K,K) ...
 *
 * @param x
 * @param y
 * @parma z
 * @param w
 * @return uint8_t**** 4D_tensor
 */
uint8_t**** init_4D_tensor(int x, int y, int z, int w);

/**
 * @brief 생성된 3D_tensor의 값들을 Ramdom하게 설정하는 함수
 *        모든 값을 0~255 사이의 값으로 초기화한다.이때 tensor의 값들을 file pointer가 지정한
 *        루트로 출력한다.
 *
 * @Usage: set_3D_tensor(ifmap,C,H,W,fp_ifmap) ...
 *
 * @param uint8_t*** tensor
 * @param x
 * @param y
 * @param z
 * @param FILE *fp
 * @return void
 */
void set_3D_tensor(uint8_t*** tensor, int x, int y, int z, FILE* fp);

/**
 * @brief 생성된 4D_tensor의 값들을 Ramdom하게 설정하는 함수
 *        모든 값을 0~255 사이의 값으로 초기화한다. 이때 tensor의 값들을 file pointer가 지정한
 *        루트로 출력한다.
 *
 * @Usage: set_4D_tensor(filter,Cout,C,K,K,fp_filter) ...
 *
 * @param uint8_t**** tensor
 * @param x
 * @param y
 * @param z
 * @param w
 * @return void
 */
void set_4D_tensor(uint8_t**** tensor, int x, int y, int z, int w, FILE* fp);

/**
 * @brief 2D convolution layer 함수
 *        convolution을 수행하는데 필요한 stride, padding size를 마찬가지로 입력값으로 받는다.
 *        ifmap과 fiter에 대한 정보를 입력받고, 내부적인 연산을 통해 ofmap을 생성하여 출력한다.
 *        ofmap의 사이즈 또한 입력받은 정보들을 토대로 내부적으로 계산한다.
 *
 * @Usage: uint8_t*** ofmap = convolution_2D(ifmap,filter,C,H,W,Cout,K,STRIDE,P,fp_ofmap) ...
 *
 * @param 이하 생략
 * @return uint8_t*** ofmap
 */
uint8_t*** convolution_2D(uint8_t*** ifmap, uint8_t**** filter, int input_channel,
    int Height, int Weight, int output_channel, int filter_size,
    int stride_size, int padding_size, FILE* fp);


/**
 * @brief 생성된 3D_tensor의 동적 할당을 해제하는 함수
 *        (*해당 lab에서는 아래 함수를 꼭 사용하지 않아도 무방합니다.)
 */
void delete_3D_tensor(uint8_t*** tensor, int x, int y, int z);

