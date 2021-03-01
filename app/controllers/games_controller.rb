require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def home
  end

  def new
    @letters = []
    8.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    word = params[:word]
    letters = params[:letter].split('')
    check_letters = true
    letters_copy = params[:letter].split('')
    word.split('').each do |l|
      check_letters = letters_copy.delete(l.upcase).nil? ? false : true
    end
    response = open("https://wagon-dictionary.herokuapp.com/#{word.downcase}").read
    response = JSON.parse(response)
    check_exist = response['found']
    @message = ''
    if !check_letters
      @message = "The word [#{word.upcase}] doesn't match with the given letters [#{letters.join('-')}]"
    elsif !check_exist || word.size == 1
      @message = "The word doesn't exist!"
    else
      points = response['length'] - (Time.now.to_i - params[:time].to_i) / 5
      points = points.negative? ? 0 : points
      session['points'] += points unless session['points'].nil?
      @message = "Correct! You scored : #{points} !"
    end
  end
end
