"""
Tools to perform analyses by shuffling in time, as in Landau & Fries (2012) and
Fiebelkorn et al. (2013).
"""

import numpy as np
import statsmodels.api as sm
from statsmodels.stats.multitest import multipletests
from .utils import avg_repeated_timepoints, dft

behav_details = {
    "landau": {  # Landau & Fries (2012, Curr Biol)
        "k_perm": 500,  # Number of permutations in the randomization test
        "n_trials": 104,  # 2 trials / lag / loc / subj: 2 * 52 lags in FFT = 104
        "n_subjects": 16,  # Number of participants
        "fs": 60,  # Sampling rate of the behavioral time-series
        "t_start": 0.150,  # Time-stamp of the first point used to compute the spectra
        "t_end": 1.000,  # Time-stamp of the last point used to compute the spectra
        "nfft": 256  # Not specified. This tries to match their freq resolution
    },
    "fiebelkorn": {  # Fiebelkorn et al (2013, Curr Biol)
        "k_perm": 1000,
        "n_trials": 441,  # Number of trials per location per subject (summed over lags)
        "n_subjects": 15,
        "fs": 60,  # Not specified, but this is superceded by the binning procedure
        "t_start": 0.300,
        "t_end": 1.100,
        "nfft": 128,  # Not specified. This tries to match their freq resolution
        "f_max": 12,  # Only reported up to 12 Hz
        "bin_step": 0.01,  # Step size between moving average bins
        "bin_width": 0.05  # Width of the moving average bins
    }
}


def lf2012(x, t, fs, k_perm='lf2021'):
    """
    Analyze the data as in Landau & Fries (2012)

    Parameters
    ----------
    x : nd.array
        Array of Hit (1) or Miss (0) for each trial
    t : nd.array
        The time-stamps for each trial
    fs : float
        The sampling rate of the behavioral time-series. This is the inverse of
        the time interval between different possible time-stamps. Note: This
        analysis requires time-stamps to be "quantized" to a certain sampling
        rate.
    k_perm : int or 'lf2012'
        The number of times to randomly shuffle the data when computing the
        permuted surrogate distribution. 'lf2012' defaults to the value chosen
        in Landau and Fries (2012)


    Returns
    -------
    res : dict
        The results of the randomization test as returned by
        `time_shuffled_perm`, plus these items:
        t : np.ndarray
            The time-stamps of the individual trials
        t_agg : np.ndarray
            The time-steps for the aggregated accuracy time-series
        x_agg : np.ndarray
            The aggregated accuracy time-series
        p_corr : np.ndarray
            P-values corrected for multiple comparisons using Bonforroni
            correction
    """

    if k_perm == 'lf2012':
        k_perm = behav_details['landau']['k_perm']

    def landau_spectrum_trialwise(x_perm):
        """ Helper to compute spectrum on shuffled data
        """
        _, x_avg = avg_repeated_timepoints(t, x_perm)
        f, y = landau_spectrum(x_avg, fs)
        return f, y

    # Compute the results
    res = time_shuffled_perm(landau_spectrum_trialwise, x, k_perm)
    res['t'] = t
    res['t_agg'], res['x_agg'] = avg_repeated_timepoints(t, x)

    # Correct for multiple comparisons across frequencies
    _, p_corr, _, _ = multipletests(res['p'], method='bonferroni')
    res['p_corr'] = p_corr
    return res


def landau_spectrum(x, fs, detrend_ord=1):
    """
    Get the spectrum of behavioral data as in Landau & Fries (2012)

    The paper doesn't specifically mention detrending, but A.L. says they
    always detrend with a 2nd-order polynomial. That matches the data --
    without detrending, there should have been a peak at freq=0 due to the
    offset from mean accuracy being above 0.
    2021-06-14: AL tells me they used linear detrending.

    The paper says the data were padded before computing the FFT, but doesn't
    specify the padding or NFFT. I've chosen a value to match the frequency
    resolution in the plots.

    Parameters
    ----------
    x : np.ndarray
        The data time-series

    Returns
    -------
    f : np.ndarray
        The frequencies of the amplitude spectrum
    y : np.ndarray
        The amplitude spectrum
    """
    details = behav_details['landau']
    # Detrend the data
    x = sm.tsa.tsatools.detrend(x, order=detrend_ord)
    # Window the data
    x = window(x, np.hanning(len(x)))
    # Get the spectrum
    f, y = dft(x, fs, details['nfft'])
    return f, y


