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
Your booking was cancelled.
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
	<tr>
		<td>Cancel Reason:</td>
		<td>{$DeleteReason|nl2br}</td>
	</tr>
</table>
<br />
Thanks and Regards,
<br />
Room Booking System
<br />
<br />
**This is a system generated email, please do not reply to this email.