using Literate: Literate
using WidenableArrays: WidenableArrays

Literate.markdown(
  joinpath(pkgdir(WidenableArrays), "examples", "README.jl"),
  joinpath(pkgdir(WidenableArrays), "docs", "src");
  flavor=Literate.DocumenterFlavor(),
  name="index",
)
