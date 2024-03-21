import numpy as np
from scipy.interpolate import interp1d
import matplotlib.pyplot as plt

x = np.linspace(0, 9, num=10, endpoint=True)
# the energy should be modified to your own data
y = np.array([-40080.4877669,-40080.3800586,-40080.1378873,-40079.8502274,-40079.7863560,-40079.9444994,-40080.3032436,-40080.6523952,-40080.8296137,-40080.8035894])
xnew = np.linspace(0, 9, num=41, endpoint=True)

f_cubic = interp1d(x, y, kind='cubic')

plt.plot(x, y, 'o', label='data')
plt.plot(xnew, f_cubic(xnew), '--', label='cubic')
plt.legend(loc='best')
plt.xlabel("Reaction Path for Recombination")
plt.ylabel("Energy (eV)")
plt.savefig('Energyfigname.svg')