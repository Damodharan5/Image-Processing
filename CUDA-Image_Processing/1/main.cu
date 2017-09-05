#include "headerinc.h"

#define size_seek(a) ((a) == 24 ? 54:1078)

using namespace std;

BMPHEADER *_head;
DIBHEADER *_dib;
__global__ void Rgbinv(unsigned char *a, unsigned char *b, unsigned int count)
{

int id = blockIdx.x * blockDim.x + threadIdx.x;
if (id < count)
{
	float contrast = 50;
	float correction_factor;
	correction_factor = (259.0*(contrast + 255.0)) / (255.0*(259.0 - contrast));
	float temp = ((correction_factor * ((float)a[id] - 128.0)) + 128.0); // Contract correction taking place here
	b[id] = temp >= 0 ? (temp <= 255 ? (unsigned char)temp : 255) : 0;
}
}

int main()
{
	FILE *fp, *fp1;
	unsigned char *data;
	unsigned char *d_a,*d_b;
	unsigned int colordata[256];
	fp = fopen("C:/Users/cdamo/Desktop/2.bmp", "rb");
	fp1 = fopen("C:/Users/cdamo/Desktop/a2.bmp", "wb");

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
		DWORD pixelarray = ((_dib->bits_pixel/8*_dib->width_pixel)+padded)*_dib->height_pixel;
		data = (unsigned char *)malloc(pixelarray);
		fread(data,pixelarray,1,fp);
		if (cudaMalloc(&d_a, pixelarray) != cudaSuccess)
		{
		
			cout << "Nope!";
			return 0;
		}
		if (cudaMalloc(&d_b, pixelarray) != cudaSuccess)
		{

			cout << "Nope!";
			cudaFree(d_a);
			return 0;
		}
		if (cudaMemcpy(d_a, data, pixelarray, cudaMemcpyHostToDevice) != cudaSuccess) 
		{

			cout << "Nope!";
			cudaFree(d_b);
			cudaFree(d_a);
			return 0;
		}
		clock_t begin = clock();
		Rgbinv <<<pixelarray / 256 + 1 , 256>>> (d_a,d_b,pixelarray);
		clock_t end = clock();
		cout<<((double)end-begin)/CLOCKS_PER_SEC<<" Secs";
		if (cudaMemcpy(data, d_b, pixelarray, cudaMemcpyDeviceToHost) != cudaSuccess) 
		{

			cout << "Nope!";
			delete[] data;
			cudaFree(d_b);
			cudaFree(d_a);
			return 0;
		}
		fwrite(data,1,pixelarray,fp1);
	}
	fclose(fp);
	fclose(fp1);
	delete[] data;
	cudaFree(d_b);
	cudaFree(d_a);
	return 0;
}
