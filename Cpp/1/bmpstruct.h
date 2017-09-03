#ifndef BMPSTRUCT_H
#define BMPSTRUCT_H

typedef unsigned char  BYTE; // 1byte
typedef unsigned short  WORD; // 2bytes
typedef unsigned long  DWORD; //4bytes
#pragma pack(push)  /* push current alignment to stack */
#pragma pack(1)     /* set alignment to 1 byte boundary */

typedef struct bmpHeader {

	WORD marker;
	DWORD size;
	WORD reserved1;
	WORD reserved2;
	DWORD offset;

}BMPHEADER;

typedef struct dibHeader{

	unsigned int size;
	unsigned int width_pixel;
	unsigned int height_pixel;
	unsigned short colorplane;
	unsigned short bits_pixel;
	unsigned int compression;
	unsigned int image_size;
	unsigned int hres;
	unsigned int vres;
	unsigned int totalcolors;
	unsigned int importantcolors;
	unsigned int colors[256];

}DIBHEADER;
#pragma pack(pop) 
#endif
