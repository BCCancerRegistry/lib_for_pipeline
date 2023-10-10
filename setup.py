from setuptools import find_packages, setup

requirements = [line.strip() for line in open("requirements.txt").readlines()]

setup(
    name='BCCancer',
    version='1.0.0',
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    install_requires=requirements,
)