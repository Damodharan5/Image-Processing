#include "headerinc.h"

#define size_seek(a) ((a) == 24 ? 54:1078)

using namespace std;
typedef struct {
	unsigned char r;
	unsigned char g;
	unsigned char b;
}rgbcolor;
BMPHEADER *_head;
DIBHEADER *_dib;
__global__ void Rgbinv(rgbcolor *a, rgbcolor *b, unsigned long count)
{

unsigned long id = blockIdx.x * blockDim.x + threadIdx.x;
if (id < count)
{

	b[id].r = b[id].g = b[id].b = (a[id].b + a[id].g + a[id].r)/3;

}
}

int main()
{
	FILE *fp, *fp1;
	rgbcolor *d_a,*d_b;
	rgbcolor *data;
	unsigned int colordata[256];
	DWORD pixelarray;
	fp = fopen("C:/Users/cdamo/Desktop/1.bmp", "rb");
	fp1 = fopen("C:/Users/cdamo/Desktop/b2.bmp", "wb");

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
		pixelarray = ((_dib->bits_pixel/8*_dib->width_pixel)+padded)*_dib->height_pixel;
		data = (rgbcolor *)malloc(pixelarray);
		fread(data,pixelarray,1,fp);
		if (cudaMalloc(&d_a, pixelarray) != cudaSuccess)
		{
		
			cout<<cudaGetErrorString(cudaGetLastError());
			return 0;
		}
		if (cudaMalloc(&d_b, pixelarray) != cudaSuccess)
		{

			cout<<cudaGetErrorString(cudaGetLastError());
			cudaFree(d_a);
			return 0;
		}
		if (cudaMemcpy(d_a, data, pixelarray, cudaMemcpyHostToDevice) != cudaSuccess) 
		{

			cout<<cudaGetErrorString(cudaGetLastError());
			cudaFree(d_b);
			cudaFree(d_a);
			return 0;
		}
		clock_t begin = clock();
		Rgbinv <<<pixelarray / (256*3) + 1 , 256>>> (d_a,d_b,pixelarray);
		clock_t end = clock();
		cout<<((double)end-begin)/CLOCKS_PER_SEC<<" Secs\n";
		if (cudaMemcpy(data, d_b, pixelarray, cudaMemcpyDeviceToHost) != cudaSuccess) 
		{

			cout<<cudaGetErrorString(cudaGetLastError());
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
