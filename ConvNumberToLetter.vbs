Option Explicit


'***********
' Devise=0   aucune
'       =1   Euro €
'       =2   Dollar $
' Langue=0   Français
'       =1   Belgique
'       =2   Suisse
'***********
' Conversion limitée à 999 999 999 999 999 ou 9 999 999 999 999,99
' si le nombre contient plus de 2 décimales, il est arrondit à 2 décimales


Public Function ConvNumberLetter(Nombre As Double, Optional Devise As Byte = 0, _
                                    Optional Langue As Byte = 0) As String
    Dim dblEnt As Variant, byDec As Byte
    Dim bNegatif As Boolean
    Dim strDev As String, strCentimes As String
    
    If Nombre < 0 Then
        bNegatif = True
        Nombre = Abs(Nombre)
    End If
    dblEnt = Int(Nombre)
    byDec = CInt((Nombre - dblEnt) * 100)
    If byDec = 0 Then
        If dblEnt > 999999999999999# Then
            ConvNumberLetter = "#TropGrand"
            Exit Function
        End If
    Else
        If dblEnt > 9999999999999.99 Then
            ConvNumberLetter = "#TropGrand"
            Exit Function
        End If
    End If
    Select Case Devise
        Case 0
            If byDec > 0 Then strDev = " ,"
        Case 1
            strDev = " euro"
            If byDec > 0 Then strCentimes = strCentimes & " centime"
            If byDec > 1 Then strCentimes = strCentimes & "s"
        Case 2
            strDev = " Dollar"
            If byDec > 0 Then strCentimes = strCentimes & " Cent"
    End Select
    If dblEnt > 1 And Devise <> 0 Then strDev = strDev & "s"
    ConvNumberLetter = ConvNumEnt(CDbl(dblEnt), Langue) & strDev & " " & _
        ConvNumDizaine(byDec, Langue) & strCentimes
End Function

Private Function ConvNumEnt(Nombre As Double, Langue As Byte)
    Dim byNum As Byte, iTmp As Variant, dblReste As Double
    Dim strTmp As String
    
    iTmp = Nombre - (Int(Nombre / 1000) * 1000)
    ConvNumEnt = ConvNumCent(CInt(iTmp), Langue)
    dblReste = Int(Nombre / 1000)
    iTmp = dblReste - (Int(dblReste / 1000) * 1000)
    strTmp = ConvNumCent(CInt(iTmp), Langue)
    Select Case iTmp
        Case 0
        Case 1
            strTmp = "mille "
        Case Else
            strTmp = strTmp & " mille "
    End Select
    ConvNumEnt = strTmp & ConvNumEnt
    dblReste = Int(dblReste / 1000)
    iTmp = dblReste - (Int(dblReste / 1000) * 1000)
    strTmp = ConvNumCent(CInt(iTmp), Langue)
    Select Case iTmp
        Case 0
        Case 1
            strTmp = strTmp & " million "
        Case Else
            strTmp = strTmp & " millions "
    End Select
    ConvNumEnt = strTmp & ConvNumEnt
    dblReste = Int(dblReste / 1000)
    iTmp = dblReste - (Int(dblReste / 1000) * 1000)
    strTmp = ConvNumCent(CInt(iTmp), Langue)
    Select Case iTmp
        Case 0
        Case 1
            strTmp = strTmp & " milliard "
        Case Else
            strTmp = strTmp & " milliards "
    End Select
    ConvNumEnt = strTmp & ConvNumEnt
    dblReste = Int(dblReste / 1000)
    iTmp = dblReste - (Int(dblReste / 1000) * 1000)
    strTmp = ConvNumCent(CInt(iTmp), Langue)
    Select Case iTmp
        Case 0
        Case 1
            strTmp = strTmp & " billion "
        Case Else
            strTmp = strTmp & " billions "
    End Select
    ConvNumEnt = strTmp & ConvNumEnt
    
End Function

Private Function ConvNumDizaine(Nombre As Byte, Langue As Byte) As String
    Dim TabUnit As Variant, TabDiz As Variant
    Dim byUnit As Byte, byDiz As Byte
    Dim strLiaison As String
    
    TabUnit = Array("", "un", "deux", "trois", "quatre", "cinq", "six", "sept", _
        "huit", "neuf", "dix", "onze", "douze", "treize", "quatorze", "quinze", _
        "seize", "dix-sept", "dix-huit", "dix-neuf")
    TabDiz = Array("", "", "vingt", "trente", "quarante", "cinquante", _
        "soixante", "soixante", "quatre-vingt", "quatre-vingt")
    If Langue = 1 Then
        TabDiz(7) = "septante"
        TabDiz(9) = "nonante"
    ElseIf Langue = 2 Then
        TabDiz(7) = "septante"
        TabDiz(8) = "huitante"
        TabDiz(9) = "nonante"
    End If
    byDiz = Int(Nombre / 10)
    byUnit = Nombre - (byDiz * 10)
    strLiaison = "-"
    If byUnit = 1 Then strLiaison = " et "
    Select Case byDiz
        Case 0
            strLiaison = ""
        Case 1
            byUnit = byUnit + 10
            strLiaison = ""
        Case 7
            If Langue = 0 Then byUnit = byUnit + 10
        Case 8
            If Langue <> 2 Then strLiaison = "-"
        Case 9
            If Langue = 0 Then
                byUnit = byUnit + 10
                strLiaison = "-"
            End If
    End Select
    ConvNumDizaine = TabDiz(byDiz)
    If byDiz = 8 And Langue <> 2 And byUnit = 0 Then ConvNumDizaine = ConvNumDizaine & "s"
    If TabUnit(byUnit) <> "" Then
        ConvNumDizaine = ConvNumDizaine & strLiaison & TabUnit(byUnit)
    Else
        ConvNumDizaine = ConvNumDizaine
    End If
End Function

Private Function ConvNumCent(Nombre As Integer, Langue As Byte) As String
    Dim TabUnit As Variant
    Dim byCent As Byte, byReste As Byte
    Dim strReste As String
    
    TabUnit = Array("", "un", "deux", "trois", "quatre", "cinq", "six", "sept", _
        "huit", "neuf", "dix")
    
    byCent = Int(Nombre / 100)
    byReste = Nombre - (byCent * 100)
    strReste = ConvNumDizaine(byReste, Langue)
    Select Case byCent
        Case 0
            ConvNumCent = strReste
        Case 1
            If byReste = 0 Then
                ConvNumCent = "cent"
            Else
                ConvNumCent = "cent " & strReste
            End If
        Case Else
            If byReste = 0 Then
                ConvNumCent = TabUnit(byCent) & " cents"
            Else
                ConvNumCent = TabUnit(byCent) & " cent " & strReste
            End If
    End Select
End Function