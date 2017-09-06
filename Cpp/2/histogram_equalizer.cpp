#include "headerinc.h"

#define size_seek(a) ((a) == 24 ? 54:1078)

using namespace std;

BMPHEADER *_head;
DIBHEADER *_dib;
int main()
{
	FILE *fp, *fp1;
	unsigned char *data;
	unsigned long channel_hist[3][256],cdf[3][256],hv[3][256];
	unsigned long channel_hist_min[3]={ULONG_MAX,ULONG_MAX,ULONG_MAX};
	data = (unsigned char *)malloc(3);
	unsigned char pad;
	unsigned int colordata[256];
	fp = fopen("C:/Users/cdamo/Desktop/1.bmp", "rb");
	fp1 = fopen("C:/Users/cdamo/Desktop/a1.bmp", "wb");

	_head = (BMPHEADER *)malloc(sizeof(BMPHEADER));
	fread(_head, sizeof(BMPHEADER), 1, fp);
	if (_head->marker != 19778) {
		cout << "Not a bmp file";
	}
	else {
		_dib = (DIBHEADER *)malloc(sizeof(DIBHEADER));
		fread(_dib, sizeof(DIBHEADER), 1, fp);
		if (_dib->bits_pixel == 8) { fread(colordata, 256 * 4, 1, fp); }
		fwrite(_head, 1, sizeof(BMPHEADER), fp1);
		fwrite(_dib, 1, sizeof(DIBHEADER), fp1);
		if (_dib->bits_pixel == 8) fwrite(colordata, 1, 256 * 4, fp1);
		fseek(fp1, size_seek(_dib->bits_pixel), SEEK_SET);
		unsigned int padded = floor((float)(_dib->bits_pixel*_dib->width_pixel + 31.0)/32.0)*4 -_dib->bits_pixel/8*_dib->width_pixel ;
		for(WORD i = 0;i<256;i++){
				channel_hist[0][i] = 0;
				channel_hist[1][i] = 0;
				channel_hist[2][i] = 0;
		}
		for (unsigned int i = 0;i < _dib->width_pixel;i++){
		for (unsigned int j = 0;j < _dib->height_pixel;j++) {
				fread(data, 3, 1, fp);
				channel_hist[0][data[0]] += 1;
				channel_hist[1][data[1]] += 1;
				channel_hist[2][data[2]] += 1;
		}
		for(DWORD k = 0;k<padded;k++){fread(&pad, 1, 1, fp);pad = 0x00 ;fwrite(&pad, 1, 1, fp1);}
		}
		/* CDF and Normaliztion is happening here */
		//Begin
		cdf[0][0] = cdf[1][0] = cdf[2][0] = 1;
	
		for(WORD i = 1;i<256;i++){
			for(WORD j = 0;j<3;j++){
				cdf[j][i] = cdf [j][i-1] + channel_hist[j][i];
			}
		}
		for(WORD i = 0;i<256;i++)
			for(WORD j = 0;j<3;j++)
				hv[j][i] = ((cdf[j][i] - 1.0)/(float)(_dib->width_pixel*_dib->height_pixel-1))*255;
		
		fseek(fp, size_seek(_dib->bits_pixel), SEEK_SET);
		for (unsigned int i = 0;i < _dib->width_pixel;i++){
		for (unsigned int j = 0;j < _dib->height_pixel;j++) {
				fread(data, 3, 1, fp);
				fwrite(&hv[0][data[0]],1,1,fp1);
				fwrite(&hv[0][data[1]],1,1,fp1);
				fwrite(&hv[0][data[2]],1,1,fp1);
		}
			//End;	
	}
	}
	fclose(fp);
	fclose(fp1);
	return 0;
}
