## init

```bash
julia --project=. -e 'import Pkg; Pkg.instantiate(); Pkg.status()'
```


## test


```bash
julia --project=. -e 'import Pkg; Pkg.test()'
```

bound:
```bash
julia --project=. --check-bounds=yes -e 'import Pkg; Pkg.test()'
```

## docs

```bash
rm -f docs/Manifest.toml

julia --project=docs -e 'import Pkg; Pkg.develop(Pkg.PackageSpec(path=pwd())); Pkg.instantiate()'

julia --project=docs docs/make.jl

cd docs/build
python -m http.server --bind localhost 8000
```

Then open ``http://localhost:8000``