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
	byte positionOnMap : "ePSXe.exe", 0x84F920;
}

start
{
	//FUNCTIONS

	current.isStartingLevel = new Func<dynamic, dynamic, bool>((oldState, currentState) => 
		oldState.startingLevel==0 && currentState.startingLevel==1 &&
			oldState.inLevel==0 && currentState.inLevel==0 && //Fixes cases 2-4
			oldState.inCutscene==0 && currentState.inCutscene==0 && //Fixes case 5
			oldState.inContinue==0 && currentState.inContinue==0 //Fixes case 6
	);

	//Don't split on first Pink Plant Woods entry and Eraser Plains reentries
	current.entryExceptions = new Func<dynamic, bool>((currentState) => 
		(currentState.positionOnMap==0 && currentState.cageCount==0) || (currentState.positionOnMap==11 && currentState.cageCount==67)
	);


	if(current.isStartingLevel(old, current))
	{
		return !current.entryExceptions(current);
	}

	return false;
}

split
{
	if(current.isStartingLevel(old, current))
	{
		return !current.entryExceptions(current);
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
	//Doesn't work when starting splits from a Level instead of menu!
	if(current.isStartingLevel(old, current))
	{
		current.loading=true;
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