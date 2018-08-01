# pyxldrv

[Vector XL Driver Library][1] Wrapper for Python.

## What

- xldrv is a wrapper of [Vector XL Driver Library][1] for Python.
- [Vector XL Driver Library][1] inlclude dlls for C/C++, C# but not for Python, which are used to control Vector's Network interfaces without [CANoe][4]


CANoe : One of the most famous Automotive Network Analyzer 
[^vec2]:Vector Driver supports "Virtual CAN Bus"(used for unit test). So, wihtout both Network interfaces and CANoe, you can test XLDriverLibrary/xldrv.


## Installation

- Get XL Driver Library and Vector Driver Setup from [Vector Download-Center][2] and install them.

![xldriver](./images/Vector_XL_Driver_Library.PNG)

![VectorDriverSetup](./images/vector_Driver_Setup.PNG)

- If you used Windows10(64bit), get CANoe 


## build command

```
python setup.py build_ext -i --compiler=msvc
```

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
