## Tutorial 1 - Displaying the image.

Functions and constructs|                Description
------------------------|----------------------------------------------------------------------------------------------------------
IplImage |The IplImage is taken from the Intel Image Processing Library, in which the format is native.
cvLoadImage | Loads an image from a file.<br/> - IplImage* cvLoadImage(const char* filename, int iscolor=CV_LOAD_IMAGE_COLOR)<br/> - CV_LOAD_IMAGE_COLOR = 0(greyscale) or >0(rbg) or <0(rbga)
cvNamedWindow | Creates a window that can be used as a placeholder for images and trackbars. Created windows are referred to by their names..<br/> - void namedWindow(const string& winname, int flags=WINDOW_AUTOSIZE)<br/> - flags = CV_WINDOW_NORMAL or CV_WINDOW_AUTOSIZE or CV_WINDOW_OPENGL
cvShowImage|Displays an image in the specified window.<br/> - void cvShowImage(const char* name, const CvArr* image)<br/> - name - name of the window<br/> - image - image to be shown.
cvWaitKey|Waits for a keystroke.<br/> - int cvWaitKey(int delay=0 )
