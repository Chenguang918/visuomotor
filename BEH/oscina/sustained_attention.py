import math

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import scipy.io as sio
import sys
import oscina
from sklearn import preprocessing as pp

sys.path.append('..')
# import oscina
np.random.seed(0)  # Set the random seed for reproducibility


def plot_results_AR(res):
    plt.plot(res['f'],res['y_emp'],label='Spectrum')
    # plt.plot(res_con['f'], res_con['y_emp'], label='Spectrum')
    if 'y_perm' in res:
        plt.plot(res['f'],np.percentile(res['y_perm'],95,axis=0),'--k',label='95% CI')
    signif = res['p_corr'] < .05
    plt.plot(res['f'][signif],res['y_emp'][signif],'*r',label='p<.05')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Amplitude')
    plt.xlim(1, 5)
    plt.legend()
    plt.show()

def plot_results_RO(res):
    plt.plot(res['f'],res['y_emp'],label='Spectrum')
    # plt.plot(res_con['f'], res_con['y_emp'], label='Spectrum')
    if 'y_perm' in res:
        plt.plot(res['f'],np.percentile(res['y_perm'],95,axis=0),'--k',label='95% CI')
    signif = res['p_corr'] < .05
    plt.plot(res['f'][signif],res['y_emp'][signif],'*r',label='p<.05')
    plt.xlabel('Frequency (Hz)')
    plt.ylabel('Amplitude')
    plt.xlim(1, 5)
    plt.ylim(0, 0.00006)
    plt.legend()
    plt.show()

if __name__ == '__main__':
    n_timepoints = 25
    n_obs_per_timepoint = 100
    f_sample = 10.0
    # osc_freq = 8.0
    # osc_amp = 3.0

    # Simulate an oscillation plus random walk noise
    # t = np.arange(n_timepoints) / f_sample
    # x = np.cumsum(np.random.normal(size=n_timepoints))
    # osc = osc_amp * np.sin(2 * np.pi * osc_freq * t)
    # x = x + osc

    # Load experiment data
    aFile='D:\\Sustained attention\\Exp1\\Data\\Beh\\Transfered-ZH\\attention_data_re.mat'
    aData=sio.loadmat(aFile)
    behdata_a = aData['behData_att_all']

    cFile='D:\\Sustained attention\\Exp1\\Data\\Beh\\Transfered-ZH\\control_data_re.mat'
    cData=sio.loadmat(cFile)
    behdata_c = cData['behData_con_all']

    t = np.transpose(behdata_a[:,0,:])
    xa = np.transpose(behdata_a[:,4,:])
    xc = np.transpose(behdata_c[:,4,:])

    # xa = pp.scale(xa,axis=0)
    # xc = pp.scale(xc, axis=0)

    xa_avg =xa.mean(axis=1)
    xc_avg = xc.mean(axis=1)
    t_avg =t.mean(axis=1)
    x_SE_up =xa_avg + (xa.std(axis=1)/(math.sqrt(n_obs_per_timepoint)))
    x_SE_down = xa_avg - (xa.std(axis=1) / (math.sqrt(n_obs_per_timepoint)))

    # plt.plot(t, xa, 'o', alpha=0.1)
    plt.plot(t_avg, xa_avg, '-k')
    plt.plot(t_avg, x_SE_up, '-r')
    plt.plot(t_avg, x_SE_down, '-r')
    plt.xlabel('Time(s)')
    plt.ylabel('Amplitude')
    plt.ylim(10, 20)
    plt.title('Avg Attention')
    plt.show()

    res_a = oscina.ar_surr(xa_avg, f_sample, k_perm=500)
    plt.title('AR Surrogate attention')
    plot_results_AR(res_a)

    x_SE_up =xc_avg + (xc.std(axis=1)/(math.sqrt(n_obs_per_timepoint)))
    x_SE_down = xc_avg - (xc.std(axis=1) / (math.sqrt(n_obs_per_timepoint)))
    plt.plot(t_avg, xc_avg, '-k')
    plt.plot(t_avg, x_SE_up, '-r')
    plt.plot(t_avg, x_SE_down, '-r')
    plt.xlabel('Time(s)')
    plt.ylabel('Amplitude')
    plt.ylim(10, 20)
    plt.title('Avg simple')
    plt.show()

    res_c = oscina.ar_surr(xc_avg, f_sample, k_perm=500)
    plt.title('AR Surrogate simple')
    plot_results_AR(res_c)

    # res_a = oscina.robust_est(xa_avg, f_sample)
    # res_c = oscina.robust_est(xc_avg, f_sample)
    # plt.title('Robust estimate')
    # plot_results_RO(res_a)



    # res_a = oscina.lf2012(xa, t, f_sample, k_perm=1000)
    # res_c = oscina.lf2012(xc, t, f_sample, k_perm=1000)
    # plt.title('LF2012')
    # plot_results(res_a)


    #
    # res = oscina.fsk2013(x, t, k_perm=500, f_max=10)
    # plot_results(res)
    # plt.title('FSK2013')



