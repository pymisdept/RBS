Option Explicit

Const adOpenStatic = 3
Const adLockOptimistic = 3
Const adUseClient = 3
Const fromEmail = "Room Booking System <rbs-admin@pyengineering.com>"
Const subject = "Room Booking Daily Summary - "

dim cn, rs, rs2, rs3, connectionString
Dim sql, sql2, sql3, sql4
Dim oShell
Dim template
Dim dtmWorkDay

Dim trows
'On Error Resume Next

Set oShell = CreateObject("WScript.Shell")

set cn = CreateObject("ADODB.Connection")
set rs = CreateObject("ADODB.Recordset")
set rs2 = CreateObject("ADODB.Recordset")
set rs3 = CreateObject("ADODB.Recordset")

connectionString = "Driver={MariaDB ODBC 3.0 Driver};Server=127.0.0.1;" & _
                   "Database=booked; User=root; Password=rb920711;"

cn.Open connectionString

sql4 = "SELECT DATE_FORMAT(fn_getNextWorkDay(), '%Y-%m-%d') AS wdate"	
'sql4 = "SELECT DATE_FORMAT(fn_getNextWorkDayWithParam('2019-04-05'), '%Y-%m-%d') AS wdate"	

rs2.open sql4, cn, adOpenStatic, adLockOptimistic

If not rs2.eof Then	
	dtmWorkDay = rs2("wdate")
Else
	dtmWorkDay = GetFormattedDate(Date() + 1)
End If
rs2.close

sql = "SELECT s.series_id as series_id, s.title as contactperson, "
sql = sql & "CASE WHEN CAST(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone) as date) != CAST(CONVERT_TZ(i.end_date,'+00:00',@@global.time_zone) as date) THEN CONCAT(s.description) ELSE s.description END as remarks, "
sql = sql & "rs.name as roomname, "
sql = sql & "CASE WHEN CAST(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone) as date) = '" & dtmWorkDay &"' THEN DATE_FORMAT(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone), '%H:%i ') ELSE '07:00' END AS startdate, "
sql = sql & "CASE 	WHEN CAST(CONVERT_TZ(i.end_date,'+00:00',@@global.time_zone) as date) = '" & dtmWorkDay &"' THEN DATE_FORMAT(CONVERT_TZ(i.end_date,'+00:00',@@global.time_zone), '%H:%i ') ELSE '19:00' END AS enddate, "
sql = sql & "s.status_id as status_id, ca.attribute_value as deptname,ca2.attribute_value as nop, ca3.attribute_value as ext, ca4.attribute_value as guestname, ca5.attribute_value as bookpur , ca6.attribute_value as pyrep, "
sql = sql & "IFNULL(ca7.attribute_value, '') as rmdrinks, NVL(ca8.attribute_value, '') as dqty "
sql = sql & "FROM reservation_series s "
sql = sql & "LEFT JOIN reservation_resources rr ON ( s.series_id = rr.series_id) "
sql = sql & "LEFT JOIN reservation_instances i ON ( s.series_id = i.series_id ) "
sql = sql & "LEFT JOIN resources rs ON ( rr.resource_id = rs.resource_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca ON ( ca.custom_attribute_id = 1 AND s.series_id = ca.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca2 ON (  ca2.custom_attribute_id = 6 AND s.series_id = ca2.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca3 ON (  ca3.custom_attribute_id = 10 AND s.series_id = ca3.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca4 ON (  ca4.custom_attribute_id = 12 AND s.series_id = ca4.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca5 ON (  ca5.custom_attribute_id = 11 AND s.series_id = ca5.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca6 ON (  ca6.custom_attribute_id = 13 AND s.series_id = ca6.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca7 ON (  ca7.custom_attribute_id = 18 AND s.series_id = ca7.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca8 ON (  ca8.custom_attribute_id = 19 AND s.series_id = ca8.entity_id ) "
sql = sql & "WHERE '" & dtmWorkDay & "' BETWEEN CAST(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone) as date) AND CAST(CONVERT_TZ(i.end_date,'+00:00',@@global.time_zone) as date) "
sql = sql & "AND s.status_id IN (1,2) "
sql = sql & "ORDER BY roomname desc, startdate desc, enddate desc"

rs.open sql, cn, adOpenStatic, adLockOptimistic
template = ReadFile("C:\batch\dailyreport_template.html")

Dim  sid, iReturn, iCmd, acces, tmpAcces
Dim dStartTag, dEndTag, dRemarks, dPart, dClass
Dim tmpBP, tmpExt

If not rs.eof Then	
	rs.MoveLast
	while not rs.bof	
		
	   sid = rs("series_id")
	   'MsgBox (sid)
	   acces = ""
	   
	   if rs("status_id") = "2" then
			dStartTag = "<s>"
			dEndTag = "</s>"
			dRemarks = "<b>CANCELLED</b>"
			dClass = "cancelled"
			tmpBP = ""
	   else
			dStartTag = ""
			dEndTag = ""
			dClass = ""
			tmpBP = rs("bookpur")
			
			if IsNull(tmpBP) then 
				dRemarks = "<u>[N/A]</u> " & rs("remarks") 
			else
				dRemarks = "<u>[" & tmpBP & "]</u> " & rs("remarks") 
			end if 
			
	   end if
	   
	   tmpExt = rs("ext")
	   dPart = rs("nop")
	   
	   if Len(tmpExt) = 3 Then			
			tmpExt = "EXT. " & tmpExt
	   End If
	   
	   trows = trows & "<tr class=""" & dClass & """>"
	   trows = trows & "<td>" & dStartTag & rs("roomname") & dEndTag & "</td>"
	   trows = trows & "<td>" & dStartTag & rs("startdate") & " - " & rs("enddate") & dEndTag & "</td>"
	   trows = trows & "<td>" & dStartTag & rs("contactperson") & " " & tmpExt & dEndTag & "</td>"
	   trows = trows & "<td>" & dStartTag & rs("deptname") & dEndTag & "</td>"	   
	   trows = trows & "<td>" & dStartTag & dPart & dEndTag & "</td>"
	   
	   acces = rs("rmdrinks")
	   if acces = "" then 
			acces = "--"
	   else
			if acces <> "On Request" then
				acces = acces & " (" & rs("dqty") & ")"
			end if
	   end if
	   
	   trows = trows & "<td>" & dStartTag & acces & dEndTag & "</td>"
	   trows = trows & "<td>" & dStartTag & rs("guestname") & dEndTag & "</td>"	
	   trows = trows & "<td>" & dStartTag & rs("pyrep") & dEndTag & "</td>"	   
	   trows = trows & "<td>" & dRemarks & "</td>"
	   trows = trows & "</tr>"
		
		rs.MovePrevious
	wend
	
	trows = Replace(trows, "'", "''")
	template = Replace(template, "[date]" , dtmWorkDay)	
	template = Replace(template, "[booking_rows]" , trows)	

	iCmd = ".\sendEmail.ps1 -from '" & fromEmail & "' -tostr " & "'pollyleung@pyengineering.com,vickylee@pyengineering.com,reception@pyengineering.com'" & " -ccstr  " & "'jonathanwee@pyengineering.com,fyleung@pyengineering.com'" & " -subject '" & subject & dtmWorkDay & "' -body '" & template & "'"
	iCmd = "powershell.exe " & iCmd
			
	iReturn = oShell.Run(iCmd, 1, true)
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