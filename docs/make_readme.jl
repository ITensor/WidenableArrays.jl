using Literate: Literate
using PromotableStorageArrays: PromotableStorageArrays

Literate.markdown(
  joinpath(pkgdir(PromotableStorageArrays), "examples", "README.jl"),
  joinpath(pkgdir(PromotableStorageArrays));
  flavor=Literate.CommonMarkFlavor(),
  name="README",
)
