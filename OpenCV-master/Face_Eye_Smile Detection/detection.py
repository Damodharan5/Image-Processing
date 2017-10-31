# Face Recognition

# Import the libraries
import cv2

# Loading the cascade
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier('haarcascade_eye.xml')
smile_cascade = cv2.CascadeClassifier('haarcascade_smile.xml')
# Function to do the detection
# Apply cascade detection of face first over entire image.
# Next do the same for eye over the detected face.
def detect(gray, frame):
    # 1.3 and 5 are there becasue of trail and error
    # 1.3 - Scale the input image size
    # 5 - Number of neighbor zone of pixels to be considered for acceptablity
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)
    # x,y is the upper-most left point of the rectangle
    for (x, y, w, h) in faces:
        # Rectangle(img,(top corner point),(bottom corner point),color,thickness)
        cv2.rectangle(frame, (x, y), (x+w, y+h), (255, 0, 0), 2)
        # Region of interest for eye detection
        roi_gray = gray[y:y+h,x:x+w]
        roi_color = frame[y:y+h,x:x+w]
        eyes = eye_cascade.detectMultiScale(roi_gray, 1.1, 15)
#Change the kernel size and neighboring zoning by trail and error for smile
        smiles = smile_cascade.detectMultiScale(roi_gray, 1.7, 20)
        for (x1, y1, w1, h1) in eyes:
            cv2.rectangle(roi_color, (x1, y1), (x1+w1, y1+h1), (0,255,0), 2)
        for (x2, y2, w2, h2) in smiles:
            cv2.rectangle(roi_color, (x2, y2), (x2+w2, y2+h2), (0,0,255), 2)
    return frame

# Webcam and main routine
video_capture = cv2.VideoCapture(0)

#Underscore is like don'tcare the value returned by the function
while True:
    _,frame = video_capture.read()
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    canvas = detect(gray, frame)
    cv2.imshow('Video', canvas)
    if cv2.waitKey(1) & 0XFF == ord('q'):
        break
video_capture.release()
cv2.destroyAllWindows()