def fsk2013(x, t,
            k_perm='fsk2013',
            nfft='fsk2013',
            t_start=None,
            t_end=None,
            bin_step='fsk2013',
            bin_width='fsk2013',
            f_max='fsk2013'):
    """
    Search for statistically significant behavioral oscillations as in
    Fiebelkorn et al. (2013)

    Parameters
    ----------
    x : np.ndarray
        Array of Hit (1) or Miss (0) for each trial
    t : np.ndarray
        The time-stamps for each trial
    k_perm : int or 'fsk2013'
        The number of times to randomly shuffle the data when computing the
        permuted surrogate distribution. 'fsk2013' defaults to the value chosen
        in Fiebelkorn et al. 2013.
    nfft : int or 'fsk2013'
        The number of samples used to compute the FFT. 'fsk2013' defaults to
        the value chosen in Fiebelkorn et al. 2013.
    t_start : float or None
        The time stamp of the center of the first window. If None, use the
        first time-step.
    t_end : float
        The time stamp of the center of the last window. If None, use the last
        time-step.
    bin_step : float or 'fsk2013'
        The step distance between windows. 'fsk2013' defaults to the value
        chosen in Fiebelkorn et al. 2013.
    bin_width : float or 'fsk2013'
        The width of the sliding window. 'fsk2013' defaults to the value chosen
        in Fiebelkorn et al. 2013.
    f_max : float or 'fsk2013'
        The maximum frequency to include in the analysis. 'fsk2013' defaults to
        the value chosen in Fiebelkorn et al. 2013.

    Returns
    -------
    res : dict
        The results as given by `time_shuffled_perm`plus these items:
        t : np.ndarray
            The original time-stamps of the raw data
        p_corr : np.ndarray
            P-values for each frequency, corrected for multiple comparisons
            using FDR
    """
    if t_start is None:
        t_start = np.min(t)
    if t_end is None:
        t_end = np.max(t) + 1e-10
    details = behav_details['fiebelkorn']
    spec_kwargs = {'nfft': nfft,
                   't_start': t_start,
                   't_end': t_end,
                   'bin_step': bin_step,
                   'bin_width': bin_width,
                   'f_max': f_max}
    for k, v in spec_kwargs.items():
        if v == 'fsk2013':
            spec_kwargs[k] = details[k]

    # Compute the results
    res = time_shuffled_perm(lambda xx: fiebelkorn_spectrum(xx, t, **spec_kwargs),
                             x, k_perm)
    res['t'] = t

    # Correct for multiple comparisons across frequencies
    _, p_corr, _, _ = multipletests(res['p'], method='fdr_bh')
    res['p_corr'] = p_corr
    return res


def fiebelkorn_binning(x_trial, t_trial,
                       t_start, t_end,
                       bin_step, bin_width):
    """
    Given accuracy and time-points, find the time-smoothed average accuracy in a sliding window

    Parameters
    ----------
    x_trial : np.ndarray
        Accuracy (Hit: 1, Miss: 0) of each trial
    t_trial : np.ndarray
        The time-stamp of each trial
    t_start : float
        The time stamp of the center of the first window
    t_end : float
        The time stamp of the center of the last window
    bin_step : float
        The step distance between windows
    bin_width : float
        The width of the sliding window

    Returns
    -------
    x_bin : np.ndarray
        The average accuracy within each time bin
    t_bin : np.ndarray
        The centers of each time bin
    """
    # Time-stamps of the center of each bin
    t_bin = np.arange(t_start,
                      t_end + 1e-10,
                      bin_step)
    # Accuracy within each bin
    x_bin = []
    for i_bin in range(len(t_bin)):
        bin_center = t_bin[i_bin]
        bin_start = bin_center - (bin_width / 2)
        bin_end = bin_center + (bin_width / 2)
        bin_sel = (bin_start <= t_trial) & (t_trial <= bin_end)
        x_bin_avg = np.mean(x_trial[bin_sel])
        x_bin.append(x_bin_avg)
    x_bin = np.array(x_bin)

    return x_bin, t_bin


