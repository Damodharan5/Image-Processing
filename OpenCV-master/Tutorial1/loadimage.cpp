#include <opencv/highgui.h> // Utilities for reading image and video

int main(void) {

	IplImage* img = cvLoadImage("D:/Interview/New folder/1.jpg");  // IplImage - OpenCV Construct to deal with images.
	cvNamedWindow("Example 1", CV_WINDOW_AUTOSIZE); // opens a window and HIGHGUI refer it by the name.(here the name is "Example 1")
	cvShowImage("Example 1", img); // It will display the image in the existing named window.
	cvWaitKey(0); // Wait for the keypress.
	cvReleaseImage(&img); // free the memory of the image pointer.
	cvDestroyWindow("Example 1");  // destroy the named window and deallocate the memory of the window.
	return 0;

}
