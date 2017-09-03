// Color inversion
/*
#include <iostream>
#include<stdlib.h>
#include<string>
#include<conio.h>
#include "bmpstruct.h"

using namespace std;
BMPHEADER *_head;
DIBHEADER *_dib;
int main()
{
	FILE *fp,*fp1;
	unsigned char data;
	fp = fopen("C:/Users/cdamo/Desktop/a.bmp", "rb");
	fp1 = fopen("C:/Users/cdamo/Desktop/a1.bmp", "wb");

	_head = (BMPHEADER *)malloc(sizeof(BMPHEADER));
	fread(_head, sizeof(BMPHEADER), 1, fp);
	if (_head->marker != 19778) {
		cout << "Not a bmp file";
	}
	else {
		_dib = (DIBHEADER *)malloc(sizeof(DIBHEADER));
		fread(_dib, sizeof(DIBHEADER), 1, fp);
		fwrite(_head,  1, sizeof(BMPHEADER), fp1);
		fwrite(_dib,  1, sizeof(DIBHEADER), fp1);
		fseek(fp1, 1078, SEEK_SET);
		unsigned long data_size = _dib->width_pixel * _dib->height_pixel;
	for(int i = 0;i<data_size;i++){
		data = fgetc(fp);
		fputc(255 - data, fp1);

	} 
		
	}
	fclose(fp1);
	fclose(fp);
	return 0;
}*/