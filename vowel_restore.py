from sets import Set
import string
f = open('common.csv','r')
vocab = {}
ranks = {}
words = []
syms = Set()
k = 10
for line in f:
    rank,word,score = line.replace(',',' ').rstrip().split(' ',3)
    vocab[word.lower()] = float(score)
    ranks[word.lower()] = int(rank)
    words.append(word.lower())
f.close() 
f = open('./Txt/A1.txt','w')   
init_state = 0
current_state = 0
last_state = 0
for word in words[0:min(k,len(words))]:
    last_state += len(word) + 1
last_state += 1

for word in words[0:min(k,len(words))]:    
    current_state += 1
    f.write( '%d %d %s %f\n' % (init_state, current_state, '<epsilon>', 0.0))
    for i in range(0,len(word)):
        syms.add(word[i])
        if i==0:
            f.write( '%d %d %s %f\n' % (current_state, current_state+1, word[i], vocab[word]))
            current_state += 1
        else:
            f.write( '%d %d %s %f\n' % (current_state, current_state+1, word[i], 0.0))
            current_state += 1
    f.write( '%d %d %s %f\n' % (current_state, last_state, '<epsilon>', 0.0))
f.write( '%d %f\n' % (last_state,0.0))
f.close()
f = open('./Syms/A1.syms','w')
idx = 0
f.write('%s %d\n' % ('<epsilon>',idx))
idx += 1
for sym in string.lowercase[:]:
    f.write('%s %d\n' % (sym,idx))
    idx += 1
f.write('%s %d\n' % ('<space>',idx))
idx += 1
f.write('%s %d' % ('<newline>',idx))    
f.close()
f = open('./Txt/T1.txt','w');
init_state = 0
last_state = 0
for sym in syms:
     f.write( '%d %d %s %s\n' % (init_state, last_state, sym, sym))
vowels = ['a','e','i','o','u']
for v in vowels:
    f.write( '%d %d %s %s\n' % (init_state, last_state, '<epsilon>', v))
f.write( '%d %d %s %s\n' % (init_state, last_state, '<space>', '<space>'))
f.write( '%d %d %s %s\n' % (init_state, last_state, '<newline>', '<newline>'))
f.write( '%d' % (last_state))    
f.close() 