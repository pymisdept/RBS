<?php
/**
 * Copyright 2012-2018 Nick Korbel
 *
 * This file is part of Booked Scheduler is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Booked Scheduler.  If not, see <http://www.gnu.org/licenses/>.
 */

require_once(ROOT_DIR . 'lib/Email/namespace.php');
require_once(ROOT_DIR . 'Pages/Pages.php');
require_once(ROOT_DIR . 'Pages/Export/CalendarExportDisplay.php');
require_once(ROOT_DIR . 'lib/Application/Schedule/namespace.php');
require_once(ROOT_DIR . 'lib/Application/Reservation/namespace.php');
require_once(ROOT_DIR . 'Domain/Access/namespace.php');

abstract class ReservationEmailMessage extends EmailMessage
{
	/**
	 * @var User
	 */
	protected $reservationOwner;

	/**
	 * @var ReservationSeries
	 */
	protected $reservationSeries;

	/**
	 * @var IResource
	 */
	protected $primaryResource;

	/**
	 * @var string
	 */
	protected $timezone;

	/**
	 * @var IAttributeRepository
	 */
	protected $attributeRepository;

	public function __construct(User $reservationOwner, ReservationSeries $reservationSeries, $language = null, IAttributeRepository $attributeRepository)
	{
		if (empty($language))
		{
			$language = $reservationOwner->Language();
		}
		parent::__construct($language);

		$this->reservationOwner = $reservationOwner;
		$this->reservationSeries = $reservationSeries;
		$this->timezone = $reservationOwner->Timezone();
		$this->attributeRepository = $attributeRepository;
		$this->primaryResource = $reservationSeries->Resource();
	}

	/**
	 * @abstract
	 * @return string
	 */
	protected abstract function GetTemplateName();

	public function To()
	{
		$attributes = $this->attributeRepository->GetByCategory(CustomAttributeCategory::RESERVATION);
		$attributeValues = array();
		$emailArr = array();
		
		foreach ($attributes as $attribute)
		{
			//error_log($attribute->id());			
			if($attribute->id() == 7)
			{
				$arr_CPEMAIL = explode (";", $this->reservationSeries->GetAttributeValue($attribute->Id()));
				
				for($i = 0 ; $i < count($arr_CPEMAIL) ; $i++)
				{
					if($arr_CPEMAIL[$i] != '')
						array_push($emailArr, new EmailAddress($arr_CPEMAIL[$i], ''));
				}
			}
		}
		
		return $emailArr;
	}
	
	public function CC()
	{
		$attributes = $this->attributeRepository->GetByCategory(CustomAttributeCategory::RESERVATION);
		$address = $this->reservationOwner->EmailAddress();
		$name = $this->reservationOwner->FullName();
		
		$sp_roomID = Configuration::Instance()->GetSectionKey(ConfigSection::EMAIL, ConfigKeys::SPECIAL_ROOM_ID);
		
		$nmList = Configuration::Instance()->GetSectionKey(ConfigSection::EMAIL, ConfigKeys::NORMAL_ROOM_CC_LIST);
		$spList = Configuration::Instance()->GetSectionKey(ConfigSection::EMAIL, ConfigKeys::SPECIAL_ROOM_CC_LIST);
		$taList = Configuration::Instance()->GetSectionKey(ConfigSection::EMAIL, ConfigKeys::TYPEA_CC_LIST);
		
		$rAddress = Configuration::Instance()->GetSectionKey(ConfigSection::EMAIL, ConfigKeys::RECEPTION_EMAIL_ADDRESS);
		$aAddress = Configuration::Instance()->GetSectionKey(ConfigSection::EMAIL, ConfigKeys::ADMIN_EMAIL_ADDRESS);
		$mAddress = Configuration::Instance()->GetSectionKey(ConfigSection::EMAIL, ConfigKeys::MIS_EMAIL_ADDRESS);
		$msAddress = Configuration::Instance()->GetSectionKey(ConfigSection::EMAIL, ConfigKeys::MISSUPORT_EMAIL_ADDRESS);
		$cAddress = Configuration::Instance()->GetSectionKey(ConfigSection::EMAIL, ConfigKeys::CORPCOMM_EMAIL_ADDRESS);		
		$sAddress = Configuration::Instance()->GetSectionKey(ConfigSection::EMAIL, ConfigKeys::SECURITY_EMAIL_ADDRESS);
		
		$arr_SPRID = explode (";", $sp_roomID);
		$cur_id = $this->reservationSeries->Resource()->GetResourceId();
				
		$misSupport = false;
		$isSPR = false;
		$isSTA = false;
		
		// Check if SP Room
		for($i = 0 ; $i < count($arr_SPRID) ; $i++)
		{
			if($arr_SPRID[$i] == $cur_id)
			{
				$isSPR = true;
				break;
			}
		}
		
		// Check if Type A 
		// Check if need MIS Support
		if($isSPR)		
		{
			if($this->reservationSeries->GetAttributeValue(15) == "Type A")
				$isSTA = true;
		}
		
		if($this->reservationSeries->GetAttributeValue(20) == "Yes")
				$misSupport = true;
		
		$list = "";
		if($isSTA)
			$list = $taList;
		else if($isSPR)
			$list = $spList;
		else
		{
			$list = $nmList;
			if($misSupport)
			{
				if (strpos($list, '[MISSuport]') === false) 
				{
					$list = $list.";[MISSuport]";
				}	
			}
		}
		
		//error_log($list);
		
		$list = str_replace("[Reception]",$rAddress,$list);
		$list = str_replace("[Admin]",$aAddress,$list);
		$list = str_replace("[MIS]",$mAddress,$list);
		$list = str_replace("[MISSuport]",$msAddress,$list);
		$list = str_replace("[CorpComm]",$cAddress,$list);
		$list = str_replace("[Security]",$sAddress,$list);
		
		$arrEmail = explode (";", $list);	
		$emailArr = array();
		
		//error_log($list);
		
		for($j = 0 ; $j < count($arrEmail) ; $j++)
		{	if(trim($arrEmail[$j]) != '')
				array_push($emailArr, new EmailAddress(trim($arrEmail[$j]), ''));
		}
		
		return $emailArr;
	}

