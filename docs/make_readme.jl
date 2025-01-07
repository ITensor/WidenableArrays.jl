using Literate: Literate
using WidenableArrays: WidenableArrays

Literate.markdown(
  joinpath(pkgdir(WidenableArrays), "examples", "README.jl"),
  joinpath(pkgdir(WidenableArrays));
  flavor=Literate.CommonMarkFlavor(),
  name="README",
)
