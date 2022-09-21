#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

/**
 * @brief 3D_tensor�� �����ϴ� �Լ�. x = channel, y = H, z = W �� ���ϸ�
 *        ��� ���� 0���� �ʱ�ȭ�Ѵ�.
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
 * @brief 4D_tensor�� �����ϴ� �Լ�. x = output_channel, y = input_channel, z,w = K �� ���ϸ�
 *        ��� ���� 0���� �ʱ�ȭ�Ѵ�.
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
 * @brief ������ 3D_tensor�� ������ Ramdom�ϰ� �����ϴ� �Լ�
 *        ��� ���� 0~255 ������ ������ �ʱ�ȭ�Ѵ�.�̶� tensor�� ������ file pointer�� ������
 *        ��Ʈ�� ����Ѵ�.
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
 * @brief ������ 4D_tensor�� ������ Ramdom�ϰ� �����ϴ� �Լ�
 *        ��� ���� 0~255 ������ ������ �ʱ�ȭ�Ѵ�. �̶� tensor�� ������ file pointer�� ������
 *        ��Ʈ�� ����Ѵ�.
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
 * @brief 2D convolution layer �Լ�
 *        convolution�� �����ϴµ� �ʿ��� stride, padding size�� ���������� �Է°����� �޴´�.
 *        ifmap�� fiter�� ���� ������ �Է¹ް�, �������� ������ ���� ofmap�� �����Ͽ� ����Ѵ�.
 *        ofmap�� ������ ���� �Է¹��� �������� ���� ���������� ����Ѵ�.
 *
 * @Usage: uint8_t*** ofmap = convolution_2D(ifmap,filter,C,H,W,Cout,K,STRIDE,P,fp_ofmap) ...
 *
 * @param ���� ����
 * @return uint8_t*** ofmap
 */
uint8_t*** convolution_2D(uint8_t*** ifmap, uint8_t**** filter, int input_channel,
    int Height, int Weight, int output_channel, int filter_size,
    int stride_size, int padding_size, FILE* fp);


/**
 * @brief ������ 3D_tensor�� ���� �Ҵ��� �����ϴ� �Լ�
 *        (*�ش� lab������ �Ʒ� �Լ��� �� ������� �ʾƵ� �����մϴ�.)
 */
void delete_3D_tensor(uint8_t*** tensor, int x, int y, int z);

