text_file = open('trace', 'r')
text = text_file.read()

liness = text.splitlines()

lines = []
for linee in liness:
    if linee[:1].isalpha():
        lines.append(linee)

#cleaning
#words = lines.split()
#words = [word.strip('.,!;()[]') for word in words]
#words = [word.replace("'s", '') for word in words]

#finding unique
unique = []
for line in lines:
    if line not in unique:
        unique.append(line)

#print
for i in range(0, unique.__len__()):
    print(f"{i}. {unique[i]}")
