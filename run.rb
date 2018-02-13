langs = {"GNU C" => ".c", "Clang++17" => ".cpp", "GNU G++" => ".cpp", "GNU G++11" => ".cpp", "GNU G++14" => ".cpp", "GNU G++17" => ".cpp", "GNU C++17" => ".cpp", "MS C++" => ".cpp", "Mono C#" => ".cs", "MS C#" => ".cs", "D" => ".d", "Go" => ".go", "Haskell" => ".hs", "Java" => ".java", "Kotlin" => ".kt", "OCaml" => ".ml", "Delphi" => ".dpr", "Python" => ".py", "PyPy" => ".pypy", "Ruby" => ".rb", "Javascript" => ".js", "TCL" => ".tcl", "Free Pascal 3" => ".lpr"}

require 'nokogiri'
require 'mechanize'
require 'set'
require 'progress_bar'
require './utils.rb'

if !File.exists? 'codeforces-solutions'
  Dir.mkdir 'codeforces-solutions'
end


agent = Mechanize.new
login = agent.get('http://codeforces.com/enter?back=%2F')
login_form = login.forms[1]

username_field = login_form.field_with(:name=>"handle").value = ARGV[0]
password_field = login_form.field_with(:name=>"password").value = ARGV[1]

page = agent.submit login_form

if page.link_with(:text => "Submissions") == nil
  puts "Invalid username / password"
  exit
end

sub_page = page.link_with(:text => "Submissions").click()

####### Row Elements Indices ######
###################################
#     sub_id            e[0]      #
#     time              e[1]      #
#     username          e[2]      #
#     problem           e[3]      #
#     lang              e[4]      #
#     status            e[5]      #
#     time_consumed     e[6]      #
#     memory_consumed   e[7]      #
###################################

# Getting the number of submission pages
sub_page_html = Nokogiri::HTML(sub_page.body)
lastpage = 0
sub_page_html.css('div.pagination ul li span a').each {|a| lastpage = a.text.to_i}

name_freq = Hash.new(0)
cnt = 1
len = 0
failed = 0
(1...lastpage).to_a.select { |i|
  submissions = Set.new
  sub_html = Nokogiri::HTML(sub_page.body)
  sub_html.css('table.status-frame-datatable tr').each { |a|
    arr = make_array(fix_s(a.text.to_s))
    if arr[arr.length-2] == 'Accepted'
      submissions.add(arr)
    end
  }
  submissions.each { |e|
    #puts "Downloading #{e[0]} #{e[3]} ..."
    if sub_page.link_with(:text => e[0]) != nil
      code = sub_page.link_with(:text => e[0]).click()
      codehtml = Nokogiri::HTML(code.body)
      codehtml.css('pre.source, pre.prettyprint').each { |el|
        lang = langs[e[4]]
        if lang == nil
          if (e[4].include? "GNU") || (e[4].include? "Clang") || (e[4].include? "C++")
            lang = ".cpp"
          elsif (e[4].include? "Python")
            lang = ".py"
          elsif (e[4].include? "Java")
            lang = ".java"
          elsif e[4].include? "C#"
            lang = ".cs"
          else
            lang = ".txt"
          end
        end
        path = './codeforces-solutions/'+e[3]+lang
        if File.exists? path
          name_freq[e[3]] += 1
          path = './codeforces-solutions/'+e[3]+name_freq[e[3]].to_s+lang
        end
        File.open(path, 'a') { |f| f.write(el.text) }
        printf("\rFetching from page ...... [%d] --- Number of Files ...... [%d]", i, cnt)
        cnt += 1
      }
      sleep 2
    else
      failed += 1
    end
  }
  sub_page = sub_page.link_with(:text => (i+1).to_s).click()
}

puts failed
