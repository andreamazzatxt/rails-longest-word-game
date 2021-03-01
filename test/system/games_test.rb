require "application_system_test_case"
require 'open-uri'
require 'json'

class GamesTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit games_url
  #
  #   assert_selector "h1", text: "Game"
  # end
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector ".letter", count: 8
  end

  test 'Submit a word not in the grid' do
    visit new_url
    assert test: "Check wrong word"
    page.fill_in('word', with: 'ciaociaociao')
    click_button('Score')
    sleep(3)
    page.has_content?("The word [ciaociaociao] doesn't match with the given letters [N-M-Z-U-P-E-C-R]")
  end

  test 'Submit a word with one letter' do
    visit new_url
    assert test: "Check single letter word"
    letter = page.all('.letter').sample.text
    page.fill_in('word', with: letter)
    click_button('Score')
    page.has_content?("The word doesn't exist!")
  end

  test 'Submit a correct word and get a Congrats' do
    visit new_url
    assert test: "Check correct word"
    letters = ''
    page.all('.letter').each do |l|
      letters += l.text
    end
    resp = open("http://www.anagramica.com/best/#{letters}").read
    resp = JSON.parse(resp)
    p resp
    page.fill_in('word', with: resp['best'][0])
    click_button('Score')
    page.has_content?('Correct!')
  end
end
