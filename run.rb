require 'nokogiri'
require 'mechanize'
require 'set'

def fix_s(temp)
  s = ""
  i = 0
  f = 0
  while i < temp.length
    if temp[i] == ' ' && f
      s += temp[i]
      f = 0
    end
    if (temp[i] >= 'a' && temp[i] <= 'z') || (temp[i] >= 'A' && temp[i] <= 'Z') || (temp[i] >= '0' && temp[i] <= '9') || temp[i] == '-' || temp[i] == '.' || temp[i] == ':' || temp[i] == '#'
      s += temp[i]
      f = 1
    end
    i += 1
  end
  return s.strip
end

def make_array(s)
  temp = ""
  i = 0
  ret = Array.new
  while i < s.length
    if s[i] == ' ' && s[i+1] == ' '
      ret.push(temp)
      temp = ""
      while s[i] == ' '
        i += 1
      end
    end
    temp += s[i]
    i += 1
  end
  return ret
end

agent = Mechanize.new

login = agent.get('http://codeforces.com/enter?back=%2F')
login_form = login.forms[1]

username_field = login_form.field_with(:name=>"handle").value = "supernova."
password_field = login_form.field_with(:name=>"password").value = "qazp;/wsxol."

page = agent.submit login_form
sub_page = page.link_with(:text => "Submissions").click()

sub_html = Nokogiri::HTML(sub_page.body)

submissions = Set.new
name_freq = Hash.new(0)

sub_html.css('table.status-frame-datatable tr').each { |a|
  arr = make_array(fix_s(a.text.to_s))
  if arr[arr.length-2] == 'Accepted'
    name_freq[arr[3]] += 1
    submissions.add(arr)
  end
}

###################################
#     sub_id            [0]       #
#     time              [1]       #
#     username          [2]       #
#     problem           [3]       #
#     lang              [4]       #
#     status            [5]       #
#     time_consumed     [6]       #
#     memory_consumed   [7]       #
###################################

temp = sub_page
code = sub_page.link_with(:text => "34169738").click()
codehtml = Nokogiri::HTML(code.body)
x = codehtml.css('pre.source, pre.prettyprint').each { |temp| puts temp.text }
sub_page = temp

temp = sub_page
code2 = sub_page.link_with(:text => "34169738").click()
codehtml2 = Nokogiri::HTML(code2.body)
x = codehtml2.css('pre.source, pre.prettyprint').each { |temp| puts temp.text }
sub_page = temp


# lang = ".cpp"
# submissions.each { |e|
#   puts "Downloading #{e[0]} #{e[3]} ..."
#   code = sub_page.link_with(:text => e[0]).click()
#   codehtml = Nokogiri::HTML(code.body)
#   x = codehtml.css('pre.source span, pre.prettyprint span').each { |temp| print temp.text }
#   puts ""
# }
