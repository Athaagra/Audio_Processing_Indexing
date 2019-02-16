import os
import pandas as pd
import librosa
import librosa.display
import glob
% pylab inline
from sklearn.preprocessing import LabelEncoder
import numpy as np
from scipy.fftpack import fft
from scipy import signal
from scipy.io import wavfile
from keras.utils import np_utils
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation, Flatten
from keras.layers import Convolution2D, MaxPooling2D
from keras.optimizers import Adam
from sklearn import metrics 
import os
print(os.listdir("../input"))
def parser(row):
    file_name = os.path.join(os.path.abspath('../input/train/'),'Train',str(row.ID)+'.wav')
    try:
        # here kaiser_fast is a technique used for faster extraction
        X,sample_rate = librosa.load(file_name,res_type='kaiser_fast')
        # we extract mfcc feature from data
        mfccs = np.mean(librosa.feature.mfcc(y=X,sr=sample_rate,n_mfcc=40).T,axis=0)
    except Exception as e:
        print('Error encountered while parsing the file:',file_name)
        
        return 'None', 'None'
    feature = mfccs  
    label = row.Class
    #print(file_name)
    print(feature)
    print(label)
    return pd.Series([feature, label],index=['feature','label'])
temp = train.apply(parser,axis =1)
temp.columns = ['feature', 'label']
