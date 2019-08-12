#-------------------------------------------------------------------------------
function primesUpTo(limit::Integer)
    if limit < 2    return []  end
    primes = Int64[2]
    πLim = convert( Int64, floor( limit / log(limit) ) )
    sizehint!(primes, πLim)
    oddsElim = falses(limit-1 ÷ 2) # odds except 1
    i_max = (convert(Int64, floor(√limit))-1) ÷ 2

    for i = 1 : i_max
        if !oddsElim[i]
            n = 2i + 1
            for ĩ = i + n : n : length(oddsElim)
                oddsElim[ĩ] = true
            end
        end
    end

    for i = 1 : length(oddsElim)
        if !oddsElim[i]    push!(primes, 2i + 1)  end
    end

    primes
end
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
function num_in_sorted(n, a)
# array must be sorted low-to-high
    low = 1
    hgh = length(a)

    fnd = false # number found in array

    while low ≤ hgh  &&   !fnd
        mid = low + (hgh - low) ÷ 2

        if     (a[mid] == n)  fnd = true
        elseif (a[mid] <  n)  low = mid + 1
        else                  hgh = mid - 1
        end
    end

    fnd
end
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
function Goldbachiness(n, primes)
# Returns the number of ways a number is the sum of two primes

    if last(primes) < n
        primesNew = primesUpTo(2n)
        i_min = length(primes) + 1
        for i = i_min : length(primesNew)
            push!(primes, primesNew[i])
        end
    end

    halfNum = n ÷ 2
    ways = 0
    i = 1
    while primes[i] ≤ halfNum
        diff = n - primes[i]
        if num_in_sorted(diff, primes)    ways += 1    end
        i += 1
    end

    ways
end
#-------------------------------------------------------------------------------



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function main()
# Find "Golbachy" numbers i.e. numbers that can be the sum of two primes more
# ways than any smaller number.

    primes = primesUpTo(9)

    println(typeof(primes))
    nums = [4]::Array{Int64,1}
    ways = [1]::Array{Int64,1}

    for candidate = 6 : 2 : 9_998
        Gness = Goldbachiness(candidate, primes)

        if  Gness > last(ways)
            push!(nums, candidate)
            push!(ways, Gness)
        end
    end

    digits_nums = convert(Int64, floor(log10(last(nums)))) + 1
    digits_ways = convert(Int64, floor(log10(last(ways)))) + 1

    for i = 1 : length(nums)
        println(lpad(nums[i], digits_nums), " sums ",
                lpad(ways[i], digits_ways), " ways.")
    end
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main()
