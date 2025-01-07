module NonMutating

# Heavily inspired by https://github.com/juliafolds/bangbang.jl.

function setindex(a::AbstractArray, value, I::Int...)
  a′ = similar(a, promote_type(eltype(a), typeof(value)))
  a′ .= a
  a′[I...] = value
  return a′
end

function setindex(a::AbstractArray, value, I...)
  a′ = similar(a, promote_type(eltype(a), eltype(value)))
  a′ .= a
  a′[I...] = value
  return a′
end

generic_eltype(a::AbstractArray) = eltype(a)

using Base.Broadcast: Broadcasted, combine_eltypes
# `Base.eltype(a::Broadcasted)` returns `Any`.
generic_eltype(bc::Broadcasted) = combine_eltypes(bc.f, bc.args)

function copyto(dest::AbstractArray, src)
  dest′ = similar(dest, promote_type(eltype(dest), generic_eltype(src)))
  copyto!(dest′, src)
  return dest′
end

end
