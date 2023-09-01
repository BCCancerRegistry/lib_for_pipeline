from setuptools import setup
with open('requirements.txt') as f:
    required = f.read().splitlines()
setup(name='bccandatapipe',
      version='1.0',
      description='ML Pipeline for BC Cancer',
      author='Sunny Rathee',
      author_email='sunny.rathee@phsa.ca',
      packages=required,
     )