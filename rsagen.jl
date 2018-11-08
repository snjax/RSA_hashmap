using Primes;
using DelimitedFiles;



function rand1024()
  x::BigInt=BigInt(1)
  for i=1:16
    x=x<<64+rand(UInt64)
  end
  return x
end


function randRSAPrime()
  x::BigInt=0
  while true
    x = rand1024()
    if !isprime(x) 
      continue
    end
    if isprime(div(x,2))
      break
    end
  end
  return x
end

writedlm("divisor.txt", [randRSAPrime()*randRSAPrime()])
