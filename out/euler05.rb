require "scanf.rb"
def mod(x, y)
  return x - y * (x.to_f / y).to_i
end

def primesfactors( n )
    tab = [];
    for i in (0 ..  n + 1 - 1) do
      tab[i] = 0;
    end
    d = 2
    while n != 1 && d * d <= n do
      if (mod(n, d)) == 0 then
        tab[d] = tab[d] + 1;
        n = (n.to_f / d).to_i
      else
        d += 1
      end
    end
    tab[n] = tab[n] + 1;
    return (tab);
end

lim = 20
o = [];
for m in (0 ..  lim + 1 - 1) do
  o[m] = 0;
end
for i in (1 ..  lim) do
  t = primesfactors(i)
  for j in (1 ..  i) do
    o[j] = [o[j], t[j]].max;
  end
end
product = 1
for k in (1 ..  lim) do
  for l in (1 ..  o[k]) do
    product *= k
  end
end
printf "%d\n", product

