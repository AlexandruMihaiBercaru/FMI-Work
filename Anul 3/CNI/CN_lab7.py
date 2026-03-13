"""
Calcul Numeric - Lab 7 (Antrenarea Dictionarelor)
Bercaru Alexandru
Grupa 331
"""

import numpy as np
# from dictlearn import DictionaryLearning -> am avut probleme la apelul metodei "fit"
from dictlearn import methods
from matplotlib import image
from matplotlib import pyplot as plt
from sklearn.feature_extraction.image import extract_patches_2d, reconstruct_from_patches_2d
from sklearn.preprocessing import normalize
from sklearn.decomposition import DictionaryLearning

p = 8           # dimensiune patch
s = 6           # sparsitate
N = 1000        # numar total patch-uri
n = 256         # numar atomi dictionar
K = 50          # numar iteratii
sigma = 0.075   # deviatia standard a zgomotului

def show(caption, imag):
    plt.title(caption)
    plt.imshow(imag, cmap='gray')
    plt.show()

# Peak Signal to Noise Ratio
def psnr(img1, img2):
    mse = np.mean((img1 - img2) ** 2)
    if mse == 0:
        return 0
    max_pixel = 255
    psnr = 20 * np.log10(max_pixel / np.sqrt(mse))
    return psnr

I = image.imread('base.jpeg')
# transform imaginea in grayscale
I = I[:, :, 0] * 0.299 + I[:, :, 1] * 0.587 + I[:, :, 2] * 0.114
print(f"Dimensiunile imaginii: w={I.shape[1]}, h={I.shape[0]}") 

I_noisy = I + sigma * np.random.randn(I.shape[0], I.shape[1])
print(I_noisy.shape)

# extrag patch-uri din imaginea cu zgomot adaugat
Y_noisy = extract_patches_2d(image=I_noisy, patch_size=(p, p))

print(f'Inainte de vectorizare: {Y_noisy.shape}')
# vectorizarea patch-urilor
Y_noisy = Y_noisy.reshape(Y_noisy.shape[0], -1)
print(f'Dupa vectorizare : {Y_noisy.shape}')

Y_noisy = Y_noisy.T

# centram in 0 fiecare patch/semnal (calculam media de-a lungul coloanelor)
patch_mean = np.mean(Y_noisy, axis=0)
print(patch_mean.shape)
Y_noisy = Y_noisy - patch_mean
print(Y_noisy.shape)

# selectez aleator N semnale din Y_noisy
indices = np.random.choice(Y_noisy.shape[1], N)
# print(indices)
Y = Y_noisy[:, indices]
print(Y.shape)

# Y = D * X
# (m, N) = (m, n) * (n, N)
# m = 64 (dimensiunea unui patch vectorizat)

# generam aleator un dictionar de dimensiune (m, n)
D0 = np.random.randn(Y.shape[0], n)
D0 = normalize(D0, axis=0, norm='l2')

# antrenarea dictionarului
# dl = DictionaryLearning(
#     n_components=n,
#     max_iter=K,
#     fit_algorithm='ksvd',
#     n_nonzero_coefs=s,
#     code_init=None,
#     dict_init=D0,
#     params=None,
#     data_sklearn_compat=False
# )

# dl.fit(Y)
# D = dl.D_


Y_for_sklearn = Y.T  # shape = (N, m)
dict_learner = DictionaryLearning(
    n_components=n,
    alpha=1,                    # regularizarea
    fit_algorithm='cd',         
    transform_algorithm='omp',  
    transform_n_nonzero_coefs=s,
    verbose=1,
    dict_init=D0.T              # (n, m)
)
dict_learner.fit(Y_for_sklearn)
D = dict_learner.components_.T
print(f'Dictionarul antrenat: {D.shape}')

# calculam reprezentarea rara pentru Y_noisy
Xc, err = methods.omp(Y_noisy, D, n_nonzero_coefs=s)
print(Xc.shape)
# semnalele (patch-urile) curate
Yc = np.matmul(D, Xc)
Yc += patch_mean

Yc = Yc.T
print(Yc.shape)
patches = Yc.reshape(Yc.shape[0], p, p)
print(patches.shape)
# reconstruim imaginea curata 
Ic = reconstruct_from_patches_2d(patches, image_size=I.shape)

show("Imaginea initiala", I)
show("Imaginea cu zgomot", I_noisy)
show("Imaginea cu zgomot eliminat", Ic)

noisy = psnr(I, I_noisy)
denoised = psnr(I, Ic)
print(f'Valoarea PSNR (Peak Signal to Noise Ratio) pentru imaginea cu zgomot: {noisy}')
print(f'Valoarea PSNR pentru imaginea denoised: {denoised}')
# noisy > denoised, corect ar trebui sa fie invers [?]


