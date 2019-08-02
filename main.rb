require_relative 'lib/question'
correct_answers = 0

puts "Мини викторина! Вам необходимо ответить на вопросы, время на ответ ограничено - 30 сек."
questions = Question.read_from_xml('data/questions.xml')

questions.each do |question|
  puts "Вопрос #{question.questions_number}"
  puts question.text
  question.answers.each_with_index do |answer, index|
    puts "#{index + 1}. #{answer}"
  end
  puts "Выберите один из предложенных вариантов, нажмите 1, 2, 3 или 4"
  time = Time.now
  question.get_user_answer
  if Time.now >= (time + question.time.to_i)
    puts "Время на ответ истекло"
    exit
  elsif question.correct_answers?
    puts "Верный ответ"
    puts
    correct_answers += 1
  else 
    puts "Неправильно, правильный ответ #{question.true_answer}"
    puts
  end
end
puts "Правильных ответов #{correct_answers} из #{questions.size}"
