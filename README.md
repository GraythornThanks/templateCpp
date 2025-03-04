# _A Cpp Template Project_

自用OpenGL项目模板

## 依赖项

### glad

```bash
python -m venv gladenv
source gladenv/bin/activate
python -m pip install glad
python -m glad --out-path ./libs/glad --generator c --api gl=4.6 --profile compatibility
deactivate
```

### glfw/glm

```bash
git submodule update --init --recursive
```