def fiebelkorn_spectrum(x, t, nfft,
                        t_start, t_end,
                        bin_step, bin_width,
                        f_max='fsk2013'):
    """
    Compute the spectrum of accuracy data as in Fiebelkorn et al. (2013)

    Parameters
    ----------
    x : np.ndarray
        The data for each trial
    t : np.ndarray
        The time-stamp for each trial
    nfft : int
        The number of samples used to compute the FFT
    t_start : float
        The time stamp of the center of the first window
    t_end : float
        The time stamp of the center of the last window
    bin_step : float
        The step distance between windows
    bin_width : float
        The width of the sliding window
    f_max : float or 'fsk2013'
        The maximum frequency to include in the analysis. 'fsk2013' defaults to
        the value chosen in Fiebelkorn et al. 2013.

    Returns
    -------
    f : np.ndarray
        The frequencies of the resulting spectrum
    y : np.ndarray
        The amplitude spectrum
    """
    # Get the moving average of accuracy
    x_bin, t_bin = fiebelkorn_binning(x, t,
                                      t_start, t_end,
                                      bin_step, bin_width)
    # Detrend the binned data
    x_bin = sm.tsa.tsatools.detrend(x_bin, order=2)
    # Window the data
    x_bin = window(x_bin, np.hanning(len(x_bin)))
    # Get the spectrum
    f, y = dft(x_bin, 1 / bin_step, nfft)
    # Only keep frequencies that were reported in the paper
    if f_max == 'fsk2013':
        f_max = behav_details['fiebelkorn']['f_max']
    f_keep = f <= f_max
    f = f[f_keep]
    y = y[f_keep]
    return f, y


def time_shuffled_perm(analysis_fnc, x, k_perm):
    """
    Run a permutation test by shuffling the time-stamps of individual trials.

    Parameters
    ----------
    analysis_fnc : function
        The function that will be used to generate the spectrum
    x : np.ndarray
        The data time-series
    k_perm : int
        How many permutations to run

    Returns
    -------
    res : dict
        Dictionary of the results of the randomization analysis
        x : np.ndarray
            The raw data
        x_perm : np.ndarray
            The shuffled data
        f : np.ndarray
            The frequencies of the resulting spectrum
        y_emp : np.ndarray
            The spectrum of the empirical (unshuffled) data
        y_avg : np.ndarray
            The spectra of the shuffled permutations
        y_cis : np.ndarray
            Confidence intervals for the spectra, at the 2.5th, 95th, and
            97.5th percentile
        p : np.ndarray
            P-values (uncorrected for multiple comparisons) for each frequency
    """

    # Compute the empirical statistics
    f, y_emp = analysis_fnc(x)

    # Run a bootstrapped permutation test.
    # Create a surrogate distribution by randomly shuffling resps in time.
    x_perm = []
    y_perm = []
    x_shuff = x.copy()
    for k in range(k_perm):
        np.random.shuffle(x_shuff)
        _, y_perm_k = analysis_fnc(x_shuff)
        y_perm.append(y_perm_k)
        if k < 10:  # Keep a few permutations for illustration
            x_perm.append(x_shuff.copy())

    # Find statistically significant oscillations
    # Sometimes we get p=0 if no perms are larger than emp. Note that in this
    # case, a Bonferroni correction doesn't have any effect on the p-values.
    p = np.mean(np.vstack([y_perm, y_emp]) > y_emp, axis=0)

    # Get summary of simulated spectra
    y_avg = np.mean(y_perm, 1)
    y_cis = np.percentile(y_perm, [2.5, 95, 97.5], 1)

    # Bundle the results together
    res = {}
    res['x'] = x
    res['x_perm'] = np.array(x_perm)
    res['f'] = f
    res['y_emp'] = y_emp
    res['y_perm'] = np.array(y_perm)
    res['y_avg'] = y_avg
    res['y_cis'] = y_cis
    res['p'] = p

    return res


def window(x, win):
    """ Apply a window to a segment of data

    Parameters
    ----------
    x : np.ndarray
        The data
    win : np.ndarray
        The window

    Returns
    -------
    x : np.ndarray
        The windowed data
    """
    return np.multiply(win, x.T).T
