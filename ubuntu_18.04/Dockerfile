From openvino/ubuntu18_data_dev:2021.1

USER root
RUN apt-get update
RUN apt-get install -y git nasm wget vainfo clinfo vim mediainfo yasm

WORKDIR /workspace

RUN wget https://github.com/guoyejun/dnn_processing/raw/master/models/480p.mp4 && \
    wget https://github.com/guoyejun/dnn_processing/raw/master/models/espcn.bin && \
    wget https://github.com/guoyejun/dnn_processing/raw/master/models/espcn.xml

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/openvino/inference_engine/lib/intel64:/opt/intel/openvino/inference_engine/external/tbb/lib:/opt/intel/openvino/deployment_tools/ngraph/lib
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/intel/openvino/opt/intel/mediasdk/lib64/pkgconfig/

RUN git clone --depth=1 https://github.com/FFmpeg/FFmpeg ffmpeg
RUN cd ffmpeg && \
    mkdir build && cd build && \
    ../configure \
            --extra-cflags="-I/opt/intel/openvino/inference_engine/include/ -I/opt/intel/openvino/opt/intel/mediasdk/include/"\
            --extra-ldflags="-L/opt/intel/openvino/inference_engine/lib/intel64 -L/opt/intel/openvino/opt/intel/mediasdk/lib64/"\
            --enable-libopenvino --enable-vaapi && \
    make -j$(nproc) && \
    make install

RUN rm -rf ffmpeg
