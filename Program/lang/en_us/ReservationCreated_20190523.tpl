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
<style>
table {
  border-collapse: collapse;
  mso-table-lspace:0; 
  mso-table-rspace:0;
  vertical-align: top;
}

table, th, td {
  border: 1px solid black;
  padding-left: 5px;
  padding-right: 5px;
}
</style>

Dear {$Title},
<br/>
<br/>
{if {$Attr_Cat} eq 'Type A'}
	Your booking is confirmed, and this is a Premium (Type A) booking, it may need around 4 days for preparation.
	<br /><br />
	
	{if {$Attr_TA_Board} eq 'Yes' || {$Attr_TA_NamePlate} eq 'Yes'}
		Please also provide the following information to <u>Corporate Communications</u> and <u>Admin</u> Department: <br />
		<ol>
	{/if}
	
	{if {$Attr_TA_Board} eq 'Yes'}
		<li>Logo of Invited Company </li>
		<li>Display Name of Invited Company </li>
		<li>Welcome message (e.g. 熱烈歡迎XX集團到訪) </li>
	{/if}
	
	{if {$Attr_TA_NamePlate} eq 'Yes'}
		<li>Table Name Plate information </li>		
		<table>
			<tr>
			<th>Salutation<br />銜頭</th>
			<th>Name<br />姓名</th>
			<th>Position<br />職銜</th>
			<th>Company Name<br />公司名</th>
			</tr>
			<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			</tr>
		</table>
	{/if}
	
	{if {$Attr_TA_Board} eq 'Yes' || {$Attr_TA_NamePlate} eq 'Yes'}
		</ol>
		<br />
	{/if}
	Please contact Admin Department if you have any questions about your booking.
{else}
	Your booking is confirmed.
{/if}
<br/>
<br/>
<table width="500" style="width: 500px">
	<tr>
		<td width="200" style="width: 200px" valign="top">Room:</td>
		<td width="*" valign="top">
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
		<td width="200" style="width: 200px" valign="top">Date / Time:</td>		
		
		{if ($StartDate|date_format:"%Y-%m-%d") eq ($EndDate|date_format:"%Y-%m-%d")  }
			<td width="*" valign="top">{$StartDate|date_format:"%Y-%m-%d %H:%M"} - {$EndDate|date_format:"%H:%M"}</td>
		{else}
			<td width="*" valign="top">{$StartDate|date_format:"%Y-%m-%d %H:%M"} - {$EndDate|date_format:"%Y-%m-%d %H:%M"}</td>
		{/if}
		
	</tr>
	<tr>	
		<td width="200" style="width: 200px" valign="top">Contact Person:</td>
		<td width="*" valign="top">
			{$Title} ({$Attr_Ext})
		</td>
	</tr>
	<tr>
		<td width="200" style="width: 200px" valign="top">Booking Purpose:</td>
		<td width="*" valign="top">
		{if {$Attr_Purpose} eq 'Others'}
			{$Attr_OtherPurpose}
		{else}
			{$Attr_Purpose}
		{/if}
		</td>
	</tr>
	<tr>
		<td width="200" style="width: 200px" valign="top">No. of Participants:</td>
		<td width="*" valign="top">{$Attr_NOP}</td>
	</tr>
	{if {$Attr_PYR} neq '--' && {$Attr_PYR} neq ''}
	<tr>
		<td width="200" style="width: 200px" valign="top">Paul Y. Representative:</td>
		<td width="*" valign="top">{$Attr_PYR}</td>
	</tr>
	{/if}
	{if {$Attr_Client} neq '--' && {$Attr_Client} neq ''}
	<tr>
		<td width="200" style="width: 200px" valign="top">External Parties:</td>
		<td width="*" valign="top">{$Attr_Client}</td>
	</tr>
	{/if}
	{if {$Attr_Topic} neq '--' && {$Attr_Topic} neq ''}
	<tr>
		<td width="200" style="width: 200px" valign="top">Topic / Theme:</td>
		<td width="*" valign="top">{$Attr_Topic}</td>
	</tr>
	{/if}
	<tr>
		<td width="200" style="width: 200px" valign="top">Drinks Service:</td>
		<td width="*" valign="top">				
		{if {$Attr_Drinks} eq 'On Request'}
			(*On Request)
		{else if {$Attr_Drinks} neq '--' && {$Attr_Drinks} neq ''}
			{$Attr_Drinks} ({$Attr_DrinkQty})
		{else}
			-
		{/if}
		</td>
	</tr>
	{if {$Attr_Cat} eq 'Type A'}	
	{if {$Attr_MISS} eq 'Yes'}
		<tr>
			<td width="200" style="width: 200px" valign="top">MIS Support:</td>
			<td width="*" valign="top">{$Attr_MISS}, {$Attr_MISR}</td>
		</tr>
	{else}
		<tr>
			<td width="200" style="width: 200px" valign="top">MIS Support:</td>
			<td width="*" valign="top">No</td>
		</tr>
	{/if}
	{if {$Attr_TA_ADMS} eq 'Yes'}
		<tr>
			<td width="200" style="width: 200px" valign="top">Admin Dept Support:</td>
			<td width="*" valign="top">{$Attr_TA_ADMS}, {$Attr_TA_ADMR}</td>
		</tr>
		{else}
		<tr>
			<td width="200" style="width: 200px" valign="top">Admin Dept Support:</td>
			<td width="*" valign="top">No</td>
		</tr>
	{/if}
	<tr>
		<td width="200" style="width: 200px" valign="top">Seating Plan:</td>
		<td width="*" valign="top">{$Attr_Seating}</td>
	</tr>
	<tr>
		<td width="200" style="width: 200px" valign="top">Welcome Carpet:</td>
		<td width="*" valign="top">{$Attr_TA_Carpet}</td>
	</tr>
	<tr>
		<td width="200" style="width: 200px" valign="top">Welcome Notice Board<br />at Lobby:</td>
		<td width="*" valign="top">{$Attr_TA_Board}</td>
	</tr>
	{if {$Attr_TA_NamePlate} eq 'Yes'}
		<tr>
			<td width="200" style="width: 200px" valign="top">Table Name Plate:</td>
			<td width="*" valign="top">{$Attr_TA_NamePlate} ({$Attr_TA_NOP})</td>
		</tr>
		{else}
		<tr>
			<td width="200" style="width: 200px" valign="top">Table Name Plate:</td>
			<td width="*" valign="top">No</td>
		</tr>
	{/if}
	<tr>
		<td width="200" style="width: 200px" valign="top">Photography Service:</td>
		<td width="*" valign="top">{$Attr_TA_Photo}</td>
	</tr>
	<tr>
		<td width="200" style="width: 200px" valign="top">Pick up service:</td>
		<td width="*" valign="top">{$Attr_TA_Pickup}</td>
	</tr>
	<tr>
		<td width="200" style="width: 200px" valign="top">Corporate Video/ PPT:</td>
		<td width="*" valign="top">{$Attr_TA_CoprVDO}</td>
	</tr>
	<tr>
		<td width="200" style="width: 200px" valign="top">Office Tour:</td>
		<td width="*" valign="top">{$Attr_TA_Tour}</td>
	</tr>
	<tr>
		<td width="200" style="width: 200px" valign="top">Snacks:</td>
		<td width="*" valign="top">{$Attr_TA_Snack}</td>
	</tr>
	<tr>
		<td width="200" style="width: 200px" valign="top">Décor Arrangement:</td>
		<td width="*" valign="top">{$Attr_TA_Decor}</td>
	</tr>
	<tr>
		<td width="200" style="width: 200px" valign="top">Dining Arrangement:</td>
		<td width="*" valign="top">{$Attr_TA_Dinning}</td>
	</tr>
	{else}
		{if {$Attr_MISS} eq 'Yes'}
			<tr>
				<td width="200" style="width: 200px" valign="top">MIS Support:</td>
				<td width="*" valign="top">{$Attr_MISS}, {$Attr_MISR}</td>
			</tr>
			{else}
			<tr>
				<td width="200" style="width: 200px" valign="top">MIS Support:</td>
				<td width="*" valign="top">{$Attr_MISS}</td>
			</tr>
		{/if}
	{/if}
	<tr>
		<td width="200" style="width: 200px" valign="top">Remarks:</td>
		<td width="*" valign="top">{$Description|nl2br}<br />&nbsp;</td>
	</tr>
</table>
<br />
Thanks and Regards,
<br />
Room Booking System
<br />
<br />
**This is a system generated email, please do not reply to this email.