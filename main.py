import matplotlib.pyplot as plt
import numpy as np

with open('samples_master.dat', 'rb') as f1:
    content1 = f1.read()

with open('samples_slave.dat', 'rb') as f2:
    content2 = f2.read()


x1 = np.frombuffer(content1, dtype=np.int16)
x2 = np.frombuffer(content2, dtype=np.int16)

data1 = []
data2 = []

number_of_channels = 8

for i in range(number_of_channels):
    data1.append(np.array([]))
    data2.append(np.array([]))
    data1[i] = np.append(data1[i], x1[i::number_of_channels])
    data2[i] = np.append(data2[i], x2[i::number_of_channels])


chan0 = (data1[0] + data1[1])
chan1 = (data1[4] + data1[5])

chan2 = (data2[0] + data2[1])
chan3 = (data2[4] + data2[5])

lags = np.arange(-len(data1[0])+1, len(data1[0]))
corr1 = np.correlate(data1[0], data1[4], mode='full')
corr2 = np.correlate(data2[0], data2[4], mode='full')
corr12 = np.correlate(data1[0], data2[0], mode='full')


maxlag1 = lags[np.argmax(corr1)]
print("SOM1 lag %d" % maxlag1)
maxlag2 = lags[np.argmax(corr2)]
print("SOM2 lag %d" % maxlag2)
maxlag12 = lags[np.argmax(corr12)]
print("SOM1-2 lag %d" % maxlag12)



plt.subplot(3, 3, (1, 3))
plt.plot(data1[0], label='1')
plt.plot(data1[4], label='2')
plt.plot(data2[0], label='3')
plt.plot(data2[4], label='4')
plt.legend()
plt.subplot(3, 3, (4, 6))
plt.plot(data1[0], label='1')
plt.plot(np.roll(data1[4], maxlag1), label='2')
plt.plot(np.roll(data2[0], maxlag12), label='3')
plt.plot(np.roll(data2[4], maxlag12+maxlag2), label='4')
plt.legend()
plt.subplot(3, 3, 7)
plt.plot(lags, corr1, label='1 - 2')
plt.legend()
plt.subplot(3, 3, 8)
plt.plot(lags, corr2, label='1 - 2')
plt.legend()
plt.subplot(3, 3, 9)
plt.plot(lags, corr12, label='1 - 2')
plt.legend()


plt.show()
