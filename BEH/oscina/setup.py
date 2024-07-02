import os.path
from setuptools import setup

# Get the current version number from inside the module
with open(os.path.join('oscina', 'version.py')) as version_file:
    exec(version_file.read())

# Load the required dependencies from the requirements file
with open("requirements.txt") as requirements_file:
    install_requires = requirements_file.read().splitlines()

setup(
    name='oscina',
    version=__version__,  # noqa: F821
    description='OscInA: tools to test for oscillations in autocorrelated signals',
    url='https://github.com/gbrookshire/oscina',
    author='Geoffrey Brookshire',
    packages=['oscina'],
    python_requires='>=3.6',
    install_requires=install_requires,
    tests_require=['unittest'],
)
