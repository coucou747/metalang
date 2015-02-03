Imports System

Module euler05

  Function max2_(ByVal a as Integer, ByVal b as Integer) As Integer
    If a > b Then
      Return a
    Else
      Return b
    End If
  End Function
  
  Function primesfactors(ByVal n as Integer) As Integer()
    Dim tab(n + 1) As Integer
    For  i As Integer  = 0 to  n + 1 - 1
      tab(i) = 0
    Next
    Dim d As Integer = 2
    Do While n <> 1 AndAlso d * d <= n
      If (n Mod d) = 0 Then
        tab(d) = tab(d) + 1
        n = n \ d
      Else
        d = d + 1
      End If
    Loop
    tab(n) = tab(n) + 1
    Return tab
    End Function
    
    
    Sub Main()
      Dim lim As Integer = 20
      Dim o(lim + 1) As Integer
      For  m As Integer  = 0 to  lim + 1 - 1
        o(m) = 0
      Next
      For  i As Integer  = 1 to  lim
        Dim t As Integer() = primesfactors(i)
        For  j As Integer  = 1 to  i
          Dim g As Integer = o(j)
          Dim h As Integer = t(j)
          Dim f As Integer = max2_(g, h)
          o(j) = f
        Next
      Next
      Dim product As Integer = 1
      For  k As Integer  = 1 to  lim
        For  l As Integer  = 1 to  o(k)
          product = product * k
        Next
      Next
      Console.Write("" & product & "" & Chr(10) & "")
      End Sub
      
    End Module
    
    