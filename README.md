# pyxldrv

[Vector XL Driver Library][1] Wrapper for Python.

## What

<<<<<<< HEAD
- [Vector XL Driver Library][1] inlclude dlls for C/C++, C# but not for Python.
- pyxldrv wraps dlls for C/C++ as imporable library(vxlapi).
    - To wrap C/C++ dll, pyxldrv uses Cython.
    - Cython generates a library for Python("vxlapi.xxxxxx.pyd") from Cython codes(vxlapi.pxd and vxlapi.pyx).
=======
- [Vector XL Driver Library][1] inlclude dlls for C/C++, C# but not for Python
- 
>>>>>>> 1f1b8fc55689e63532b35018d56c52a9d9c86c00

```
import vxlapi as xl

ret = xl.OpenDriver()

...

<<<<<<< HEAD
ret = xl.CloseDriver()
```
=======
CANoe : One of the most famous Automotive Network Analyzer.

:Vector Driver supports "Virtual CAN Bus"(used for unit test). So, wihtout both Network interfaces and CANoe, you can test XLDriverLibrary/xldrv.
>>>>>>> 1f1b8fc55689e63532b35018d56c52a9d9c86c00


## Installation

### CANoe

- Get XL Driver Library and Vector Driver Setup from [Vector Download-Center][2] and install them.

![xldriver](./images/Vector_XL_Driver_Library.png)

![VectorDriverSetup](./images/Vector_Driver_Setup.png)

- If you use Windows7/8.1/10(64bit), you can use CANoe Demo version for testing.
    - Check CANoe 11.0 (64 bit)
    - Click "> Continue". Please note that it requires "contact information".

![CANoe Demo](./images/CANoeDemo.png)


## Cython and build tool

- Get Cython via pip at first.

- For Python 3.6
    - Get [Build Tools for Visual Studio 2017](https://www.visualstudio.com/ja/downloads).


## build command

```
python setup.py build_ext -i --compiler=msvc
```

setup.py supports only for 64bit version but you can use

## basic test

```
python -m unittest tests.test_basic
```

## License

## ref
- https://blog.ymyzk.com/2014/11/setuptools-cython/
- https://blog.ymyzk.com/2014/11/setuptools-cython/
- http://qh73xebitbucketorg.readthedocs.io/ja/latest/1.Programmings/python/LIB/cython/wrapperforcpp/
- https://vector.com/vi_xl_driver_library_en.html

<!--Reference-->
[1]:https://vector.com/vi_xl_driver_library_en.html
[2]:https://vector.com/vi_downloadcenter_en.html
[3]:https://vector.com/vi_vn1600_en.html
[4]:https://vector.com/vi_canoe_en.html
