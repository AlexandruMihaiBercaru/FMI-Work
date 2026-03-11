import numpy as np
import matplotlib.pyplot as plt
from sklearn import naive_bayes
from sklearn.naive_bayes import MultinomialNB


train_images = np.loadtxt('data/train_images.txt') # incarcam imaginile
train_labels = np.loadtxt('data/train_labels.txt', 'int') # incarcam etichetele avand tipul de date int

test_images = np.loadtxt('data/test_images.txt')
test_labels = np.loadtxt('data/test_labels.txt', 'int')


# image = train_images[0, :] # prima imagine
# image = np.reshape(image, (28, 28))
# plt.imshow(image.astype(np.uint8), cmap='gray')
# plt.show()

# valorile unui pixel sunt intre 0 si 255
# 0 -> alb, 255 -> negru
# vrem sa discretizam valorile pixelilor intr-un numar fix de intervale


# --------------------- EXERCITIUL 1 --------------------------------
heights = [(160, 'F'), (165, 'F'), (155, 'F'), (172, 'F'), (175, 'B'), (180, 'B'), (177, 'B'), (190, 'B')]
height = 178
# inlocuiesc F si B cu 1 - fata, 0 - baiat

heights_num = [[t[0], int(t[1] == 'F')] for t in heights]
height_array = np.array(heights_num)

bins = np.linspace(start = 150, stop = 190, num=5)
bin_with_height = np.digitize(height, bins)

baieti = np.where(height_array[:,1] == 0)
fete = np.where(height_array[:,1] == 1)

p_f = np.size(fete) / np.size(height_array, axis = 0)
p_b = np.size(baieti) / np.size(height_array, axis = 0)

interval_bin = (int(bins[bin_with_height - 1] + 1), int(bins[bin_with_height]))

condition = (interval_bin[0] <= height_array[:,0]) & (height_array[:,0] <= interval_bin[1])
persoane_in_bin = np.extract(condition, height_array[:,1]) # 1-dim

prob_interval_fata = np.count_nonzero(persoane_in_bin == 1) / np.size(persoane_in_bin)
prob_interval_baiat = np.count_nonzero(persoane_in_bin == 0) / np.size(persoane_in_bin)

prob_fata_cu_inaltime = prob_interval_fata * p_f
prob_baiat_cu_inaltime = prob_interval_baiat * p_b

print(f'P(F|height = 178cm) = {prob_fata_cu_inaltime}')
print(f'P(B|height = 178cm) = {prob_baiat_cu_inaltime}')

# --------------------- EXERCITIUL 2 --------------------------------
num_bins = 5
bins = np.linspace(start = 0, stop = 255, num = num_bins) # contine capetele intervalelor 

# antrenare: 1000 de samples, 784 de features => n_samples = 1000, n_features = 784
def values_to_bins(matr, bins):
    digitized_pixels = np.digitize(matr, bins) - 1
    return digitized_pixels

# pe multimea de antrenare
train_images_in_bins = values_to_bins(train_images, bins)
test_images_in_bins = values_to_bins(test_images, bins)

# --------------------- EXERCITIUL 3 --------------------------------
naive_bayes_model = MultinomialNB()
naive_bayes_model.fit(train_images_in_bins, train_labels)
naive_bayes_model.predict(test_images_in_bins)
accuracy = naive_bayes_model.score(test_images_in_bins, test_labels)
print(f'Acuratetea pentru num_bins = {num_bins} este: {accuracy}.\n')

    
# --------------------- EXERCITIUL 4 --------------------------------

def test_accuracy_for_bins(bincount, nbmod):
    bins = np.linspace(start = 0, stop = 255, num = bincount) 
    train_images_in_bins = values_to_bins(train_images, bins)
    test_images_in_bins = values_to_bins(test_images, bins)
    nbmod.fit(train_images_in_bins, train_labels)
    predictions = nbmod.predict(test_images_in_bins)
    accuracy = nbmod.score(test_images_in_bins, test_labels)
    print(f'Acuratetea pentru num_bins = {bincount} este: {accuracy}.\n')
    return accuracy, predictions

bins = [3, 5, 7, 9, 11]
maxacc = -1
maxaccbins = -1
best_predictions = np.zeros(1000,)
for bin in bins:
    acc, predict = test_accuracy_for_bins(bin, naive_bayes_model)
    if maxacc < acc:
        acc = maxacc
        maxaccbins = bin
        best_predictions = predict
print(f'Cea mai buna acuratete:{maxaccbins}')
# print(best_predictions)

differences = np.where(best_predictions != test_labels)[0]
# print(differences)


for i in differences[:10]:
    img = test_images[i].reshape(28,28)
    plt.imshow(img.astype(np.uint8), cmap='gray')
    plt.title('Aceasta imagine a fost clasificata ca: ' + str(best_predictions[i]) + ', dar reprezinta cifra: ' + str(test_labels[i]))
    # plt.show()



# EXERCITIUL 6 - matricea de confuzie

def confusion_matrix(y_true, y_pred):
    classes = np.unique(y_true)
    classes_length = np.size(classes)
    mat = np.zeros((classes_length, classes_length))
    for i in range(classes_length):
        for j in range(classes_length):
            for k in range(np.size(y_true)):
                if y_true[k] == i and y_pred[k] == j:
                    mat[i][j] += 1 
    return mat

C = confusion_matrix(test_labels, best_predictions)
print(C)
