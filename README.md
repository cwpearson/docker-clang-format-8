# docker-clang-format-8
clang-format-8 in Docker

```
docker build -t cwpearson/clang-format:8.0.1 .
docker build --progress=plain -t cwpearson/clang-format:8.0.1 .
```

```
docker run --rm -v `pwd`:/src cwpearson/clang-format:8.0.1 clang-format --style=Google /src/main.cpp
```