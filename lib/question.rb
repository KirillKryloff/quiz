require 'rexml/document'
require 'date'

class Question
  attr_reader :questions_number, :text, :time, :answers, :true_answer

  def initialize(questions_number, text, time, answers, true_answer)
    @questions_number = questions_number
    @text = text
    @time = time
    @answers = answers
    @true_answer = true_answer
  end

  def self.read_from_xml(file_path)
    questions = []
    question_number = 1

    file = File.new(file_path, 'r:UTF-8')
    doc = REXML::Document.new(file)
    file.close

    doc.root.each_element do |question|
      text = question.elements['text'].text
      time = question.attributes['seconds']

      answers = []
      true_answer = nil

      question.elements.each('variants/variant') do |variant|
        answers << variant.text
        true_answer = variant.text if variant.attributes['right']
      end

      questions << Question.new(question_number, text, time, answers, true_answer)
      question_number += 1
    end
    return questions
  end

  def get_user_answer
    user_answer = -1

    until (1..4).include?(user_answer) do
      user_answer = STDIN.gets.to_i
    end
    @user_answer = @answers[user_answer - 1]
  end

  def correct_answers?
    @user_answer == @true_answer
  end
end
