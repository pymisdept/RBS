Option Explicit

Const adOpenStatic = 3
Const adLockOptimistic = 3
Const adUseClient = 3
Const fromEmail = "Room Booking System <rbs-admin@pyengineering.com>"
Const subject = "Room Booking Monthly Statistical Report"

Const xlContinuous = 1
Const xlEdgeTop = 8
Const xlEdgeBottom = 9
Const xlThin = 2

Const xlExclusive = 3
Const xlLocalSessionChanges = 2

dim cn, rs, rs2, rs3, rs4, connectionString
Dim sql
Dim oShell, iReturn, iCmd
Dim template
Dim pMonth, pYear, LastDay, FirstDay

Dim rows
Dim srows, prows, grows

Dim objWorksheet, objWorkbook, objExcel, objRange	

Set oShell = CreateObject("WScript.Shell")

set cn = CreateObject("ADODB.Connection")
set rs = CreateObject("ADODB.Recordset")
set rs2 = CreateObject("ADODB.Recordset")
set rs3 = CreateObject("ADODB.Recordset")
set rs4 = CreateObject("ADODB.Recordset")

connectionString = "Driver={MariaDB ODBC 3.0 Driver};Server=127.0.0.1;" & _
                   "Database=booked; User=root; Password=rb920711;"

cn.Open connectionString


pMonth = DatePart("m", DateAdd("m", -1, Date))
pYear = DatePart("yyyy", DateAdd("m", -1, Date))
lastDay = DateSerial(Year(Date),Month(Date),0)

'pMonth = DatePart("m", DateAdd("m", +0, Date))
'pYear = DatePart("yyyy", DateAdd("m", +0, Date))
'lastDay = DateSerial(Year(Date),Month(Date)+1,0)

firstDay = LastDay-Day(LastDay)+1

cn.Execute("DROP TEMPORARY TABLE IF EXISTS temp_room_stat;")

cn.Execute("CREATE TEMPORARY TABLE temp_room_stat(series_id	int(10),contactperson varchar(300),remarks text,roomid int(10),roomname varchar(85),sdate text,edate text,tdiff decimal(10,1),deptname text,nop text,guestname text,bookpur text, pyrep text, booktopic text, obookpur text);")

sql = "insert into temp_room_stat "
sql = sql & "select s.series_id as series_id, s.title as contactperson, s.description as remarks, rs.resource_id as roomid, rs.name as roomname, "
sql = sql & "DATE_FORMAT(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone), '%Y-%m-%d %H:%i') AS sdate, "
sql = sql & "DATE_FORMAT(CONVERT_TZ(i.end_date,'+00:00',@@global.time_zone), '%Y-%m-%d %H:%i') AS edate, "
sql = sql & "TIMESTAMPDIFF(MINUTE, i.start_date, i.end_date) as tdiff, "
sql = sql & "IFNULL(ca.attribute_value,'') as deptname, IFNULL(ca3.attribute_value,0) as nop, "
sql = sql & "IFNULL(ca4.attribute_value,'') as guestname, IFNULL(ca5.attribute_value,'N/A') as bookpur , IFNULL(ca6.attribute_value,'') as pyrep, "
sql = sql & "IFNULL(ca7.attribute_value,'') as booktopic, IFNULL(ca8.attribute_value,'') as obookpur "
sql = sql & "from reservation_series s "
sql = sql & "LEFT JOIN reservation_resources rr ON ( s.series_id = rr.series_id) "
sql = sql & "LEFT JOIN reservation_instances i ON ( s.series_id = i.series_id ) "
sql = sql & "LEFT JOIN resources rs ON ( rr.resource_id = rs.resource_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca ON (  ca.custom_attribute_id = 1 AND s.series_id = ca.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca3 ON (  ca3.custom_attribute_id = 6 AND s.series_id = ca3.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca4 ON (  ca4.custom_attribute_id = 12 AND s.series_id = ca4.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca5 ON (  ca5.custom_attribute_id = 11 AND s.series_id = ca5.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca6 ON (  ca6.custom_attribute_id = 13 AND s.series_id = ca6.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca7 ON (  ca7.custom_attribute_id = 16 AND s.series_id = ca7.entity_id ) "
sql = sql & "LEFT JOIN custom_attribute_values ca8 ON (  ca8.custom_attribute_id = 17 AND s.series_id = ca8.entity_id ) "
sql = sql & "where s.status_id = 1 AND "
sql = sql & "(cast(CONVERT_TZ(i.start_date,'+00:00',@@global.time_zone) as date) between '" & GetFormattedDate(firstDay) & "' AND '" & GetFormattedDate(lastDay) & "') "
sql = sql & "AND rr.resource_id IN (18,21) "

cn.Execute(sql)

template = ReadFile("D:\stat\stat_report.html") 

sql = "select * from temp_room_stat order by roomname desc, sdate desc"
rs.open sql, cn, adOpenStatic, adLockOptimistic

set objExcel = CreateObject("Excel.Application")
set objWorkbook=objExcel.Workbooks.Open("D:\stat\Template.xlsx")

Set objWorksheet = objExcel.Worksheets("Stat")
objWorksheet.Activate

Dim curRow, tmpBP, tmpBPO, tmpRm, tmpPvRm
Dim filename
curRow = 2

