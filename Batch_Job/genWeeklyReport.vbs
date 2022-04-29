Option Explicit	

Const adOpenStatic = 3
Const adLockOptimistic = 3
Const adUseClient = 3
Const fromEmail = "Room Booking System <rbs-admin@pyengineering.com>"
Const subject = "Room Booking Weekly Summary (TEST) - "

dim cn, rs, rs3, connectionString
Dim sql, sql2, sql3, sql4
Dim oShell
Dim template
Dim thisYear, nextMonday, nextSaturday, weekNo

Dim trows

Set oShell = CreateObject("WScript.Shell")

set cn = CreateObject("ADODB.Connection")
set rs = CreateObject("ADODB.Recordset")
set rs3 = CreateObject("ADODB.Recordset")

connectionString = "Driver={MariaDB ODBC 3.0 Driver};Server=127.0.0.1;" & _
                   "Database=booked; User=root; Password=fa920711;"

cn.Open connectionString

'nextMonday = DateAdd("d", 2 - DatePart("w", Date), Date)
'nextSaturday = DateAdd("d", 7 - DatePart("w", Date), Date)

nextMonday = DateAdd("d", 9 - DatePart("w", Date), Date)
nextSaturday = DateAdd("d", 14 - DatePart("w", Date), Date)

thisYear = DatePart("yyyy", nextMonday, vbMonday, vbFirstFullWeek)
weekNo = DatePart("ww", nextMonday, vbMonday, vbFirstJan1)
	
sql = "select s.series_id as series_id, s.title as contactperson, s.description as remarks, rs.name as roomname, "
sql = sql & "DATE_FORMAT(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone), '%Y-%m-%d (%W)') AS mdate, "
sql = sql & "DATE_FORMAT(CONVERT_TZ(i.end_date,'+00:00',@@global.time_zone), '%Y-%m-%d (%W)') AS edate, "
sql = sql & "DATE_FORMAT(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone), '%H:%i ') AS starttime, "
sql = sql & "DATE_FORMAT(CONVERT_TZ(i.end_date,'+00:00',@@global.time_zone), '%H:%i ') AS endtime, "
sql = sql & "s.status_id as status_id, ca.attribute_value as deptname, ca2.attribute_value as ext, ca3.attribute_value as nop, ca4.attribute_value as guestname, ca5.attribute_value as bookpur , ca6.attribute_value as pyrep, "
sql = sql & "IFNULL(ca7.attribute_value, '') as rmdrinks, NVL(ca8.attribute_value, '') as dqty "
sql = sql & "from reservation_series s "
sql = sql & "LEFT JOIN reservation_resources rr ON ( s.series_id = rr.series_id) "
sql = sql & "LEFT JOIN reservation_instances i ON ( s.series_id = i.series_id ) "
sql = sql & "LEFT JOIN resources rs ON ( rr.resource_id = rs.resource_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca ON (  ca.custom_attribute_id = 1 AND s.series_id = ca.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca2 ON (  ca2.custom_attribute_id = 10 AND s.series_id = ca2.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca3 ON (  ca3.custom_attribute_id = 6 AND s.series_id = ca3.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca4 ON (  ca4.custom_attribute_id = 12 AND s.series_id = ca4.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca5 ON (  ca5.custom_attribute_id = 11 AND s.series_id = ca5.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca6 ON (  ca6.custom_attribute_id = 13 AND s.series_id = ca6.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca7 ON (  ca7.custom_attribute_id = 18 AND s.series_id = ca7.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca8 ON (  ca8.custom_attribute_id = 19 AND s.series_id = ca8.entity_id ) "
sql = sql & "where s.status_id = 1 AND "
sql = sql & "(cast(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone) as date) between '" & GetFormattedDate(nextMonday) & "' AND '" & GetFormattedDate(nextSaturday) & "' "
sql = sql & "OR "
sql = sql & "(cast(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone) as date) not between '" & GetFormattedDate(nextMonday) & "' AND '" & GetFormattedDate(nextSaturday) & "' " 
sql = sql & "AND '" & GetFormattedDate(nextMonday) & "' BETWEEN cast(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone) as date) AND  cast(CONVERT_TZ(i.end_date,'+00:00',@@global.time_zone) as date))) "
sql = sql & "order by mdate desc, roomname desc, starttime desc, endtime desc"

