
def near_even_divide(dividend, divisor):
    residual= dividend
    floor_quotient = dividend//divisor
    result = []
    for i in range(divisor):
        if floor_quotient*(divisor-i) == residual:
            result.append(floor_quotient)
            residual -= floor_quotient
        else:
            result.append(floor_quotient+1)
            residual -= floor_quotient+1
    return result


a = [1, 2, 3, 4]
del a[2:]
print(a)