# soprocli

grpc clients pre-compiled


###  Compile

1. Edit on ./internal/your_package/your_package.proto
2. Run the following command

```bash
# compile
make compile tag=v1.54.2 verbose=true
# release new version
python3 -m pip install --upgrade build
python3 -m build
# install local wheel
pip3 install dist/soprocli-0.0.2-py3-none-any.whl

# Github actions will release the new version
```

- https://packaging.python.org/en/latest/tutorials/packaging-projects/

### Examples

[Examples](./examples/README.md)
