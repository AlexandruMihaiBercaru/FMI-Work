import numpy as np
import matplotlib.pyplot as plt
from skimage import io


arr = []

for img in range(9):
    image = np.load("images/car_" + str(img) + ".npy")
    arr.append(image)

images = np.array(arr)


pixel_sum = np.sum(images)
print(f'pixel sum: {pixel_sum}\n')

pixels_image = np.sum(images, axis=(1,2))
print(f'pixel sum per image:\n{pixels_image}\n')

idx = np.argmax(pixels_image, axis=0)
print(f'index of image with the most pixels: {idx}\n')


mean_image = np.mean(images, axis=0)
io.imshow(mean_image.astype(np.uint8))
io.show()


stddev = np.std(images)

normalized_images = (images - mean_image) / stddev

for k in range(np.size(images, axis=0)):
    #get current axes
    ax = plt.gca()
    
    #hide x-axis
    ax.get_xaxis().set_visible(False)
    
    #hide y-axis 
    ax.get_yaxis().set_visible(False)
    plt.subplot(3,3,k+1)
    sliced = images[k][200:300, 280:400]
    plt.imshow(sliced)
    
plt.show()