	public function Body()
	{
		$this->PopulateTemplate();
		return $this->FetchTemplate($this->GetTemplateName());
	}

	public function From()
	{
		$bookedBy = $this->reservationSeries->BookedBy();
		if ($bookedBy != null)
		{
			$name = new FullName($bookedBy->FirstName, $bookedBy->LastName);
			return new EmailAddress($bookedBy->Email, $name->__toString());
		}
		return new EmailAddress($this->reservationOwner->EmailAddress(), $this->reservationOwner->FullName());
	}

	protected function PopulateTemplate()
	{
		$currentInstance = $this->reservationSeries->CurrentInstance();
		$this->Set('UserName', $this->reservationOwner->FullName());
		$this->Set('StartDate', $currentInstance->StartDate()->ToTimezone($this->timezone));
		$this->Set('EndDate', $currentInstance->EndDate()->ToTimezone($this->timezone));
		$this->Set('ResourceName', $this->reservationSeries->Resource()->GetName());
		$img = $this->reservationSeries->Resource()->GetImage();
		if (!empty($img))
		{
			$this->Set('ResourceImage', $this->GetFullImagePath($img));
		}
		$this->Set('Title', $this->reservationSeries->Title());
		$this->Set('Description', $this->reservationSeries->Description());

		$repeatDates = array();
		$repeatRanges = array();
		if ($this->reservationSeries->IsRecurring())
		{
			foreach ($this->reservationSeries->Instances() as $repeated)
			{
				$repeatDates[] = $repeated->StartDate()->ToTimezone($this->timezone);
				$repeatRanges[] = $repeated->Duration()->ToTimezone($this->timezone);
			}
		}
		$this->Set('RepeatDates', $repeatDates);
		$this->Set('RepeatRanges', $repeatRanges);
		$this->Set('RequiresApproval', $this->reservationSeries->RequiresApproval());
		$this->Set('ReservationUrl', sprintf("%s?%s=%s", Pages::RESERVATION, QueryStringKeys::REFERENCE_NUMBER, $currentInstance->ReferenceNumber()));
		$icalUrl = sprintf("export/%s?%s=%s", Pages::CALENDAR_EXPORT, QueryStringKeys::REFERENCE_NUMBER, $currentInstance->ReferenceNumber());
		$this->Set('ICalUrl', $icalUrl);

		$resourceNames = array();
		foreach ($this->reservationSeries->AllResources() as $resource)
		{
			$resourceNames[] = $resource->GetName();
		}
		
		$this->Set('ResourceNames', $resourceNames);
		$this->Set('Accessories', $this->reservationSeries->Accessories());

		
		$this->Set('Attr_NOP', $this->reservationSeries->GetAttributeValue(6));
					
		$this->Set('Attr_Ext', $this->reservationSeries->GetAttributeValue(10));
			
		$this->Set('Attr_Purpose', $this->reservationSeries->GetAttributeValue(11));
			
		$this->Set('Attr_Client', $this->reservationSeries->GetAttributeValue(12));
			
		$this->Set('Attr_PYR', $this->reservationSeries->GetAttributeValue(13));
			
		if($this->reservationSeries->Resource()->GetId() == 18)
			$this->Set('Attr_Seating', $this->reservationSeries->GetAttributeValue(14));		
		else
			$this->Set('Attr_Seating', $this->reservationSeries->GetAttributeValue(37));
			
		$this->Set('Attr_Cat', $this->reservationSeries->GetAttributeValue(15));
			
		$this->Set('Attr_Topic', $this->reservationSeries->GetAttributeValue(16));
			
		$this->Set('Attr_OtherPurpose', $this->reservationSeries->GetAttributeValue(17));
		
		$this->Set('Attr_Drinks', $this->reservationSeries->GetAttributeValue(18));		
		
		$this->Set('Attr_DrinkQty', $this->reservationSeries->GetAttributeValue(19));
			
		$this->Set('Attr_MISS', $this->reservationSeries->GetAttributeValue(20));
						
		$this->Set('Attr_MISR', $this->reservationSeries->GetAttributeValue(21));		
		
		$this->Set('Attr_TA_Carpet', $this->reservationSeries->GetAttributeValue(22));		
		
		$this->Set('Attr_TA_Board', $this->reservationSeries->GetAttributeValue(23));	
		
		$this->Set('Attr_TA_NamePlate', $this->reservationSeries->GetAttributeValue(24));
		
		$this->Set('Attr_TA_NOP', $this->reservationSeries->GetAttributeValue(25));		
		
		$this->Set('Attr_TA_ADMS', $this->reservationSeries->GetAttributeValue(26));	
		
		$this->Set('Attr_TA_ADMR', $this->reservationSeries->GetAttributeValue(27));	
		
		$this->Set('Attr_TA_Photo', $this->reservationSeries->GetAttributeValue(28));		
				
		$this->Set('Attr_TA_CoprVDO', $this->reservationSeries->GetAttributeValue(30));	
		
		$this->Set('Attr_TA_Tour', $this->reservationSeries->GetAttributeValue(29));	
		
		$this->Set('Attr_TA_Photo', $this->reservationSeries->GetAttributeValue(28));		
		
		$this->Set('Attr_TA_Pickup', $this->reservationSeries->GetAttributeValue(34));	
		
		$this->Set('Attr_TA_Decor', $this->reservationSeries->GetAttributeValue(31));	
		
		$this->Set('Attr_TA_Dinning', $this->reservationSeries->GetAttributeValue(32));	
		
		$this->Set('Attr_TA_Snack', $this->reservationSeries->GetAttributeValue(33));	
		

		$bookedBy = $this->reservationSeries->BookedBy();
		if ($bookedBy != null && ($bookedBy->UserId != $this->reservationOwner->Id()))
		{
			$this->Set('CreatedBy', new FullName($bookedBy->FirstName, $bookedBy->LastName));
		}

		$minimumAutoRelease = null;
		foreach ($this->reservationSeries->AllResources() as $resource)
		{
			if ($resource->IsCheckInEnabled())
			{
				$this->Set('CheckInEnabled', true);
			}

			if ($resource->IsAutoReleased())
			{
				if ($minimumAutoRelease == null || $resource->GetAutoReleaseMinutes() < $minimumAutoRelease)
				{
					$minimumAutoRelease = $resource->GetAutoReleaseMinutes();
				}
			}
		}
	
		/*
        $this->PopulateIcsAttachment($currentInstance, $attributeValues);
		*/
		
		$this->Set('AutoReleaseMinutes', $minimumAutoRelease);
		$this->Set('ReferenceNumber', $this->reservationSeries->CurrentInstance()->ReferenceNumber());
	}

