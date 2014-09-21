state("ePSXe")
{
	//Still splitting in menu!

	/*
		Activity:
		1.	map -> ingame				1

		2.	ingame -> cutscene			0
		3.	ingame -> ingame (death)	0
		4.	ingame -> continue			0

		5.	cutscene -> ingame			0
		6.	continue -> ingame			0
	*/
	byte startingLevel : "ePSXe.exe", 0x84F990;

	byte inLevel : "ePSXe.exe", 0x826821;

	byte inCutscene : "ePSXe.exe", 0x84BD78;
	byte inContinue : "ePSXe.exe", 0x8304E0;
	byte positionOnMap : "ePSXe.exe", 0x84F920;
	byte cageCount : "ePSXe.exe", 0x84FAD8;

	byte finalBossHp : "ePSXe.exe", 0x6FE94C;
	byte win : "ePSXe.exe", 0x6FE949;
}

start
{
	if(old.startingLevel==0 && current.startingLevel==1)
	{
		if(	old.inLevel==0 && current.inLevel==0 && //Fixes cases 2-4
			old.inCutscene==0 && current.inCutscene==0 && //Fixes case 5
			old.inContinue==0 && current.inContinue==0) //Fixes case 6
		{
			//Don't split on first Pink Plant Woods entry and Eraser Plains reentries
			if((current.positionOnMap==0 && current.cageCount==0) || (current.positionOnMap==11 && current.cageCount==67))
			{
				return false;
			}
			else
			{
				return true;
			}
		}
	}

	return false;
}

split
{
	if(old.startingLevel==0 && current.startingLevel==1)
	{
		if(	old.inLevel==0 && current.inLevel==0 && //Fixes cases 2-4
			old.inCutscene==0 && current.inCutscene==0 && //Fixes case 5
			old.inContinue==0 && current.inContinue==0) //Fixes case 6
		{
			//Don't split on first Pink Plant Woods entry and Eraser Plains reentries
			if((current.positionOnMap==0 && current.cageCount==0) || (current.positionOnMap==11 && current.cageCount==67))
			{
				return false;
			}
			else
			{
				return true;
			}
		}
	}

	//Final Split
	if(current.win==1 && old.finalBossHp==0)
	{
		return true;
	}

	return false;
}

reset
{

}

isLoading
{
	//Current load timing: When entering a Level to actually having control
	//Doesn't work when starting splits from a Level instead of menu!
	if(old.startingLevel==0 && current.startingLevel==1)
	{
		if(	old.inLevel==0 && current.inLevel==0 && //Fixes cases 2-4
			old.inCutscene==0 && current.inCutscene==0 && //Fixes case 5
			old.inContinue==0 && current.inContinue==0) //Fixes case 6
		{
			current.loading=true;
		}
	}

	if(current.loading && current.inLevel==1)
	{
		current.loading=false;
	}
	return current.loading;
}

gameTime
{

}