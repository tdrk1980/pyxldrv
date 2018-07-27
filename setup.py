
# *-* encoding: utf-8 *-*
# build command:
# python setup.py build_ext -i --compiler=msvc

# https://blog.ymyzk.com/2014/11/setuptools-cython/

from distutils.core import setup, Extension
from Cython.Build import cythonize


ext = Extension(
    "vxlapi",
    sources=["vxlapi.pyx"],
    libraries=["vxlapi64"],
    language="c++",
    define_macros=[("NOMINMAX",None)] # disable min/max marco see http://d.hatena.ne.jp/yohhoy/20120115/p1
)

setup(
    ext_modules=cythonize(ext)
)