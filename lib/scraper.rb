require 'nokogiri'
require 'open-uri'
require 'pry'

def get_student_urls  
  html = open('http://ruby007.students.flatironschool.com/')  

  Nokogiri::HTML(html).css("div.big-comment h3 a").collect do |student_tag|
    "http://ruby007.students.flatironschool.com/" + student_tag['href']
  end
end

def get_student_pages
  get_student_urls.collect { |url| Nokogiri::HTML(open(url)) }
end

def get_student_names
  get_student_pages.collect { |page| page.css("h4.ib_main_header").text }
end

def get_student_bios
  get_student_pages.collect { |page| page.css("div.services p").first.text.strip }
end

def get_student_education
  get_student_pages.collect { |page| page.css("div.services ul").first.text.strip }
end

def get_student_work
  get_student_pages.collect { |page| page.css("div.services p")[1].text.strip }
end

def get_student_cred
  get_student_pages.collect do |page| 
    page.css("div#ok-text-column-2 div p a").collect do |line_of_code|
      line_of_code["href"]
    end[0..3].compact 
  end
end 

def create_student_hash
  index = 0
  student_names = get_student_names
  student_bios = get_student_bios
  student_educations = get_student_education
  student_works = get_student_work
  student_creds = get_student_cred
  people = []

  get_student_pages.size.times do
    student_hash = {}
    student_hash[:name] = student_names[index]
    student_hash[:bio] = student_bios[index]
    student_hash[:education] = student_educations[index]
    student_hash[:work] = student_works[index]
    student_hash[:coder_cred] = student_creds[index]
    index += 1
    people << student_hash
  end
  people
end