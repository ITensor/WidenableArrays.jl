using PromotableStorageArrays: PromotableStorageArrays
using Documenter: Documenter, DocMeta, deploydocs, makedocs

DocMeta.setdocmeta!(
  PromotableStorageArrays, :DocTestSetup, :(using PromotableStorageArrays); recursive=true
)

include("make_index.jl")

makedocs(;
  modules=[PromotableStorageArrays],
  authors="ITensor developers <support@itensor.org> and contributors",
  sitename="PromotableStorageArrays.jl",
  format=Documenter.HTML(;
    canonical="https://ITensor.github.io/PromotableStorageArrays.jl",
    edit_link="main",
    assets=String[],
  ),
  pages=["Home" => "index.md"],
)

deploydocs(;
  repo="github.com/ITensor/PromotableStorageArrays.jl", devbranch="main", push_preview=true
)
