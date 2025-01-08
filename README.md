# _A Cpp Template Project_

自用C++项目模板

## 依赖

OpenGL版本

```bash
glxinfo | grep OpenGL
```

### glad

```bash
python -m pip install glad
python -m glad --out-path ./libs/glad --generator c --api gl=4.6 --profile compatibility
```

### 从源码构建 glfw/glm

#### gitsubmodule

```bash
# 初始化子模块
git submodule init

# 更新子模块
git submodule update
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