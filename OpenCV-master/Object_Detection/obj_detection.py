# Object Detection

# Importing the libraries
import torch
from torch.autograd import Variable
import cv2
from data import BaseTransform, VOC_CLASSES as labelmap
from ssd import build_ssd
import imageio

# Defining a function that will do the detections
def detect(frame, net, transform):
    # To get the hieght and width of the frame first
    height, width = frame.shape[:2]
    # Transform image so that we can pass it to the torch
    # First transform gives numpy array. Then convert the numpy array to torch tensor
    # Third to create fake dimension to the tensor corresponds to bacth.Fourth and last converts the 
    # torch tensor to variables which will allow to fast computation during backpropagation.
    frame_t = transform(frame)[0] # Numpy Array
    x = torch.from_numpy(frame_t).permute(2,0,1) # Torch Tensor
    x = Variable(x.unsqueeze(0))
    y = net(x)
    detections = y.data
    scale = torch.Tensor([width, height, width, height])
    # detections = [batch, number of classes, number of occurrences of the class, (score, x0, y0, x1, y1)]
    for i in range(detections.size(1)):
        j = 0 # Occurences
        while detections[0, i, j, 0] >= 0.6:
            pt = (detections[0, i, j, 1:] * scale).numpy()
            cv2.rectangle(frame, (int(pt[0]), int(pt[1])), (int(pt[2]), int(pt[3])), (255, 0, 0), 2)
            cv2.putText(frame, labelmap[i - 1], (int(pt[0]), int(pt[1])), cv2.FONT_HERSHEY_SIMPLEX, 2, (255, 255, 255), 2, cv2.LINE_AA)
            j += 1
    return frame

# Creating the SSD neural network
net = build_ssd('test')
# Precomputed weights to detect 30 objects
net.load_state_dict(torch.load('ssd300_mAP_77.43_v2.pth',map_location = lambda storage, loc: storage))

# Creating the transform so that it makes the frame_image compatible to the ssd muti detector
# net.size -> targetsize of our network and don't worry about the three numbers in the triplets
transform = BaseTransform(net.size, (104/256.0, 117/256.0, 123/256.0))

# Doing the detection in a video
reader = imageio.get_reader('funny_dog.mp4')
fps = reader.get_meta_data()['fps']
writer = imageio.get_writer('output.mp4', fps = fps)
for i, frame in enumerate(reader):
    frame = detect(frame, net.eval(), transform)
    writer.append_data(frame)
    print(i)
writer.close()

reader = imageio.get_reader('IMG_1327.MOV')
writer = imageio.get_writer('output.MOV')
for i, frame in enumerate(reader):
    frame = detect(frame, net.eval(), transform)
    writer.append_data(frame)
    if i == 870:
        break
    print(i)
writer.close()
