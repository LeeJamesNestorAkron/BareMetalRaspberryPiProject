.globl memzero
memzero:
    str xzr, [x0], #8
    subs x1, x1, #8
    b.gt memzero
    ret

#xzr is is a zero valued operande without having to load and occupy a real register