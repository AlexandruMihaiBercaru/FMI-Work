import numpy as np
import matplotlib.pyplot as plt


train_images = np.loadtxt('data_MNIST/data/train_images.txt') # incarcam imaginile
train_labels = np.loadtxt('data_MNIST/data/train_labels.txt', 'int') # incarcam etichetele avand tipul de date int

test_images = np.loadtxt('data_MNIST/data/test_images.txt')
test_labels = np.loadtxt('data_MNIST/data/test_labels.txt', 'int')



class KnnClassifier:
    
    def __init__(self, train_images, train_labels):
        self.train_images = train_images
        self.train_labels = train_labels

    def classify_image(self, test_image, num_neighbours = 3, metric = 'l2'):

        test_image = test_image.reshape(1, -1)  # shape = (1, 784)

        if metric == 'l2':
            dot = np.dot(test_image, self.train_images.T) # shape = (1,1000)
            test_sq = np.sum(test_image ** 2, axis=1, keepdims=True) # shape = (1,1)
            train_sq = np.sum(self.train_images ** 2, axis=1).reshape(1, -1) # shape = (1,1000)
            distances = np.sqrt(test_sq + train_sq - 2 * dot)
            # print(np.shape(distances))
            # print(distances)
        else: 
            if metric == 'l1':
                distances = np.sum(np.abs(self.train_images - test_image), axis=1)
        distances = distances.flatten()
        indices = np.argsort(distances)[:num_neighbours]
        # distances = np.sort(distances)[:num_neighbours]

        predictions = list()
        for i in range(np.size(indices)):
            predictions.append(self.train_labels[indices[i]])

        predictions = np.array(predictions)
        p = np.argmax(np.bincount(predictions))
        return p


kcls = KnnClassifier(train_images, train_labels)

all_predictions = list()
for image in test_images:
    pred = kcls.classify_image(image)
    all_predictions.append(pred)
all_predictions = np.array(all_predictions)
np.savetxt('predictii_3nn_mnist.txt', all_predictions)

def accuracy_score(y_true, y_pred):
    return np.size(np.where(y_true == y_pred)) / np.size(y_true)

acc = accuracy_score(test_labels, all_predictions)
print(f'Acuratetea este:{acc}\n')

