def importance_index(words)
  if words.length < 50
    (words.length / 20)
  elsif words.length < 250
    (words.length / 40)
  elsif words.length < 500
    (words.length / 60)
  end
end

def summarize(input)
  all_words = input.split(' ')
  threshold = importance_index(all_words)
  keywords = all_words.select { |e| all_words.count(e) > threshold && e.length > 3 }.uniq!
  if keywords == nil
    keywords = all_words.select { |e| all_words.count(e) > 2 && e.length > 3 }.uniq!
  end
  keywords.delete_if { |w| /(have|this|with|just|your|when|from|that|were|much|here|there|their|they)/i.match(w) }

  scores = {}
  paragraphs = input.split("\n")
  sentence_count = 0

  paragraphs.each do |paragraph|
    sentences = paragraph.split(". ")
    sentences.each do |sentence|
      if sentence == sentences[0]
        sentence_score = 1
      else
        sentence_score = 0
      end
      keywords.each do |word|
        if sentence =~ /#{word}/i
          sentence_score += 1
        end
      end
      scores[sentence] = sentence_score
    end
    sentence_count += 1
  end

  max_score = scores.max_by { |k,v| v }[1]
  scores.delete_if {|k,v| v <= (max_score / 2)}
  scores.keys.flatten.join(" ")
end

isis = File.read("articles/isis.txt")
gop = File.read("articles/candidates.txt")
football = File.read("articles/football.txt")

File.write('article_outputs/isis_result.txt', summarize(isis))
File.write('article_outputs/gop_result.txt', summarize(gop))
File.write('article_outputs/football_result.txt', summarize(football))
