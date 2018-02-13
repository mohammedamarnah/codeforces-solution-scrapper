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
