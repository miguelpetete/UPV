# -*- coding: utf-8 -*-

from spellsuggest import SpellSuggester, TrieSpellSuggester
from trie import Trie
from time import process_time
import collections
import re

if __name__ == "__main__":
    vocab_file_path = "./corpora/quijote.txt"
    tokenizer = re.compile("\W+")
    with open(vocab_file_path, "r", encoding='utf-8') as fr:
        c = collections.Counter(tokenizer.split(fr.read().lower()))
        if '' in c:
            del c['']
        reversed_c = [(freq, word) for (word, freq) in c.items()]
        sorted_reversed = sorted(reversed_c, reverse=True)
        sorted_vocab = [word for (freq, word) in sorted_reversed]

    spellsuggester = TrieSpellSuggester("./corpora/quijote.txt")
    destiny =  f'experiment_TrieSuggester_quijote.txt'
    write = "TrieSpellSuggester\nAlgoritmo\t\tTalla\t\t Threshold\t\tTiempo"
    with open(destiny, "w", encoding='utf-8') as fw:
        for distance in ['levenshtein','restricted','intermediate']:
            for tamDic in range(10,51,10):
                time = 0
                for threshold in {0,3,6,9,15}:
                    for palabra in sorted_vocab[0:tamDic+1]:
                        aTime = process_time()
                        spellsuggester.suggest(palabra,distance=distance,threshold=threshold)
                        dTime = process_time()
                        time += (dTime-aTime)
                    write += "\n"+str(distance)+"\t\t\t"+str(tamDic)+"\t\t"+str(threshold)+"\t\t  "+str(time)
        fw.write(write)

    spellsuggester = SpellSuggester("./corpora/quijote.txt")
    destiny =  f'experiment_SpellSuggester_quijote.txt'
    write = "SpellSuggester\nAlgoritmo\t\tTalla\t\tThreshold\t\tTiempo"
    with open(destiny, "w", encoding='utf-8') as fw:
        for distance in ['levenshtein','restricted','intermediate']:
            for tamDic in range(10,51,10):
                time = 0
                for threshold in {0,3,6,9,15}:
                    for palabra in sorted_vocab[0:tamDic+1]:
                        aTime = process_time()
                        spellsuggester.suggest(palabra,distance=distance,threshold=threshold)
                        dTime = process_time()
                        time += (dTime-aTime)
                    write += "\n"+str(distance)+"\t\t\t"+str(tamDic)+"\t\t"+str(threshold)+"\t\t  "+str(time)
        fw.write(write)