rs.open sql, cn, adOpenStatic, adLockOptimistic
template = ReadFile("C:\batch\weeklyreport_html_template.html")

Dim  sid, iReturn, iCmd, acces, tmpAcces
Dim dStartTag, dEndTag, dRemarks
Dim tmpBP, tmpExt

If not rs.eof Then	
	rs.MoveLast
	while not rs.bof	
		
	   sid = rs("series_id")
	   'MsgBox (sid)
	   acces = ""
	   tmpBP = rs("bookpur")
	   tmpExt = rs("ext")
	    
	   if Len(tmpExt) = 3 Then
			tmpExt = "EXT. " & tmpExt
	   End If
	   
	   trows = trows & "<tr>"
	   If rs("mdate")  <> rs("edate") Then
		trows = trows & "<td>" & rs("mdate") & " to <br />" & rs("edate") & "</td>"
	   Else
	    trows = trows & "<td>" & rs("mdate") & "</td>"
	   End If
	   trows = trows & "<td>" & rs("roomname") & "</td>"
	   trows = trows & "<td>" & rs("starttime") & " - " & rs("endtime") & "</td>"
	   trows = trows & "<td>" & rs("contactperson") & " " & tmpExt & "</td>"
	   trows = trows & "<td>" & rs("deptname") & "</td>"	 
	   trows = trows & "<td>" & rs("nop") & "</td>"
	   	  
		if IsNull(tmpBP) then 
			dRemarks = "<u>[N/A]</u> " & rs("remarks") 
		else
			dRemarks = "<u>[" & tmpBP & "]</u> " & rs("remarks") 
		end if 
		
		acces = rs("rmdrinks")
	    if acces = "" then 
			acces = "--"
		else
			if acces <> "On Request" then
				acces = acces & " (" & rs("dqty") & ")"
			end if
		end if
	   
		trows = trows & "<td>" & acces & "</td>"  
	    trows = trows & "<td>" & rs("guestname") & "</td>"
	    trows = trows & "<td>" & rs("pyrep") & "</td>"
	    trows = trows & "<td>" & dRemarks & "</td>"
		trows = trows & "</tr>"
		
		rs.MovePrevious
	wend
	
	trows = Replace(trows, "'", "''")
	template = Replace(template, "[year]" , thisYear)	
	template = Replace(template, "[weekno]" , weekNo)	
	template = Replace(template, "[sdate]" , GetFormattedDate(nextMonday))	
	template = Replace(template, "[edate]" ,GetFormattedDate(nextSaturday))	
	template = Replace(template, "[booking_rows]" , trows)	
	template = Replace(template, "[lastupd]" , Now)	
	
	WriteFile "C:\inetpub\wwwroot\booked\report\weekly.html", template
	
End If

rs.close
cn.close


Function GetFormattedDate (inDate)
  Dim strDate, strDay, strMonth, strYear
  
  strDate = CDate(inDate)
  strDay = DatePart("d", strDate)
  strMonth = DatePart("m", strDate)
  strYear = DatePart("yyyy", strDate)
  If strDay < 10 Then
    strDay = "0" & strDay
  End If
  If strMonth < 10 Then
    strMonth = "0" & strMonth
  End If
  GetFormattedDate = strYear & "-" & strMonth & "-" & strDay
End Function

'On Error Goto 0

Function ReadFile(filename)
    'ensure reference is set to Microsoft ActiveX DataObjects library (the latest version of it).
    'under "tools/references"... references travel with the excel file, so once added, no need to worry.
    'if not you will get a type mismatch / library error on line below.
    Dim objStream, strData

    Set objStream = CreateObject("ADODB.Stream")
    
    objStream.Charset = "utf-8"
    objStream.Open
    objStream.LoadFromFile (filename)
    
    strData = objStream.ReadText()
    
    objStream.Close
    Set objStream = Nothing
    
    ReadFile = strData
    
End Function

Sub WriteFile(filename, strText)
    'ensure reference is set to Microsoft ActiveX DataObjects library (the latest version of it).
    'under "tools/references"... references travel with the excel file, so once added, no need to worry.
    'if not you will get a type mismatch / library error on line below.
	Dim objStream
	Set objStream = CreateObject("ADODB.Stream")
	objStream.CharSet = "utf-8"
	objStream.Open
	objStream.WriteText strText
	objStream.SaveToFile filename, 2
	
	objStream.Close
    Set objStream = Nothing
End Sub