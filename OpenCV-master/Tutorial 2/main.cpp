#include <opencv2/opencv.hpp>
#include <iostream>
#include<conio.h>


using namespace std;
using namespace cv;


int main(void)
{
	
	namedWindow("Example 2", WINDOW_AUTOSIZE);
	VideoCapture cap(0);
	Mat frame, filteredimg,frame_gry;

	while (1)
	{
		bool check = cap.read(frame);
		filteredimg = frame;
		if (!check || frame.empty()) { cout << "Faaa"; _getch();break; }
		//Uncommet the below two lines to see about Double Gaussian Blur - Blur the image and reduce the noise
		GaussianBlur(frame,filteredimg,Size(5,5),3,3);
		GaussianBlur(filteredimg,filteredimg, Size(5, 5), 3, 3);
		//Uncommet the below line to see about PyrDown - Reduce the frame to half the width and height
		//pyrDown(filteredimg, filteredimg);
		//Uncommet the below two lines to see about canny edge detector effect
		//cvtColor(filteredimg, frame_gry, cv::COLOR_BGR2GRAY);
	    	//Canny(frame_gry, filteredimg, 10, 100, 3, true);
		imshow("Example 2", filteredimg);
		if (waitKey(33) == 27) break;   //wait for the escape key
	}
	frame.release();
	filteredimg.release();
	destroyWindow("Example 2");

	return 0;
	
}
