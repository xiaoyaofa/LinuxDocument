apt update
apt install gcc git make cmake
```
git clone https://github.com/OpenAMP/open-amp.git
cd open-amp
make
sudo make install
```


* build libmetal library on your host as follows:
  ```
  $ mkdir -p build-libmetal
  $ cd build-libmetal
  $ cmake <libmetal_source>
  $ make VERBOSE=1 DESTDIR=<libmetal_install> install
  ```

* build OpenAMP library on your host as follows:
   ```
  $ mkdir -p build-openamp
  $ cd build-openamp
  $ cmake <openamp_source> -DCMAKE_INCLUDE_PATH=<libmetal_built_include_dir> \
              -DCMAKE_LIBRARY_PATH=<libmetal_built_lib_dir> [-DWITH_APPS=ON]
  $ make VERBOSE=1 DESTDIR=$(pwd) install