	private function GetFullImagePath($img)
	{
		return Configuration::Instance()->GetKey(ConfigKeys::IMAGE_UPLOAD_URL) . '/' . $img;
	}

    /**
     * @param Reservation $currentInstance
     * @param Attribute[] $attributeValues
     */
    protected function PopulateIcsAttachment($currentInstance, $attributeValues)
    {
        $rv = new ReservationItemView($currentInstance->ReferenceNumber(),
            $currentInstance->StartDate()->ToUTC(),
            $currentInstance->EndDate()->ToUTC(),
            $this->reservationSeries->Resource()->GetName(),
            $this->reservationSeries->Resource()->GetResourceId(),
            $currentInstance->ReservationId(),
            null,
            $this->reservationSeries->Title(),
            $this->reservationSeries->Description(),
            $this->reservationSeries->ScheduleId(),
            $this->reservationOwner->FirstName(),
            $this->reservationOwner->LastName(),
            $this->reservationOwner->Id(),
            $this->reservationOwner->GetAttribute(UserAttribute::Phone),
            $this->reservationOwner->GetAttribute(UserAttribute::Organization),
            $this->reservationOwner->GetAttribute(UserAttribute::Position)
        );

        $ca = new CustomAttributes();
        /** @var Attribute $attribute */
        foreach ($attributeValues as $attribute) {
            $ca->Add($attribute->Id(), $attribute->Value());
        }
        $rv->Attributes = $ca;
        $rv->UserPreferences = $this->reservationOwner->GetPreferences();
		$rv->OwnerEmailAddress = $this->reservationOwner->EmailAddress();

        $icsView = new iCalendarReservationView($rv, $this->reservationSeries->BookedBy(), new NullPrivacyFilter());

        $display = new CalendarExportDisplay();
        $icsContents = $display->Render(array($icsView));
        $this->AddStringAttachment($icsContents, 'reservation.ics');
    }
}