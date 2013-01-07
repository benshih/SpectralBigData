function [ first, last ] = findRange( value, array )
% int value, int[] array, int start, int end
% Finds the first and last occurrence of a value and returns the indices.
% Assumes that each occurrence only has one block of values (a single
% clump). 

    for i = 1:length(array)
        if(array(i) == value)
            first = i;
            break;
        end
    end

    for i = length(array):-1:1
        if(array(i) == value)
            last = i;
            break;
        end
    end


end