using WidenableArrays: WidenableArrays
using Documenter: Documenter, DocMeta, deploydocs, makedocs

DocMeta.setdocmeta!(
  WidenableArrays, :DocTestSetup, :(using WidenableArrays); recursive=true
)

include("make_index.jl")

makedocs(;
  modules=[WidenableArrays],
  authors="ITensor developers <support@itensor.org> and contributors",
  sitename="WidenableArrays.jl",
  format=Documenter.HTML(;
    canonical="https://ITensor.github.io/WidenableArrays.jl",
    edit_link="main",
    assets=String[],
  ),
  pages=["Home" => "index.md"],
)

deploydocs(;
  repo="github.com/ITensor/WidenableArrays.jl", devbranch="main", push_preview=true
)
