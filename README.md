# WidenableArrays.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ITensor.github.io/WidenableArrays.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ITensor.github.io/WidenableArrays.jl/dev/)
[![Build Status](https://github.com/ITensor/WidenableArrays.jl/actions/workflows/Tests.yml/badge.svg?branch=main)](https://github.com/ITensor/WidenableArrays.jl/actions/workflows/Tests.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/ITensor/WidenableArrays.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/ITensor/WidenableArrays.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

## Installation instructions

This package resides in the `ITensor/ITensorRegistry` local registry.
In order to install, simply add that registry through your package manager.
This step is only required once.
```julia
julia> using Pkg: Pkg

julia> Pkg.Registry.add(url="https://github.com/ITensor/ITensorRegistry")
```
or:
```julia
julia> Pkg.Registry.add(url="git@github.com:ITensor/ITensorRegistry.git")
```
if you want to use SSH credentials, which can make it so you don't have to enter your Github ursername and password when registering packages.

Then, the package can be added as usual through the package manager:

```julia
julia> Pkg.add("WidenableArrays")
```

## Examples

````julia
using WidenableArrays: widenable, unwidenable
using Test: @test
a = widenable(zeros(2, 2))
@test eltype(a) === Float64
a[1, 1] = 1 + 2im
@test a[1, 1] == 1 + 2im
@test eltype(a) === Complex{Float64}

x = randn(2, 2)
a = widenable(copy(x))
a .= a .+ (1 + 2im) .* a
@test eltype(a) === Complex{Float64}
@test a == x .+ (1 + 2im) .* x
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

