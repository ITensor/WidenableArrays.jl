module MaybeMutating

# Heavily inspired by https://github.com/juliafolds/bangbang.jl.

include("NonMutating.jl")
using .NonMutating: NonMutating

function tryconvert(type::Type, x)
  return try
    convert(type, x)
  catch
    nothing
  end
end

function maybemutate(f!, args...)
  args′ = tryconvertargs(f!, args...)
  if isnothing(args′)
    return nonmutating(f!)(args...)
  end
  return f!(args′...)
end

implements(f!, x) = implements(f!, typeof(x))
implements(f!, ::Type) = false

function setindex!! end
setindex!!(a::AbstractArray, value, I...) = maybemutate(setindex!, a, value, I...)
implements(::typeof(setindex!), ::Type{<:AbstractArray}) = true
nonmutating(::typeof(setindex!)) = NonMutating.setindex
maybemutating(::typeof(setindex!)) = setindex!!
function tryconvertargs(f::typeof(setindex!), a::AbstractArray, value, I...)
  !implements(f, a) && return nothing
  value′ = tryconvert(eltype(a), value)
  if isnothing(value′)
    return nothing
  end
  return (a, value′, I...)
end

function copyto!! end
copyto!!(dest::AbstractArray, src) = maybemutate(copyto!, dest, src)
implements(::typeof(copyto!), ::Type{<:AbstractArray}) = true
nonmutating(::typeof(copyto!)) = NonMutating.copyto
maybemutating(::typeof(copyto!)) = copyto!!
function tryconvertargs(f::typeof(copyto!), dest::AbstractArray, src)
  !implements(f, dest) && return nothing
  if !(promote_type(eltype(dest), eltype(src)) <: eltype(dest))
    return nothing
  end
  return (dest, src)
end

end
