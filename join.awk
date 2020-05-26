#!/bin/awk
function joinlower(array, start, end, sep,    result, i)
{
    if (sep == "")
       sep = " "
    else if (sep == SUBSEP) # magic value
       sep = ""
    result = tolower(array[start])
    for (i = start + 1; i <= end; i++)
        result = result sep tolower(array[i])
    return result
}