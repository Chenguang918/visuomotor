import numpy as np
import statsmodels.api as sm
from statsmodels.stats.multitest import multipletests
from scipy import stats
from mtspec import mtspec
from scipy.ndimage import median_filter
from scipy.optimize import curve_fit


def robust_est(x, fs, nw=1.5, n_tapers=None,
               med_filt_win=5, freq_cutoff=5,
               correction='bonferroni'):
    """
    Robust est. analysis as in Mann & Lees (1996).

    Parameters
    ----------
    x : np.ndarray
        The aggregated data time-course. Must have only one observation for
        each time-point, and the time-points must be equally spaced.
    fs : float
        Sampling rate of the data
    nw : float
        Time bandwidth parameter for the multitapers
    n_tapers : int
        Number of DPSS tapers. If None, set to int(2 * nw) - 1
    med_filt_win : int
        Width of the median filter used to determine the background spectrum.
    freq_cutoff : float
        Maximum frequency to look for rhythms in the time-series
    correction : str ('bonferroni', 'fdr')
        How to correct for multiple comparisons across frequencies.

    Returns
    -------
    res : dict
        A dictionary of the results of the statistical tests.
        x : np.ndarray
            The original time-series
        f : np.ndarray
            The frequencies of the Fourier transform
        y_emp : np.ndarray
            The amplitude spectrum for the data
        p_raw : np.ndarray
            Raw p-values for each frequency of the amplitude spectrum. Not
            corrected for multiple comparisons.
        p_corr : np.ndarray
            P-values corrected for multiple comparisons.
    """
    assert correction in ('bonferroni', 'fdr'), \
        'The value of `correction` must be "bonferroni" or "fdr"'

    # Detrend the data
    x = sm.tsa.tsatools.detrend(x, order=0)

    # Compute spectrum using multitapers
    if n_tapers is None:  # Number of tapers
        n_tapers = int(2 * nw) - 1
    spec, freq = mtspec(data=x,
                        delta=fs ** -1,
                        time_bandwidth=nw,
                        number_of_tapers=n_tapers,
                        statistics=False, rshape=0)

    # Smooth the spectrum with a median filter
    spec_filt = median_filter(spec, med_filt_win)

    # Fit an AR1 model of the background noise
    spec_bg = fit_ar_spec(freq, spec_filt, freq[-1])

    # Compute significance using a chi-square dist with df = 2 * n_tapers
    spec_ratio = spec / spec_bg  # Ratio of the raw spect vs background noise
    p_raw = stats.chi2.sf(spec_ratio, 2 * n_tapers)

    # Only keep the lower frequencies, ignore DC
    freq_sel = freq <= freq_cutoff
    freq_sel[0] = False  # Exclude DC
    spec = spec[freq_sel]
    spec_filt = spec_filt[freq_sel]
    spec_bg = spec_bg[freq_sel]
    freq = freq[freq_sel]
    p_raw = p_raw[freq_sel]

    # Correct for multiple comparisons
    if correction == 'bonferroni':
        _, p_corr, _, _ = multipletests(p_raw, method='bonferroni')

    elif correction == 'fdr':
        _, p_corr, _, _ = multipletests(p_raw, method='fdr_bh')

    else:
        raise Exception(f"correction method {correction} not recognized")

    # Put the results together
    res = {}
    res['x'] = x
    res['f'] = freq
    res['y_emp'] = spec
    res['p_raw'] = p_raw
    res['p_corr'] = p_corr
    return res


def fit_ar_spec(freq, spec, nyquist):
    """
    Get a spectrum's best-fit to an AR(1) process.
    Mann & Lees (1996), eq. 4

    Parameters
    ----------
    freq : np.ndarray
        The frequencies of the spectrum
    spec : np.ndarray
        The amplitude of the spectrum
    nyquist : float
        The Nyquist frequency

    Returns
    spec_fit : np.ndarray
        The spectrum that best approximates an AR(1) process fit to the data
    """
    def ar_spec(f, rho, S_0):
        """
        Spectrum of an AR(1) process at given frequency, rho, and S_0 (average
        value of the spectrum).
        """
        num = 1 - (rho ** 2)
        den = 1 - (2 * rho * np.cos(np.pi * f / nyquist)) + (rho ** 2)
        S_f = S_0 * num / den
        return S_f

    (rho, S_0), _ = curve_fit(ar_spec, freq, spec,
                              bounds=([0, 0], [1, np.inf]))
    spec_fit = ar_spec(freq, rho, S_0)

    return spec_fit