if not rs.eof Then	
	rs.MoveLast	
	rows = rows & vbCrLf 
	while not rs.bof	
		tmpBP = Replace(rs("bookpur"),"&amp;", "&")	
		tmpBPO = Replace(rs("obookpur"),"&amp;", "&")	
		tmpRM = rs("roomname")
		
		If tmpBP = "Others" then
			if tmpBPO <> "" And tmpBPO <> "--" then
				tmpBP = tmpBPO
			end if
		end if
		
		objWorksheet.Cells(curRow,1).value = tmpRM
		objWorksheet.Cells(curRow,2).value = rs("sdate")
		objWorksheet.Cells(curRow,3).value = rs("edate")
		objWorksheet.Cells(curRow,4).value = Replace(rs("deptname"),"&amp;", "&")	
		objWorksheet.Cells(curRow,5).value = CDbl(rs("tdiff")) / 60.0
		objWorksheet.Cells(curRow,6).value = Replace(rs("contactperson"),"&amp;", "&")	
		objWorksheet.Cells(curRow,7).value = rs("nop")
		objWorksheet.Cells(curRow,8).value = tmpBP
		objWorksheet.Cells(curRow,9).value = Replace(rs("guestname"),"&amp;", "&")	
		objWorksheet.Cells(curRow,10).value = Replace(rs("pyrep"),"&amp;", "&")	
		objWorksheet.Cells(curRow,11).value = Replace(rs("booktopic"),"&amp;", "&")	
		objWorksheet.Cells(curRow,12).value = Replace(rs("remarks"),"&amp;", "&")		
		rs.MovePrevious
		
		if tmpPvRm <> "" then
			if tmpRM <> tmpPvRm then			
				With objWorksheet.Rows(curRow).Borders(xlEdgeTop)
					.LineStyle = xlContinuous
					.Weight = xlThin
					.ColorIndex = 1
				End With			
			end if
		end if		
		
		curRow = curRow + 1
		tmpPvRm = tmpRM
	wend
	rs.close
	
	
	''''' (1) Create XLSX Summary
	Set objRange = objWorksheet.UsedRange
	objRange.Font.Name = "Arial"
	objRange.Font.Size = 10
	objRange.EntireColumn.Autofit()
	
	filename = "D:\stat\stat_" & pYear & PadMonth(pMonth) & ".xlsx"
	objWorkbook.Saveas filename

	objWorkbook.Close
	objExcel.workbooks.close
	objExcel.quit

	set objRange = nothing
	set objWorksheet = nothing
	set objWorkbook = nothing
	set objExcel = nothing
	
	''''' (2) Print Summary
	sql = "select roomname, count(*) as rmcount, ROUND(sum(tdiff) / 60,1) as totalhr , sum(nop) as totalnop from temp_room_stat where bookpur NOT IN ('Maintenance') group by roomname desc"
	rs2.open sql, cn, adOpenStatic, adLockOptimistic

	if not rs2.eof Then	
		rs2.MoveLast
		while not rs2.bof	
			srows = srows & "<tr>"
			srows = srows & "<td>" & rs2("roomname") & "</td>"
			srows = srows & "<td>" & rs2("rmcount") & "</td>"
			srows = srows & "<td>" & rs2("totalnop") & "</td>"
			srows = srows & "<td>" & rs2("totalhr") & "</td>"
			srows = srows & "</tr>"
			rs2.MovePrevious
		wend		
		template = Replace(template, "[summary_row]" , srows)	
		rs2.close
	else
		template = Replace(template, "[summary_row]" , "")	
		rs2.close
	end if
	
	'''''' (3) Print Purpose
	Dim prevrid, prevcnt
	prevrid = -1
	prevcnt = 1
					
	sql = "select roomid, roomname, bookpur, count(*) as rmcount, ROUND(sum(tdiff) / 60,1) as totalhr, sum(nop) as totalnop from temp_room_stat group by roomname, bookpur order by roomname desc, bookpur desc;"
	rs3.open sql, cn, adOpenStatic, adLockOptimistic
	if not rs3.eof Then	
		rs3.MoveLast
		while not rs3.bof	
			prows = prows & "<tr>"
			
			if prevrid = rs3("roomid") then
				prevcnt = prevcnt + 1
			else
				prows = Replace(prows, "[prowspan]", prevcnt)
				prows = prows & "<td rowspan='[prowspan]'>" & rs3("roomname") & "</td>"				
				prevcnt = 1
				prevrid = rs3("roomid")
			end if
			
			prows = prows & "<td>" & rs3("bookpur") & "</td>"
			prows = prows & "<td>" & rs3("rmcount") & "</td>"
			prows = prows & "<td>" & rs3("totalnop") & "</td>"
			prows = prows & "<td>" & rs3("totalhr") & "</td>"
			prows = prows & "</tr>"
			rs3.MovePrevious
		wend	
	
		prows = Replace(prows, "[prowspan]", prevcnt)				
		template = Replace(template, "[purpose_row]" , prows)	
		rs3.close
	else
		template = Replace(template, "[purpose_row]" , "")	
		rs3.close
	end if
	
	template = Replace(template, "[year]" , pYear)	
	template = Replace(template, "[month]" , pMonth)	
	template = Replace(template, "'", "''")
	
	iCmd = ".\sendEmail_Att.ps1 -from '" & fromEmail & "' -tostr " & "'pollyleung@pyengineering.com'" & " -ccstr  " & "'jonathanwee@pyengineering.com,fyleung@pyengineering.com'" & " -subject '" & subject & "' -body '" & template & "' -att '" & filename & "'" 
	iCmd = "powershell.exe " & iCmd
	iReturn = oShell.Run(iCmd, 1, true)
	
else
	rs.close
end if

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

Function PadMonth (inNum)
  
  Dim outMonth 
  
  If inNum < 10 Then
    outMonth = "0" & inNum  
  Else
    outMonth = inNum  
  End If
  
  PadMonth = outMonth
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