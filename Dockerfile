# syntax=docker/dockerfile:1

FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
cmake \
make \
gcc \
g++ \
python3 \
xz-utils

ADD https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/llvm-8.0.1.src.tar.xz /tmp/llvm-8.0.1.src.tar.xz
ADD https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/cfe-8.0.1.src.tar.xz /tmp/cfe-8.0.1.src.tar.xz

RUN tar -xf /tmp/llvm-8.0.1.src.tar.xz -C /tmp
RUN tar -xf /tmp/cfe-8.0.1.src.tar.xz -C /tmp
RUN mv /tmp/cfe-8.0.1.src /tmp/llvm-8.0.1.src/projects/clang
RUN rm /tmp/llvm-8.0.1.src.tar.xz
RUN rm /tmp/cfe-8.0.1.src.tar.xz

RUN mkdir /tmp/build
RUN cmake -B /tmp/build /tmp/llvm-8.0.1.src \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_CXX_FLAGS="-std=c++11 -Wno-redundant-move -Wno-format-truncation"
RUN cd /tmp/build && make -j`nproc`
RUN cd /tmp/build && make install

# only bring clang-format over
FROM ubuntu:20.04
COPY --from=0 /usr/local/bin/clang-format* /usr/local/bin/.

WORKDIR /src