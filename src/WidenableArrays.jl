module WidenableArrays

using Derive: Derive, @derive, @interface, AbstractArrayInterface

include("MaybeMutating.jl")
using .MaybeMutating: copyto!!, setindex!!

abstract type AbstractWidenableArrayInterface <: AbstractArrayInterface end

struct WidenableArrayInterface <: AbstractWidenableArrayInterface end

# Minimal interface.
widenable(x) = x
widenable!(y, x) = y
unwidenable(x) = x

@interface ::AbstractWidenableArrayInterface function Base.eltype(a::AbstractArray)
  return eltype(unwidenable(a))
end
@interface ::AbstractWidenableArrayInterface function Base.size(a::AbstractArray)
  return size(unwidenable(a))
end
@interface ::AbstractWidenableArrayInterface function Base.axes(a::AbstractArray)
  return axes(unwidenable(a))
end
# Required since Base uses the compile time element type.
@interface ::AbstractWidenableArrayInterface function Base.similar(a::AbstractArray)
  return similar(a, eltype(a))
end
# Required since Base uses the compile time element type.
@interface ::AbstractWidenableArrayInterface function Base.similar(
  a::AbstractArray, ax::Tuple
)
  return similar(a, eltype(a), ax)
end
function similar_widenable(a::AbstractArray, elt::Type, ax)
  return widenable(similar(unwidenable(a), elt, ax))
end
@interface ::AbstractWidenableArrayInterface function Base.similar(
  a::AbstractArray, elt::Type, ax
)
  return similar_widenable(a, elt, ax)
end
# Fixes ambiguity error.
@interface ::AbstractWidenableArrayInterface function Base.similar(
  a::AbstractArray, elt::Type, ax::Tuple{Vararg{Int}}
)
  return similar_widenable(a, elt, ax)
end
# Fixes ambiguity error.
@interface ::AbstractWidenableArrayInterface function Base.similar(
  a::AbstractArray, elt::Type, ax::Tuple{Base.OneTo,Vararg{Base.OneTo}}
)
  return similar_widenable(a, elt, ax)
end
@interface ::AbstractWidenableArrayInterface function Base.getindex(
  a::AbstractArray, I::Int...
)
  return getindex(unwidenable(a), I...)
end
@interface ::AbstractWidenableArrayInterface function Base.setindex!(
  a::AbstractArray, value, I::Int...
)
  widenable!(a, setindex!!(unwidenable(a), value, I...))
  return a
end

using Base.Broadcast: AbstractArrayStyle, Broadcasted, DefaultArrayStyle, broadcasted

abstract type AbstractWidenableArrayStyle{N} <: AbstractArrayStyle{N} end

struct WidenableArrayStyle{N} <: AbstractWidenableArrayStyle{N} end
WidenableArrayStyle(::Val{N}) where {N} = WidenableArrayStyle{N}()
WidenableArrayStyle{M}(::Val{N}) where {M,N} = WidenableArrayStyle{N}()

@interface ::AbstractWidenableArrayInterface function Base.BroadcastStyle(
  arraytype::Type{<:AbstractArray}
)
  return WidenableArrayStyle{ndims(arraytype)}()
end

function Base.copyto!(dest::AbstractArray, bc::Broadcasted{<:AbstractWidenableArrayStyle})
  copyto!(dest, unwidenable(bc))
  return dest
end
function copyto!_widenable(dest::AbstractArray, src)
  widenable!(dest, copyto!!(unwidenable(dest), unwidenable(src)))
  return dest
end
@interface ::AbstractWidenableArrayInterface function Base.copyto!(
  dest::AbstractArray, src::AbstractArray
)
  return copyto!_widenable(dest, src)
end
@interface ::AbstractWidenableArrayInterface function Base.copyto!(
  dest::AbstractArray, src::Broadcasted
)
  return copyto!_widenable(dest, src)
end
# Fix ambiguity error with Derive.jl.
@interface ::AbstractWidenableArrayInterface function Base.copyto!(
  dest::AbstractArray, src::Broadcasted{DefaultArrayStyle{0}}
)
  return copyto!_widenable(dest, src)
end

function unwidenable(bc::Broadcasted)
  return broadcasted(bc.f, unwidenable.(bc.args)...)
end

function Base.similar(bc::Broadcasted{<:AbstractWidenableArrayStyle}, elt::Type, ax)
  return widenable(similar(unwidenable(bc), elt, ax))
end

abstract type AbstractWidenableArray{T,N} <: AbstractArray{T,N} end

const AbstractWidenableVector{T} = AbstractWidenableArray{T,1}

Derive.interface(::Type{<:AbstractWidenableArray}) = WidenableArrayInterface()

function widenable(a::AbstractArray)
  return WidenableArray(a)
end

using ArrayLayouts: ApplyBroadcastStyle, LayoutArray
using BlockArrays: AbstractBlockStyle

@derive (T=AbstractWidenableArray,) begin
  Base.eltype(::T)
  Base.size(::T)
  Base.axes(::T)
  Base.similar(::T)
  Base.similar(::T, ::Tuple)
  Base.similar(::T, ::Type, ::Any)
  Base.similar(::T, ::Type, ::Tuple{Int,Vararg{Int}})
  Base.similar(
    ::T, ::Type, ::Tuple{Union{Integer,Base.OneTo},Vararg{Union{Integer,Base.OneTo}}}
  )
  Base.setindex!(::T, ::Any, ::Int...)
  Base.getindex(::T, ::Int...)
  Base.copyto!(::T, ::AbstractArray)
  Base.copyto!(::T, ::Broadcasted)
  Base.copyto!(::T, ::Broadcasted{Nothing})
  Base.copyto!(::T, ::Broadcasted{<:AbstractWidenableArrayStyle})
  Base.copyto!(::T, ::Broadcasted{ApplyBroadcastStyle})
  Base.copyto!(::T, ::LayoutArray)
  Base.copyto!(::T, ::SubArray{<:Any,<:Any,<:LayoutArray})
  Base.copyto!(::T, ::Broadcasted{<:AbstractBlockStyle,<:Any,<:Any,<:Tuple})
  Base.copyto!(::T, ::Broadcasted{<:AbstractArrayStyle{0},<:Any,<:Any,<:Tuple})
  Base.BroadcastStyle(::Type{<:T})
end
@derive (T=AbstractWidenableVector,) begin
  Base.copyto!(::T, ::Broadcasted{<:AbstractBlockStyle{1}})
end

mutable struct WidenableArray{N} <: AbstractWidenableArray{Any,N}
  parent::AbstractArray{<:Any,N}
end
Base.parent(a::WidenableArray) = a.parent
unwidenable(a::WidenableArray) = parent(a)
widenable!(a::WidenableArray, unwidenable) = (a.parent = unwidenable)

end
