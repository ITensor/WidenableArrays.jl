using Literate: Literate
using PromotableStorageArrays: PromotableStorageArrays

Literate.markdown(
  joinpath(pkgdir(PromotableStorageArrays), "examples", "README.jl"),
  joinpath(pkgdir(PromotableStorageArrays), "docs", "src");
  flavor=Literate.DocumenterFlavor(),
  name="index",
)
