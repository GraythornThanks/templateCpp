# _A Cpp Template Project_

自用C++项目模板

gl-demo为`glfw+glad`模板
qt-demo为`qt`模板

添加依赖项后，在主cmakelists中添加`add_subdirectory`选择模板

## 依赖项

---------

> MinGW用户建议手动构建

### glad

```bash
python -m venv gladenv
source gladenv/bin/activate
python -m pip install glad
python -m glad --out-path ./libs/glad --generator c --api gl=4.6 --profile compatibility
deactivate
```

### 从源码构建 glfw/glm

#### gitsubmodule

```bash
git submodule update --init --recursive
```

----------

> MSVC或Linux/Unix用户建议直接使用包管理器构建

### 从包管理器构建 glfw/glm

#### Windows

```pwsh
vcpkg install glad glfw3 glm
```

#### ArchLinux

Todo
