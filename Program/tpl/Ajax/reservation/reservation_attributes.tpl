{*
Copyright 2014-2019 Nick Korbel

This file is part of phpScheduleIt.

phpScheduleIt is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

phpScheduleIt is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with phpScheduleIt.  If not, see <http://www.gnu.org/licenses/>.
*}
<input type="hidden" id="cur_hide_name" value="{$fname} {$lname}" />
<input type="hidden" id="cur_hide_email" value="{$email}" />
<input type="hidden" id="cur_hide_phone" value="{$phone}" />
{$num = 0}
{if $Attributes|count > 0}
    <div class="customAttributes">
        <div class="row">
            {foreach from=$Attributes item=attribute name=attributes}
                {if $num == 3 || $num == 6 || $num == 9 || $num == 13 || $num == 15 || $num == 17 || $num == 19 || $num == 21 || $num == 23 || $num == 25}
                    </div>
					
					{if $num == 3}
					 <div class="row">
					  <div class="customAttribute col-sm-12 col-xs-12" style="margin-bottom: -15px">
						<hr />
					  </div>
					 </div>
					{else if $num == 15}
					<span id="section_typea">
					<div class="row">
					  <div class="customAttribute col-sm-12 col-xs-12" style="margin-bottom: -15px">
						<hr />
					  </div>
					</div>
					
					{/if}
					
                    <div class="row custAttr">
                {/if}
				
				{if $attribute->id() == 18}
					<div class="customAttribute col-sm-3 col-xs-12">
				{elseif $attribute->id() == 19}
					<div class="customAttribute col-sm-1 col-xs-12">
				{elseif $attribute->id() == 20}
					<div class="customAttribute col-sm-2 col-xs-12">	
				{elseif $attribute->id() == 21}
					<div class="customAttribute col-sm-6 col-xs-12">	
				{else}
					<div class="customAttribute col-sm-4 col-xs-12">                   
				{/if}
				
				{control type="AttributeControl" attribute=$attribute readonly=$ReadOnly }
				
						{if $attribute->id() == 14}
							<a href="11f_func_seating.html" target="_blank">View Seating Plan</a>
						{/if}
						
						{if $attribute->id() == 37}
							<a href="11f_mult_seating.html" target="_blank">View Seating Plan</a>
						{/if}
						
						{if $attribute->id() == 15}
							<a href="11f_category.html" target="_blank">View Category Description</a>
						{/if}
                </div>
		
				{$num = $num + 1}					

            {/foreach}
			</span>
        </div>
    </div>
    <div class="clear"><hr /></div>
	<script>
	
    $(function () {	
		var purvalue = $("#psiattribute11").val();
		var catvalue = $("#psiattribute15").val();
		var wtvalue = $("#psiattribute18").val();
		var misvalue = $("#psiattribute20").val();
		var tnpvalue = $("#psiattribute24").val();
		var admvalue = $("#psiattribute26").val();
		//var wtvalue2 = $("#psiattribute35").val();
		
		checkBookingType(purvalue, false);
		checkMISSupport(misvalue, false);
		checkCategoryType(catvalue, false);
		
		//if(wtvalue != undefined)
		checkWaterTea(wtvalue, false);
		//else
		//	checkWaterTea(wtvalue2, false);
		
		CheckTNP(tnpvalue, false);
		checkADMSupport(admvalue, false);
		
		setDefaultValue($('[name="reservationAction"]').val());
		
		$("#psiattribute11").change(function (e) {
			var invalue = $("#psiattribute11").val();
			checkBookingType(invalue,true);
		});
		
		$("#psiattribute18").change(function () {
			var invalue = $("#psiattribute18").val();
			checkWaterTea(invalue,true);
		});
		
		$("#psiattribute35").change(function () {
			var invalue = $("#psiattribute35").val();
			checkWaterTea(invalue,true);
		});
		
		$("#psiattribute20").change(function () {
			var invalue = $("#psiattribute20").val();
			checkMISSupport(invalue,true);
		});
		
		$("#psiattribute15").change(function () {
			var invalue = $("#psiattribute15").val();
			checkCategoryType(invalue,true);
		});
		
		$("#psiattribute24").change(function () {
			var invalue = $("#psiattribute24").val();
			CheckTNP(invalue,true);
		});
		
		$("#psiattribute26").change(function () {
			var invalue = $("#psiattribute26").val();
			checkADMSupport(invalue,true);
		});
		
		
		//var teamScores = [];
		//$.get("results.json", function(data, status){
		//	$.each(data, function(index, value) {				
		//		teamScores.push(value.value);
		//	});
			
		//	$( "#psiattribute12" ).autocomplete({
		//		minLength: 2,
		//		source: teamScores
		//	});
		//});
					
		
	});
	
	function isInteger(num) 
	{
		return (num ^ 0) === num;
	}

	function checkCategoryType(invalue, isUserTrigger)
	{
		if(isUserTrigger)
		{
			//$("#psiattribute35").prop('selectedIndex', 0);  
			//checkWaterTea($("#psiattribute35").val(), true);
		}
		
		if(invalue == "Type A")
		{	
			$('#section_typea').show();
			$('#section_typea_att').show();
			
		}
		else
		{
			$('#section_typea').hide();
			$('#section_typea_att').hide();
		}
	}
	
	function checkBookingType(invalue, isUserTrigger)
	{			
		switch(invalue)
		{
			case "Internal Meeting":		
				if(isUserTrigger)
				{
					$("#psiattribute12").val("--");		
					$("#psiattribute13").val("");			
					$("#psiattribute16").val("--");		
					$("#psiattribute17").val("--");
				}
				
				$("#psiattribute12").attr("readonly",true);
				$("#psiattribute13").attr("readonly",false);
				$("#psiattribute16").attr("readonly",true);
				$("#psiattribute17").attr("readonly",true);
				
				$("#icpsiattribute12").hide();
				$("#icpsiattribute13").show();
				$("#icpsiattribute16").hide();
				$("#icpsiattribute17").hide();
			break;
			case "External Meeting":					
				if(isUserTrigger)
				{
					$("#psiattribute12").val("");			
					$("#psiattribute13").val("");			
					$("#psiattribute16").val("--");		
					$("#psiattribute17").val("--");
				}
				$("#psiattribute12").attr("readonly",false);
				$("#psiattribute13").attr("readonly",false);
				$("#psiattribute16").attr("readonly",true);
				$("#psiattribute17").attr("readonly",true);
				
				$("#icpsiattribute12").show();
				$("#icpsiattribute13").show();
				$("#icpsiattribute16").hide();
				$("#icpsiattribute17").hide();
			break;
			case "Interview":					
				if(isUserTrigger)
				{				
					$("#psiattribute12").val("--");			
					$("#psiattribute13").val("--");			
					$("#psiattribute16").val("--");		
					$("#psiattribute17").val("--");
				}
				$("#psiattribute12").attr("readonly",true);
				$("#psiattribute13").attr("readonly",true);
				$("#psiattribute16").attr("readonly",true);
				$("#psiattribute17").attr("readonly",true);
				
				$("#icpsiattribute12").hide();
				$("#icpsiattribute13").hide();
				$("#icpsiattribute16").hide();
				$("#icpsiattribute17").hide();
			break;
			case "Training":				
				if(isUserTrigger)
				{
					$("#psiattribute12").val("");			
					$("#psiattribute13").val("");			
					$("#psiattribute16").val("");		
					$("#psiattribute17").val("--");
				}
				$("#psiattribute12").attr("readonly",false);
				$("#psiattribute13").attr("readonly",false);
				$("#psiattribute16").attr("readonly",false);
				$("#psiattribute17").attr("readonly",true);
				
				$("#icpsiattribute12").show();
				$("#icpsiattribute13").show();
				$("#icpsiattribute16").show();
				$("#icpsiattribute17").hide();
				break;
			case "Workshop":				
				if(isUserTrigger)
				{
					$("#psiattribute12").val("");			
					$("#psiattribute13").val("");			
					$("#psiattribute16").val("");		
					$("#psiattribute17").val("--");
				}
				$("#psiattribute12").attr("readonly",false);
				$("#psiattribute13").attr("readonly",false);
				$("#psiattribute16").attr("readonly",false);
				$("#psiattribute17").attr("readonly",true);
				
				$("#icpsiattribute12").show();
				$("#icpsiattribute13").show();
				$("#icpsiattribute16").show();
				$("#icpsiattribute17").hide();
				break;
			case "Event / Party":				
				if(isUserTrigger)
				{
					$("#psiattribute12").val("");			
					$("#psiattribute13").val("");			
					$("#psiattribute16").val("");		
					$("#psiattribute17").val("--");
				}
				$("#psiattribute12").attr("readonly",false);
				$("#psiattribute13").attr("readonly",false);
				$("#psiattribute16").attr("readonly",false);
				$("#psiattribute17").attr("readonly",true);
				
				$("#icpsiattribute12").show();
				$("#icpsiattribute13").show();
				$("#icpsiattribute16").show();
				$("#icpsiattribute17").hide();
				break;
			case "Others":				
				if(isUserTrigger)
				{
					$("#psiattribute12").val("");			
					$("#psiattribute13").val("");			
					$("#psiattribute16").val("");		
					$("#psiattribute17").val("");	
				}
				$("#psiattribute12").attr("readonly",false);
				$("#psiattribute13").attr("readonly",false);
				$("#psiattribute16").attr("readonly",false);
				$("#psiattribute17").attr("readonly",false);
				
				$("#icpsiattribute12").show();
				$("#icpsiattribute13").show();
				$("#icpsiattribute16").show();
				$("#icpsiattribute17").show();
				break;
			default:
				if(isUserTrigger)
				{
					$("#psiattribute12").val("--");			
					$("#psiattribute13").val("--");			
					$("#psiattribute16").val("--");		
					$("#psiattribute17").val("--");
				}
				$("#psiattribute12").attr("readonly",true);
				$("#psiattribute13").attr("readonly",true);
				$("#psiattribute16").attr("readonly",true);
				$("#psiattribute17").attr("readonly",true);
				
				$("#icpsiattribute12").hide();
				$("#icpsiattribute13").hide();
				$("#icpsiattribute16").hide();
				$("#icpsiattribute17").hide();
			break;
			
		}
	}
	
	function checkWaterTea(invalue, isUserTrigger)
	{
		var qtyvalue = $("#psiattribute6").val();
		
		if(isInteger(qtyvalue))
		{
			if(qtyvalue < 0)
				qtyvalue = 0;
		}			
		
		switch(invalue)
		{
			case "":
				$("#psiattribute19").attr("readonly",true);
				$("#icpsiattribute19").hide();
				if(isUserTrigger)
					$("#psiattribute19").val("0");
			break;
			case "On Request":
				$("#psiattribute19").attr("readonly",true);
				$("#icpsiattribute19").hide();
				if(isUserTrigger)
					$("#psiattribute19").val("0");
			break;
			default:
				$("#psiattribute19").attr("readonly",false);
				$("#icpsiattribute19").show();
				if(qtyvalue != 0 && isUserTrigger)
					$("#psiattribute19").val(qtyvalue);				
				else if(qtyvalue == 0 && isUserTrigger)
					$("#psiattribute19").val("");
			break;
		}	
	}
	
	function checkMISSupport(invalue, isUserTrigger)
	{			
		switch(invalue)
		{
			case "Yes":
			$("#psiattribute21").attr("readonly",false);
			$("#icpsiattribute21").show();
			
			if(isUserTrigger)
				$("#psiattribute21").val("");
			break;
			default:
				$("#psiattribute21").attr("readonly",true);					
				$("#icpsiattribute21").hide();
				if(isUserTrigger)
					$("#psiattribute21").val("--");
			break;
		}	
	}	
	
	function checkADMSupport(invalue, isUserTrigger)
	{			
		switch(invalue)
		{
			case "Yes":
			$("#psiattribute27").attr("readonly",false);
			$("#icpsiattribute27").show();
			
			if(isUserTrigger)
				$("#psiattribute27").val("");
			break;
			
			default:
				$("#psiattribute27").attr("readonly",true);					
				$("#icpsiattribute27").hide();
				if(isUserTrigger)
					$("#psiattribute27").val("--");
			break;
		}	
	}	
	
	function CheckTNP(invalue, isUserTrigger)
	{			
		switch(invalue)
		{
			case "Yes":
			$("#psiattribute25").attr("readonly",false);
			$("#icpsiattribute25").show();
			
			if(isUserTrigger)
				$("#psiattribute25").val("");
			break;
			
			default:
				$("#psiattribute25").attr("readonly",true);					
				$("#icpsiattribute25").hide();
				if(isUserTrigger)
					$("#psiattribute25").val("--");
			break;
		}	
	}	
	
	function setDefaultValue(inType)
	{
		if($("#reservationTitle").val() == "")
			$("#reservationTitle").val($("#cur_hide_name").val());
		
		if($("#psiattribute7").val() == "")
			$("#psiattribute7").val($("#cur_hide_email").val());
		
		if($("#psiattribute10").val() == "")
			$("#psiattribute10").val($("#cur_hide_phone").val());		
		
		if($("#psiattribute19").val() == "")
		{
			$("#psiattribute19").val("0");
			$("#psiattribute19").attr("readonly",true);
		}
		
		if($("#psiattribute21").val() == "")
		{
			$("#psiattribute21").val("--");			
			$("#psiattribute21").attr("readonly",true);
		}
	
		if($("#psiattribute12").val() == "")
			$("#psiattribute12").val("--");	
	
		if(inType == "update")
		{
			if($("#psiattribute13").val() == "")
				$("#psiattribute13").val("--");	
		}
	
		if($("#psiattribute16").val() == "")
			$("#psiattribute16").val("--");		
	
		if($("#psiattribute17").val() == "")
			$("#psiattribute17").val("--");

		if($("#psiattribute25").val() == "")
		{
			$("#psiattribute25").val("--");					
			$("#psiattribute25").attr("readonly",true);
		}
	
		if($("#psiattribute27").val() == "")
		{
			$("#psiattribute27").val("--");
			$("#psiattribute27").attr("readonly",true);
		}		
		
		if($("#psiattribute15").val() == "Type A")
		{	
			$('#section_typea').show();
			$('#section_typea_att').show();
		}
		else
		{
			$('#section_typea').hide();
			$('#section_typea_att').hide();
		}
	}
		
	</script>
{/if}