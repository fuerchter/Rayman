state("ePSXe")
{
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
	byte notInMenu : "ePSXe.exe", 0x82F3F0;
	byte menuScreenNo : "ePSXe.exe", 0x84FB40;

	byte inLevel : "ePSXe.exe", 0x826821;
	byte onMap : "ePSXe.exe", 0x84DB87;

	byte inCutscene : "ePSXe.exe", 0x84BD78;
	byte inContinue : "ePSXe.exe", 0x8304E0;
	byte positionOnMap : "ePSXe.exe", 0x84F920;
	byte cageCount : "ePSXe.exe", 0x84FAD8;

	byte finalBossHp : "ePSXe.exe", 0x6FE94C;
	byte win : "ePSXe.exe", 0x6FE949;
}

start
{
	current.loading=false;
	current.moskitoEntries=0;
	current.eraserEntries=0;
	
	//FUNCTIONS
	current.isStarting = new Func<dynamic, dynamic, bool>((oldState, currentState) => 
		oldState.startingLevel==0 && currentState.startingLevel==1 &&
			currentState.menuScreenNo==4 && oldState.notInMenu==0
	);

	current.isStartingLevel = new Func<dynamic, dynamic, bool>((oldState, currentState) => 
		oldState.startingLevel==0 && currentState.startingLevel==1 &&
			oldState.inLevel==0 && currentState.inLevel==0 && //Fixes cases 2-4
			oldState.inCutscene==0 && currentState.inCutscene==0 && //Fixes case 5
			oldState.inContinue==0 && currentState.inContinue==0 //Fixes case 6
	);

	return current.isStarting(old, current);
}

split
{
	if(current.isStartingLevel(old, current))
	{
		if(current.positionOnMap==0 && current.cageCount==0) //Don't split on first Pink Plant Woods entry
		{
			return false;
		}
		if(current.positionOnMap==3)
		{
			if(current.moskitoEntries<2) //Only split for two Moskito entries
			{
				current.moskitoEntries++;
				return true;
			}
			else
			{
				return false;
			}
		}
		if(current.positionOnMap==11) //Only split for one Eraser entry
		{
			if(current.eraserEntries<1)
			{
				current.eraserEntries++;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		return true;
	}

	//Final Split
	if(current.win==1 && old.finalBossHp==0 && current.positionOnMap==17)
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
	if((current.isStartingLevel(old, current) && !current.isStarting(old, current)) || (old.inLevel==1 && current.inLevel==0 && old.inCutscene==0 && current.inCutscene==0 && old.inContinue==0 && current.inContinue==0))
	{
		current.loading=true;
	}

	if(current.loading && (current.inLevel==1 || current.onMap==1))
	{
		current.loading=false;
	}
	return current.loading;
}

gameTime
{

}