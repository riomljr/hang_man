
word = File.readlines("dictionary.txt").select { |w| w.length[5..12]}.sample
size = word.length