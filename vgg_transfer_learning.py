#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Oct 21 15:08:52 2018

@author: sakis
"""

from builtins import range, input

from keras.layers import Input, Lambda, Dense, Flatten
from keras.models import Model
from keras import optimizers
from keras.applications.vgg16 import VGG16
from keras.applications.vgg16 import preprocess_input
from keras.models import load_model
from keras.preprocessing import image
from keras.preprocessing.image import ImageDataGenerator
from sklearn.metrics import confusion_matrix
import numpy as np
import matplotlib.pyplot as plt
from glob import glob
import os

os.chdir('/home/sakis/Desktop/train/')

# training config:
epochs = 1
batch_size = 32
#new image size
IMAGE_SIZE = [50,50]

#train_path = 'train_pics'
#valid_path = 'val_pics'
train_path = 'train_small/train_pics'
valid_path = 'train_small/val_pics'

#useful for getting number of files
image_files = glob(train_path + '/*/*.pn*g')
valid_image_files = glob(valid_path + '/*/*.pn*g')

#useful for getting number of files
folders = glob(train_path + '/*')

#show an image
plt.imshow(image.load_img(np.random.choice(image_files)))
plt.show()

#add preprocessing layer to the front of VGG
vgg = VGG16(input_shape=IMAGE_SIZE + [3], weights='imagenet', include_top=False)

# don't train existing weights
for layer in vgg.layers:
     layer.trainable = False

# our layers - you can add more if you want
x = Flatten()(vgg.output)
#x = Dense(1000, activation='relu')(x)
prediction = Dense(len(folders), activation='softmax')(x)


# create a model object
model = Model(inputs=vgg.input, outputs=prediction)

# view the structure of the model
model.summary()
rms = optimizers.RMSprop(lr=0.001,epsilon=1e-6)
sgd = optimizers.SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True)
adam = optimizers.Adam(lr=0.001,epsilon=1e-6)
# tell the model what cost and optimization method to use
model.compile(
  loss='categorical_crossentropy',
  optimizer=adam,
  metrics=['accuracy']
)



# create an instance of ImageDataGenerator
gen = ImageDataGenerator(
  #width_shift_range=0.1,
  #height_shift_range=0.1,
  #shear_range=0.1,
  #zoom_range=0.2,
  #horizontal_flip=True,
  #vertical_flip=True,
  preprocessing_function=preprocess_input
)

#valid_gen = ImageDataGenerator(rescale=1. / 255)

test_gen = gen.flow_from_directory(valid_path, target_size=IMAGE_SIZE)
print(test_gen.class_indices)
labels = [None] * len(test_gen.class_indices)
for k, v in test_gen.class_indices.items():
  labels[v] = k

# should be a strangely colored image (due to VGG weights being BGR)
for x, y in test_gen:
  print("min:", x[0].min(), "max:", x[0].max())
  plt.title(labels[np.argmax(y[0])])
  plt.imshow(x[0])
  plt.show()
  break
# create generators
train_generator = gen.flow_from_directory(
  train_path,
  target_size=IMAGE_SIZE,
  shuffle=True,
  batch_size=batch_size,
)
valid_generator = gen.flow_from_directory(
  valid_path,
  target_size=IMAGE_SIZE,
  shuffle=True,
  batch_size=batch_size,
)

# fit the model
r = model.fit_generator(
  train_generator,
  validation_data=valid_generator,
  epochs=epochs,
  steps_per_epoch=len(image_files) // batch_size,
  validation_steps=len(valid_image_files) // batch_size,
)
print(r.history, file=open('History-rms.txt', 'w'))


def get_confusion_matrix(data_path, N):
  # we need to see the data in the same order
  # for both predictions and targets
  print("Generating confusion matrix", N)
  predictions = []
  targets = []
  i = 0
  for x, y in gen.flow_from_directory(data_path, target_size=IMAGE_SIZE, shuffle=False, batch_size=batch_size * 2):
    i += 1
    if i % 50 == 0:
      print(i)
    p = model.predict(x)
    p = np.argmax(p, axis=1)
    y = np.argmax(y, axis=1)
    predictions = np.concatenate((predictions, p))
    targets = np.concatenate((targets, y))
    if len(targets) >= N:
      break

  cm = confusion_matrix(targets, predictions)
  return cm


cm = get_confusion_matrix(train_path, len(image_files))
print(cm,file=open('conf_train.txt', 'w'))
valid_cm = get_confusion_matrix(valid_path, len(valid_image_files))
print(valid_cm,file=open('Conf_valid.txt', 'w'))


