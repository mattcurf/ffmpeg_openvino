# ffmpeg_play

This folder explores use of FFmpeg with OpenVINO, as announced by this commit ID https://github.com/FFmpeg/FFmpeg/commit/ff37ebaf30e675227655d9055069471bb45e5ceb. More information about its development is available at https://www.programmersought.com/article/45435342115/

## Building

The following steps will build the dockerfile and demonstrate AI based Super Resolution filter in ffmpeg.

```bash
$ cd ubuntu_20.04
$ ./build.sh
$ ./benchmark.sh
```

Using a 720x480 input stream, the benchmark.sh script will output a 1440x960 output stream using 4 different combinations of CPU and GPU media and compute acceleration
