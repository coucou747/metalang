require "scanf.rb"

def mktoto( v1 )
    d = {"foo" => v1,
         "bar" => 0,
         "blah" => 0};
    t = d
    return (t);
end

def result( t, len )
    out_ = 0
    for j in (0 ..  len - 1) do
      t[j]["blah"] = t[j]["blah"] + 1;
      out_ = out_ + t[j]["foo"] + t[j]["blah"] * t[j]["bar"] + t[j]["bar"] * t[j]["foo"];
    end
    return (out_);
end

a = 4
t = [];
for i in (0 ..  a - 1) do
  t[i] = mktoto(i);
end
t[0]["bar"]=scanf("%d")[0];
scanf("%*\n");
t[1]["blah"]=scanf("%d")[0];
b = result(t, 4)
printf "%d", b
c = t[2]["blah"]
printf "%d", c

