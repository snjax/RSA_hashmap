using Primes;
using DelimitedFiles;
using SHA;

function primeHash(value::BigInt)
  _value = unsafe_wrap(Vector{UInt8}, Ptr{UInt8}(value.d), (value.size*8,)) 
  res = sha256(_value)
  bn = BigInt(0)
  ccall((:__gmpz_import, :libgmp), Cvoid, (Ref{BigInt}, Csize_t, Cint, Csize_t, Cint, Csize_t, Ptr{Cvoid}), bn, 4, 1, 8, 0, 0, res)
  while !isprime(bn)
    bn-=1
  end
  return bn
end

function primeN(bn::BigInt)
  while !isprime(bn)
    bn-=1
  end
  return bn
end


let 
  randstate = zeros(UInt8,32)
  global bigrand
  ccall((:__gmp_randinit_default,:libgmp),Cvoid,(Ptr{Cvoid},),randstate)
  function rand(min::BigInt, max::BigInt)
    delta = max - min
    x = BigInt()
    ccall((:__gmpz_urandomm,:libgmp),Cvoid,(Ref{BigInt},Ptr{Cvoid},Ref{BigInt}),x,randstate,delta)
    return x+min
  end

  bigrand(max::BigInt) = bigrand(BigInt(0), max)
end


function normalize(rem::BigInt, divisor::BigInt)
  return powermod(rem, -1, divisor)
end




function test()
  mantice = rand(UInt8, 2^20) .% 2
  primes = map(x -> primeN(x<<10), BigInt(1):BigInt(2^20))
  println(length(unique(primes))-2^20)
end

test()



