# retea de perceptroni in Scikit-Learn
from sklearn.neural_network import MLPClassifier # importul clasei

mlp_classifier_model = MLPClassifier( hidden_layer_sizes=(100, ),
    activation='relu', solver='adam', alpha=0.0001, batch_size='auto',
    learning_rate='constant', learning_rate_init=0.001, power_t=0.5,
    max_iter=200, shuffle=True, random_state=None, tol=0.0001,
    momentum=0.9, early_stopping=False, validation_fraction=0.1,
    n_iter_no_change=10
    )

# retea neuronala in pyTorch
import torch.nn as nn
import torch.nn.functional as F
import torch
from torch.utils.data import DataLoader
from torchvision import datasets
from torchvision.transforms import ToTensor


class NeuralNetwork(nn.Module):
    def __init__(self):
        super().__init__()
        self.flatten = nn.Flatten()
        self.first_layer = nn.Linear(28*28, 512)
        self.second_layer = nn.Linear(512, 512)
        self.output_layer = nn.Linear(512, 10)

    def forward(self, x):
        x = self.flatten(x)
        x = F.relu(self.first_layer(x))
        x = F.relu(self.second_layer(x))
        x = self.output_layer(x)
        return x
    
model = NeuralNetwork()
# model(torch.rand(5, 1, 28, 28)).shape


train_data = datasets.MNIST(
    root="data",
    train=True,
    download=True,
    # transform=ToTensor()
)

test_data = datasets.MNIST(
    root="data",    
    train=False,
    download=True,
    # transform=ToTensor()
)

train_dataloader = DataLoader(train_data, batch_size=64)
test_dataloader = DataLoader(test_data, batch_size=64)

NUM_EPOCHS=10
lr = 0.001
device = "cuda" if torch.cuda.is_available() else "cpu" # decidem device-ul pe care sa il folosim model = model.to(device)
loss_function = nn.CrossEntropyLoss() # functia ce trebuie optimizata, cross entropia

optimizer = torch.optim.SGD(model.parameters(), lr = lr, momentum=0.9, weight_decay=0.0005)

model.train(True)
for i in range(NUM_EPOCHS):
    print(f"=== Epoch {i+1} ===")
    for batch, (image_batch, labels_batch) in enumerate(train_dataloader): # iteram prin batch
        image_batch = image_batch.to(device)
        labels_batch = labels_batch.to(device) #(batch_size, )
        print(image_batch.shape)
        print(labels_batch.shape)
        pred = model(image_batch) # procesam imaginile prin retea
        print(pred.shape)
        loss = loss_function(pred, labels_batch) # determinam functia de pieredere folosind # si label-urile reale ale exemplelor de antrenare
        # Backpropagation

        optimizer.zero_grad()
        loss.backward() # backpropagation
        optimizer.step() # optimizam parametrii retelei
        if batch % 100 == 0:
            loss = loss.item()
            print(f"Batch index {batch }, loss: {loss:>7f}")


correct = 0.
test_loss = 0.
size = len(test_dataloader.dataset)
model.to(device)
model.eval()
with torch.no_grad():
    for image_batch, labels_batch in test_dataloader: # iteram prin datele de test

        image_batch = image_batch.to(device)
        labels_batch = labels_batch.to(device)
        pred = model(image_batch) # procesam imaginile folosind reteaua antrenata anterior
        test_loss += loss_function(pred, labels_batch).item()
        correct += (pred.argmax(1) == labels_batch).type(torch.float).sum().item() # numaram 
correct /= size
test_loss /= size
print(f"Accuracy: {(100*correct):>0.1f}%, Loss: {test_loss:>8f} \n")