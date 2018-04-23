f = open("q1.txt", 'r')
f2 = open("q2.txt", 'w')
line = f.readlines()
for l in line:
    l = l.strip()
    l1 = l.split(":")
    nums = l1[1][2:-2].split(", ")
    for num in nums:
        a = ', '.join([x for x in nums if x != num])
        f2.write(l1[0] + ("& bridge1 = %s : {%s};\n") % (num, a))
