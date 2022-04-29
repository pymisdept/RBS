{*
Copyright 2011-2018 Nick Korbel

This file is part of Booked Scheduler.

Booked Scheduler is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Booked Scheduler is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Booked Scheduler.  If not, see <http://www.gnu.org/licenses/>.
*}

Dear Sir / Madam,
<br/>
<br/>
{if {$Cat} eq 'Type A'}
	Your booking is confirmed, and this is a Premium (Type A) booking, it may need around 4 days for the preparation.
	<br /><br />
	If you want to display Logo of Invited Company, please send the image file to Admin Department  
	<br /><br />
	Please contact Admin Department if you have any questions.
{else}
	Your booking is confirmed.
{/if}
<br/>
<br/>

<table border="3" width="60%">

	<tr>
		<td>會議室<br />Room:</td>
		<td>
			{if $ResourceNames|count > 1}					
				{foreach from=$ResourceNames item=resourceName}
					{$resourceName}
					<br/>				
				{/foreach}
			{else}
				{$ResourceName}		
			{/if}
		</td>
	</tr>
	<tr>
		<td>預訂時間<br />Date / Time:</td>		
		<td>{$StartDate|date_format:"%Y-%m-%d %H:%M"} - {$EndDate|date_format:"%H:%M"}</td>
	</tr>
	<tr>	
		<td>聯絡人<br />Contact Person:</td>
		<td>
			{$Title} ({$Extension})
		</td>
	</tr>
	<tr>
		<td>會議目的<br />Booking Purpose:</td>
		<td>
		{if {$Attr_Purpose} eq 'Others'}
			{$Attr_OtherPurpose}
		{else}
			{$Attr_Purpose}
		{/if}
		</td>
	</tr>
	<tr>
		<td>與會人數<br />No. of Participants:</td>
		<td>{$Attr_NOP}</td>
	</tr>
	{if {$Attr_PYR} neq '--' && {$Attr_PYR} neq ''}
	<tr>
		<td>保華代表<br />Paul Y. Representative:</td>
		<td>{$Attr_PYR}</td>
	</tr>
	{/if}
	{if {$Attr_Client} neq '--' && {$Attr_Client} neq ''}
	<tr>
		<td>訪客公司<br />External Parties:</td>
		<td>{$Attr_Client}</td>
	</tr>
	{/if}
	{if {$Attr_Topic} neq '--' && {$Attr_Topic} neq ''}
	<tr>
		<td>到訪主題<br />Topic / Theme:</td>
		<td>{$Attr_Topic}</td>
	</tr>
	{/if}
	<tr>
		<td>飲品<br />Drinks Service:</td>
		<td>		
		{if {$Attr_Drinks} neq '--' && {$Attr_Drinks} neq ''}
			{$Attr_Drinks} ({$Attr_DrinkQty})
		{else if {$Attr_Drinks} eq 'On Request'}
			{$Attr_Drinks} (*On Request)
		{else}
			--
		{/if}
		</td>
	</tr>
	<tr>
		<td>MIS部協助<br />MIS Dept Support:</td>
		<td>{$Attr_MISR}</td>
	</tr>
	<tr>
		<td>行政部協助<br />Admin Dept Support:</td>
		<td>{$Attr_TA_ADMR}</td>
	</tr>
	<tr>
		<td>桌椅布局<br />Seating Plan:</td>
		<td>{$Attr_Seating}</td>
	</tr>
	<tr>
		<td>歡迎地毯<br />Welcome Carpet:</td>
		<td>{$Attr_TA_Carpet}</td>
	</tr>
	<tr>
		<td>大堂歡迎板<br />Welcome Notice Board at Lobby:</td>
		<td>{$Attr_TA_Board}</td>
	</tr>
	<tr>
		<td>桌面名牌<br />Table Name Plate:</td>
		<td>{$Attr_TA_NamePlate} ({$Attr_TA_NOP})</td>
	</tr>
	<tr>
		<td>大會攝影<br />Photography Service:</td>
		<td>{$Attr_TA_Photo}</td>
	</tr>
	<tr>
		<td>車輛接送<br />Pick up service:</td>
		<td>{$Attr_TA_Pickup}</td>
	</tr>
	<tr>
		<td>播放企業影片或簡介<br />Corporate Video/ PPT:</td>
		<td>{$Attr_TA_CoprVDO}</td>
	</tr>
	<tr>
		<td>參觀辦公室<br />Office Tour:</td>
		<td>{$Attr_TA_Tour}</td>
	</tr>
	<tr>
		<td>茶點<br />Snacks:</td>
		<td>{$Attr_TA_Snack}</td>
	</tr>
	<tr>
		<td>擺設安排<br />Décor Arrangement:</td>
		<td>{$Attr_TA_Decor}</td>
	</tr>
	<tr>
		<td>膳食安排<br />Dining Arrangement:</td>
		<td>{$Attr_TA_Dinning}</td>
	</tr>
	<tr>
		<td>備註<br />Remarks:</td>
		<td>{$Description|nl2br}</td>
	</tr>
</table>


<br />
Thanks and Regards,
<br />
Room Booking System
<br />
<br />
**This is a system generated email, please do not reply to this email.