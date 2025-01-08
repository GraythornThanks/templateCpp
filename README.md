# _A Cpp Template Project_

自用C++项目模板

demo1为`glfw+glad`模板
demo2为`qt`模板

添加依赖项后，在主cmakelists中添加`add_subdirectory`选择模板

## 依赖项

### glad

```bash
python -m pip install glad
python -m glad --out-path ./libs/glad --generator c --api gl=4.6 --profile compatibility
```

### 从源码构建 glfw/glm

#### gitsubmodule

```bash
git submodule update --init --recursive
```

### 从包管理器构建 glfw/glm

#### Windows

```pwsh
vcpkg install glfw glm
```

#### ArchLinux

```bash
sudo pacman -S freeglut glu libglvnd mesa glfw glm
```